Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6437D29DF7
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 09:58:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 027E7AC00D
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 07:58:21 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nGyMy6HxJSnN2d0h for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 07:58:12 -0800 (PST)
Message-ID: <5475F892.5000102@sandeen.net>
Date: Wed, 26 Nov 2014 09:58:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: catch invalid negative blknos in _xfs_buf_find()
References: <546D15E3.5000200@redhat.com>
In-Reply-To: <546D15E3.5000200@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/19/14 4:12 PM, Eric Sandeen wrote:
> Here blkno is a daddr_t, which is a __s64; it's possible to hold
> a value which is negative, and thus pass the (blkno >= eofs)
> test.  Then we try to do a xfs_perag_get() for a ridiculous
> agno via xfs_daddr_to_agno(), and bad things happen when that
> fails, and returns a null pag which is dereferenced shortly
> thereafter.
> 
> Found via a user-supplied fuzzed image...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Ok, so after further digging, I think this patch is fine on its own,
and could use review.  How and if and when this function returns errors,
and whether errors should get this far, etc, are all subjects for other
patches.  IF we're range-checking here, we should do both halves
of the range checking properly so ... review appreciated.

Thanks,
-Eric

> ---
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 24b4ebe..f54a497 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -463,7 +463,7 @@ _xfs_buf_find(
>  	 * have to check that the buffer falls within the filesystem bounds.
>  	 */
>  	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> -	if (blkno >= eofs) {
> +	if (blkno < 0 || blkno >= eofs) {
>  		/*
>  		 * XXX (dgc): we should really be returning -EFSCORRUPTED here,
>  		 * but none of the higher level infrastructure supports
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
