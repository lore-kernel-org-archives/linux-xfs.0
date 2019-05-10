Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42730 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfEJVlE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 17:41:04 -0400
Subject: Re: [PATCH 05/11] libxfs: de-libxfsify core(-ish) functions.
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-6-git-send-email-sandeen@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b78a858b-8be1-ced1-0f16-f4a916a2e2ca@sandeen.net>
Date: Fri, 10 May 2019 16:41:03 -0500
MIME-Version: 1.0
In-Reply-To: <1557519510-10602-6-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

On 5/10/19 3:18 PM, Eric Sandeen wrote:
> There are a ton of "libxfs_" prefixed functions in libxfs/trans.c which
> are only called internally by code in libxfs/ - As I understand it,
> these should probably be just "xfs_" functions, and indeed many
> of them have counterparts in the kernel libxfs/ code.  This is one
> small step towards better sync-up of some of the misc libxfs/*
> transaction code with kernel code.

I should have changed internal callers too, will resend after other
review.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  libxfs/libxfs_api_defs.h |  1 +
>  libxfs/trans.c           | 48 ++++++++++++++++++++++++------------------------
>  2 files changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 1150ec9..64030af 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -17,6 +17,7 @@
>  #define xfs_highbit64			libxfs_highbit64
>  
>  #define xfs_trans_alloc			libxfs_trans_alloc
> +#define xfs_trans_alloc_rollable	libxfs_trans_alloc_rollable
>  #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
>  #define xfs_trans_add_item		libxfs_trans_add_item
>  #define xfs_trans_bhold			libxfs_trans_bhold
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 581ece3..85c3a50 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -36,7 +36,7 @@ kmem_zone_t	*xfs_trans_zone;
>   * in the mount structure.
>   */
>  void
> -libxfs_trans_init(
> +xfs_trans_init(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_trans_resv_calc(mp, &mp->m_resv);
> @@ -46,7 +46,7 @@ libxfs_trans_init(
>   * Add the given log item to the transaction's list of log items.
>   */
>  void
> -libxfs_trans_add_item(
> +xfs_trans_add_item(
>  	struct xfs_trans	*tp,
>  	struct xfs_log_item	*lip)
>  {
> @@ -62,7 +62,7 @@ libxfs_trans_add_item(
>   * Unlink and free the given descriptor.
>   */
>  void
> -libxfs_trans_del_item(
> +xfs_trans_del_item(
>  	struct xfs_log_item	*lip)
>  {
>  	clear_bit(XFS_LI_DIRTY, &lip->li_flags);
> @@ -77,7 +77,7 @@ libxfs_trans_del_item(
>   * chunk we've been working on and get a new transaction to continue.
>   */
>  int
> -libxfs_trans_roll(
> +xfs_trans_roll(
>  	struct xfs_trans	**tpp)
>  {
>  	struct xfs_trans	*trans = *tpp;
> @@ -245,7 +245,7 @@ undo_blocks:
>  }
>  
>  int
> -libxfs_trans_alloc(
> +xfs_trans_alloc(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_res	*resp,
>  	unsigned int		blocks,
> @@ -289,7 +289,7 @@ libxfs_trans_alloc(
>   * without any dirty data.
>   */
>  int
> -libxfs_trans_alloc_empty(
> +xfs_trans_alloc_empty(
>  	struct xfs_mount		*mp,
>  	struct xfs_trans		**tpp)
>  {
> @@ -304,7 +304,7 @@ libxfs_trans_alloc_empty(
>   * permanent log reservation flag to avoid blowing asserts.
>   */
>  int
> -libxfs_trans_alloc_rollable(
> +xfs_trans_alloc_rollable(
>  	struct xfs_mount	*mp,
>  	unsigned int		blocks,
>  	struct xfs_trans	**tpp)
> @@ -314,7 +314,7 @@ libxfs_trans_alloc_rollable(
>  }
>  
>  void
> -libxfs_trans_cancel(
> +xfs_trans_cancel(
>  	struct xfs_trans	*tp)
>  {
>  #ifdef XACT_DEBUG
> @@ -337,7 +337,7 @@ out:
>  }
>  
>  void
> -libxfs_trans_ijoin(
> +xfs_trans_ijoin(
>  	xfs_trans_t		*tp,
>  	xfs_inode_t		*ip,
>  	uint			lock_flags)
> @@ -360,7 +360,7 @@ libxfs_trans_ijoin(
>  }
>  
>  void
> -libxfs_trans_ijoin_ref(
> +xfs_trans_ijoin_ref(
>  	xfs_trans_t		*tp,
>  	xfs_inode_t		*ip,
>  	int			lock_flags)
> @@ -375,7 +375,7 @@ libxfs_trans_ijoin_ref(
>  }
>  
>  void
> -libxfs_trans_inode_alloc_buf(
> +xfs_trans_inode_alloc_buf(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -422,7 +422,7 @@ xfs_trans_log_inode(
>  }
>  
>  int
> -libxfs_trans_roll_inode(
> +xfs_trans_roll_inode(
>  	struct xfs_trans	**tpp,
>  	struct xfs_inode	*ip)
>  {
> @@ -440,7 +440,7 @@ libxfs_trans_roll_inode(
>   * Mark a buffer dirty in the transaction.
>   */
>  void
> -libxfs_trans_dirty_buf(
> +xfs_trans_dirty_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> @@ -466,7 +466,7 @@ libxfs_trans_dirty_buf(
>   * value of b_blkno.
>   */
>  void
> -libxfs_trans_log_buf(
> +xfs_trans_log_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp,
>  	uint			first,
> @@ -488,7 +488,7 @@ libxfs_trans_log_buf(
>   * If the buffer is already dirty, trigger the "already logged" return condition.
>   */
>  bool
> -libxfs_trans_ordered_buf(
> +xfs_trans_ordered_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> @@ -511,7 +511,7 @@ xfs_buf_item_put(
>  }
>  
>  void
> -libxfs_trans_brelse(
> +xfs_trans_brelse(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -546,7 +546,7 @@ libxfs_trans_brelse(
>  }
>  
>  void
> -libxfs_trans_binval(
> +xfs_trans_binval(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -571,7 +571,7 @@ libxfs_trans_binval(
>  }
>  
>  void
> -libxfs_trans_bjoin(
> +xfs_trans_bjoin(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -589,7 +589,7 @@ libxfs_trans_bjoin(
>  }
>  
>  void
> -libxfs_trans_bhold(
> +xfs_trans_bhold(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> @@ -605,7 +605,7 @@ libxfs_trans_bhold(
>  }
>  
>  xfs_buf_t *
> -libxfs_trans_get_buf_map(
> +xfs_trans_get_buf_map(
>  	xfs_trans_t		*tp,
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
> @@ -641,7 +641,7 @@ libxfs_trans_get_buf_map(
>  }
>  
>  xfs_buf_t *
> -libxfs_trans_getsb(
> +xfs_trans_getsb(
>  	xfs_trans_t		*tp,
>  	xfs_mount_t		*mp,
>  	int			flags)
> @@ -675,7 +675,7 @@ libxfs_trans_getsb(
>  }
>  
>  int
> -libxfs_trans_read_buf_map(
> +xfs_trans_read_buf_map(
>  	xfs_mount_t		*mp,
>  	xfs_trans_t		*tp,
>  	struct xfs_buftarg	*btp,
> @@ -743,7 +743,7 @@ out_relse:
>   * Originally derived from xfs_trans_mod_sb().
>   */
>  void
> -libxfs_trans_mod_sb(
> +xfs_trans_mod_sb(
>  	xfs_trans_t		*tp,
>  	uint			field,
>  	long			delta)
> @@ -1004,7 +1004,7 @@ out_unreserve:
>  }
>  
>  int
> -libxfs_trans_commit(
> +xfs_trans_commit(
>  	struct xfs_trans	*tp)
>  {
>  	return __xfs_trans_commit(tp, false);
> 
