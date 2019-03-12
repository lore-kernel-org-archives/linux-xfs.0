Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfCLOWG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Mar 2019 10:22:06 -0400
Date: Tue, 12 Mar 2019 09:22:02 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 1/2] xfs: zero initialize highstale and lowstale in
 xfs_dir2_leaf_addname
Message-ID: <20190312142202.GA28037@redhat.com>
References: <20190311161948.GC4359@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311161948.GC4359@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com

On Mon, Mar 11, 2019 at 09:19:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Smatch complains about the following:
> 
> fs/xfs/libxfs/xfs_dir2_leaf.c:848 xfs_dir2_leaf_addname() error:
> uninitialized symbol 'lowstale'.
> 
> fs/xfs/libxfs/xfs_dir2_leaf.c:849 xfs_dir2_leaf_addname() error:
> uninitialized symbol 'highstale'.
> 
> I don't think there's any incorrect behavior associated with the
> uninitialized variable, but as the author of the previous zero-init
> patch points out, it's best not to be passing around pointers to
> uninitialized stack areas.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 9a3767818c50..2abf945e5844 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -574,7 +574,7 @@ xfs_dir2_leaf_addname(
>  	xfs_dir2_data_unused_t	*dup;		/* data unused entry */
>  	int			error;		/* error return value */
>  	int			grown;		/* allocated new data block */
> -	int			highstale;	/* index of next stale leaf */
> +	int			highstale = 0;	/* index of next stale leaf */
>  	int			i;		/* temporary, index */
>  	int			index;		/* leaf table position */
>  	struct xfs_buf		*lbp;		/* leaf's buffer */
> @@ -583,7 +583,7 @@ xfs_dir2_leaf_addname(
>  	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry table pointer */
>  	int			lfloglow;	/* low leaf logging index */
>  	int			lfloghigh;	/* high leaf logging index */
> -	int			lowstale;	/* index of prev stale leaf */
> +	int			lowstale = 0;	/* index of prev stale leaf */
>  	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail pointer */
>  	int			needbytes;	/* leaf block bytes needed */
>  	int			needlog;	/* need to log data header */
