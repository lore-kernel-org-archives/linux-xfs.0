Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 43AA67F3F
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 07:37:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06B54304039
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 05:37:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SRiMdKIqcpreV5uW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 05:37:08 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sABDb7Ur011545
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 08:37:07 -0500
Date: Tue, 11 Nov 2014 08:37:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_copy: simplify first_agbno calculation
Message-ID: <20141111133705.GA38867@bfoster.bfoster>
References: <54613907.2000007@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54613907.2000007@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Zorro Lang <zlang@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Nov 10, 2014 at 04:15:35PM -0600, Eric Sandeen wrote:
> After ffe9a9a xfsprogs: xfs_copy: fix data corruption of target,
> xfs_copy started hitting an ASSERT for a 4k sector / 4k blocksize
> filesystem:
> 
> # dd if=/dev/zero of=test.img bs=1M count=1024
> # mkfs.xfs -s size=4096 test.img
> # xfs_copy test.img xfs.img
> xfs_copy: xfs_copy.c:720: main: Assertion `((((((xfs_daddr_t)(3 << (mp)->m_sectbb_log)) + 1) * (1<<9)) + first_residue) % source_blocksize) == 0' failed.
> Aborted
> 
> I started digging through all the calculations below, and realized
> that in the end, all it wants is the first filesystem block after
> the AG header.  XFS_AGFL_BLOCK(mp) + 1 suffices for this purpose;
> rip out the rest which seems overly complex and apparently bug-prone.
> 
> I tested this by creating a 4g filesystem with combinations of
> sector & block size between 512 and 4k, copying in /lib/modules,
> running an xfs_copy of that, and running repair against the copy;
> it all looks good.  It took a long time, but I will create a
> simpler/shorter xfstest based on this.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

I just noticed the bug... so the problem was basically the assumption
that sector size == BBSIZE?

Brian

> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 7ce5ec9..279527c 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -475,7 +475,7 @@ main(int argc, char **argv)
>  	int		open_flags;
>  	xfs_off_t	pos, end_pos;
>  	size_t		length;
> -	int		c, first_residue, tmp_residue;
> +	int		c;
>  	__uint64_t	size, sizeb;
>  	__uint64_t	numblocks = 0;
>  	int		wblocks = 0;
> @@ -697,27 +697,13 @@ main(int argc, char **argv)
>  	ASSERT(source_blocksize % source_sectorsize == 0);
>  	ASSERT(source_sectorsize % BBSIZE == 0);
>  
> -	if (source_blocksize > source_sectorsize)  {
> -		/* get number of leftover sectors in last block of ag header */
> -
> -		tmp_residue = ((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
> -					% source_blocksize;
> -		first_residue = (tmp_residue == 0) ? 0 :
> -			source_blocksize - tmp_residue;
> -		ASSERT(first_residue % source_sectorsize == 0);
> -	} else if (source_blocksize == source_sectorsize)  {
> -		first_residue = 0;
> -	} else  {
> +	if (source_blocksize < source_sectorsize)  {
>  		do_log(_("Error:  filesystem block size is smaller than the"
>  			" disk sectorsize.\nAborting XFS copy now.\n"));
>  		exit(1);
>  	}
>  
> -	first_agbno = (((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
> -				+ first_residue) / source_blocksize;
> -	ASSERT(first_agbno != 0);
> -	ASSERT(((((XFS_AGFL_DADDR(mp) + 1) * BBSIZE)
> -				+ first_residue) % source_blocksize) == 0);
> +	first_agbno = XFS_AGFL_BLOCK(mp) + 1;
>  
>  	/* now open targets */
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
