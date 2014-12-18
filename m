Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E39E87F51
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:18:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4EFE30407E
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:18:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cnqncAg1x3bFZVrW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:18:41 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBIFIfC1005448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 10:18:41 -0500
Date: Thu, 18 Dec 2014 10:18:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: fix max block offset test
Message-ID: <20141218151835.GC13471@laptop.bfoster>
References: <5489DA3B.5050908@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5489DA3B.5050908@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 11, 2014 at 11:54:03AM -0600, Eric Sandeen wrote:
> Eryu pointed out that in fstest xfs/071, we find corruption
> reported at the end.  This test attempts to do IO at the
> maximum possible offsets, and repair yields:
> 
> inode 1027 - extent offset too large - start 70, count 1, offset 2251799813685247
> correcting nextents for inode 1027
> bad data fork in inode 1027
> would have cleared inode 1027
> 
> Repair is complaining that an extent *starts* at the maximum
> block, but AFAICT, starting there is just fine, as long as
> we also end there.  i.e. a one-block extent at the limit
> is just fine.
> 
> So change the xfs_repair test to allow this situation.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Thought this looked familiar:

http://oss.sgi.com/archives/xfs/2014-09/msg00524.html

Either one is fine with me. If we use the fix below, I think we should
update the error message since it technically refers to the extent
offset and we slightly tweak the meaning of the failure.

Brian

> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 38a6562..ca57a61 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -667,7 +667,9 @@ _("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
>  					irec.br_startoff);
>  				goto done;
>  		}
> -		if (irec.br_startoff >= fs_max_file_offset)  {
> +		/* Ensure this extent does not extend beyond the max offset */
> +		if (irec.br_startoff + irec.br_blockcount - 1 >
> +							fs_max_file_offset) {
>  			do_warn(
>  _("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
>    "count %" PRIu64 ", offset %" PRIu64 "\n"),
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
