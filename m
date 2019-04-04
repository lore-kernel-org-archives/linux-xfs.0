Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54954 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfDDQrk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:47:40 -0400
Subject: Re: [PATCH 46/36] xfs_scrub: remove pointless xfs_verify_error_info
 struct
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320200444.GJ1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <16fc5c2a-bd48-ca0d-b9fc-d1d4bfd9dc1d@sandeen.net>
Date: Thu, 4 Apr 2019 11:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <20190320200444.GJ1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 3:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xfs_verify_error_info structure is a strict subset of
> media_verify_info so just pass that around.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Uh, sorry but again, "*vei" isn't intuitive anymore...

> ---
>  scrub/phase6.c |   20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 2b4f6ff1..f173f248 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -111,11 +111,6 @@ xfs_decode_special_owner(
>  
>  /* Routines to translate bad physical extents into file paths and offsets. */
>  
> -struct xfs_verify_error_info {
> -	struct bitmap			*d_bad;		/* bytes */
> -	struct bitmap			*r_bad;		/* bytes */
> -};
> -
>  /* Report if this extent overlaps a bad region. */
>  static bool
>  xfs_report_verify_inode_bmap(
> @@ -127,7 +122,7 @@ xfs_report_verify_inode_bmap(
>  	struct xfs_bmap			*bmap,
>  	void				*arg)
>  {
> -	struct xfs_verify_error_info	*vei = arg;
> +	struct media_verify_state	*vei = arg;
>  	struct bitmap			*bmp;
>  
>  	/* Only report errors for real extents. */
> @@ -277,23 +272,18 @@ xfs_report_verify_dirent(
>  static bool
>  xfs_report_verify_errors(
>  	struct scrub_ctx		*ctx,
> -	struct bitmap			*d_bad,
> -	struct bitmap			*r_bad)
> +	struct media_verify_state	*ve)
>  {
> -	struct xfs_verify_error_info	vei;
>  	bool				moveon;
>  
> -	vei.d_bad = d_bad;
> -	vei.r_bad = r_bad;
> -
>  	/* Scan the directory tree to get file paths. */
>  	moveon = scan_fs_tree(ctx, xfs_report_verify_dir,
> -			xfs_report_verify_dirent, &vei);
> +			xfs_report_verify_dirent, ve);
>  	if (!moveon)
>  		return false;
>  
>  	/* Scan for unlinked files. */
> -	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, &vei);
> +	return xfs_scan_all_inodes(ctx, xfs_report_verify_inode, ve);
>  }
>  
>  /* Report an IO error resulting from read-verify based off getfsmap. */
> @@ -518,7 +508,7 @@ _("Could not create data device media verifier."));
>  
>  	/* Scan the whole dir tree to see what matches the bad extents. */
>  	if (!bitmap_empty(ve.d_bad) || !bitmap_empty(ve.r_bad))
> -		moveon = xfs_report_verify_errors(ctx, ve.d_bad, ve.r_bad);
> +		moveon = xfs_report_verify_errors(ctx, &ve);
>  
>  	bitmap_free(&ve.r_bad);
>  	bitmap_free(&ve.d_bad);
> 
