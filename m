Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:46041 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753153AbdCFTSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 14:18:36 -0500
Date: Mon, 6 Mar 2017 11:14:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] fs, xfs: convert xfs_cui_log_item.cui_refcount from
 atomic_t to refcount_t
Message-ID: <20170306191446.GE5280@birch.djwong.org>
References: <1488358060-693-1-git-send-email-elena.reshetova@intel.com>
 <1488358060-693-5-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488358060-693-5-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, david@fromorbit.com, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

On Wed, Mar 01, 2017 at 10:47:39AM +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  fs/xfs/xfs_refcount_item.c | 4 ++--
>  fs/xfs/xfs_refcount_item.h | 4 +++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 6e4c744..61bc570 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -205,7 +205,7 @@ xfs_cui_init(
>  	cuip->cui_format.cui_nextents = nextents;
>  	cuip->cui_format.cui_id = (uintptr_t)(void *)cuip;
>  	atomic_set(&cuip->cui_next_extent, 0);
> -	atomic_set(&cuip->cui_refcount, 2);
> +	refcount_set(&cuip->cui_refcount, 2);

I'm assuming the refcount design is ok with the log item refcounts
starting at 2 and marching down to zero?  The code seems to be
fine with it; I just want to make sure everyone's ok with supporting
this use case.

>  	return cuip;
>  }
> @@ -221,7 +221,7 @@ void
>  xfs_cui_release(
>  	struct xfs_cui_log_item	*cuip)
>  {
> -	if (atomic_dec_and_test(&cuip->cui_refcount)) {
> +	if (refcount_dec_and_test(&cuip->cui_refcount)) {

I suppose it's useful to have refcount_dec_and_test complain loudly if
we ever have a dangling pointer... Friday I was chasing a possible
use-after-free of the EFI items in generic/388.

>  		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
>  		xfs_cui_item_free(cuip);
>  	}
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index 5b74ddd..7f23ff8 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -20,6 +20,8 @@
>  #ifndef	__XFS_REFCOUNT_ITEM_H__
>  #define	__XFS_REFCOUNT_ITEM_H__
>  
> +#include <linux/refcount.h>

I still think this include should go in xfs_linux.h, the same as most of
the other linux/*.h includes in XFS.

--D

> +
>  /*
>   * There are (currently) two pairs of refcount btree redo item types:
>   * increase and decrease.  The log items for these are CUI (refcount
> @@ -63,7 +65,7 @@ struct kmem_zone;
>   */
>  struct xfs_cui_log_item {
>  	struct xfs_log_item		cui_item;
> -	atomic_t			cui_refcount;
> +	refcount_t			cui_refcount;
>  	atomic_t			cui_next_extent;
>  	unsigned long			cui_flags;	/* misc flags */
>  	struct xfs_cui_log_format	cui_format;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
