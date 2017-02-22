Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21850 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932133AbdBVLRY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 06:17:24 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 1/7] fs, xfs: convert xfs_bui_log_item.bui_refcount from
 atomic_t to refcount_t
Date: Wed, 22 Feb 2017 11:17:20 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C4EB27@IRSMSX102.ger.corp.intel.com>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-2-git-send-email-elena.reshetova@intel.com>
 <20170221163625.GB5846@birch.djwong.org>
In-Reply-To: <20170221163625.GB5846@birch.djwong.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

> On Tue, Feb 21, 2017 at 05:49:01PM +0200, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> >
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > ---
> >  fs/xfs/xfs_bmap_item.c | 4 ++--
> >  fs/xfs/xfs_bmap_item.h | 4 +++-
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 9bf57c7..33104ad 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -199,7 +199,7 @@ xfs_bui_init(
> >  	buip->bui_format.bui_nextents =
> XFS_BUI_MAX_FAST_EXTENTS;
> >  	buip->bui_format.bui_id = (uintptr_t)(void *)buip;
> >  	atomic_set(&buip->bui_next_extent, 0);
> > -	atomic_set(&buip->bui_refcount, 2);
> > +	refcount_set(&buip->bui_refcount, 2);
> >
> >  	return buip;
> >  }
> > @@ -215,7 +215,7 @@ void
> >  xfs_bui_release(
> >  	struct xfs_bui_log_item	*buip)
> >  {
> > -	if (atomic_dec_and_test(&buip->bui_refcount)) {
> > +	if (refcount_dec_and_test(&buip->bui_refcount)) {
> >  		xfs_trans_ail_remove(&buip->bui_item,
> SHUTDOWN_LOG_IO_ERROR);
> >  		xfs_bui_item_free(buip);
> >  	}
> > diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> > index c867daa..988a6ae 100644
> > --- a/fs/xfs/xfs_bmap_item.h
> > +++ b/fs/xfs/xfs_bmap_item.h
> > @@ -20,6 +20,8 @@
> >  #ifndef	__XFS_BMAP_ITEM_H__
> >  #define	__XFS_BMAP_ITEM_H__
> >
> > +#include <linux/refcount.h>
> 
> Seeing as you're sprinkling refcount_t all over XFS, this ought to go in
> xfs_linux.h with all the other Linux-specific #includes.
> 
> --D

Sure, I will move the include there and leave only one. 
Will send a next version also after fixing the other non-reference counters case we discussed. 

Best Regards,
Elena.
> 
> > +
> >  /*
> >   * There are (currently) two pairs of bmap btree redo item types: map &
> unmap.
> >   * The common abbreviations for these are BUI (bmap update intent) and
> BUD
> > @@ -61,7 +63,7 @@ struct kmem_zone;
> >   */
> >  struct xfs_bui_log_item {
> >  	struct xfs_log_item		bui_item;
> > -	atomic_t			bui_refcount;
> > +	refcount_t			bui_refcount;
> >  	atomic_t			bui_next_extent;
> >  	unsigned long			bui_flags;	/* misc
> flags */
> >  	struct xfs_bui_log_format	bui_format;
> > --
> > 2.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
