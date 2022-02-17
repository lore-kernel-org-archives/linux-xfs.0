Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2EEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 23:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiBQXTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 18:19:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBQXTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 18:19:12 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8235742EE1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 15:18:49 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A67A810C6F55;
        Fri, 18 Feb 2022 10:16:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nKq13-00DHLJ-KN; Fri, 18 Feb 2022 10:16:49 +1100
Date:   Fri, 18 Feb 2022 10:16:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] xfs: tag reclaimable inodes with pending RCU
 grace periods as busy
Message-ID: <20220217231649.GC59715@dread.disaster.area>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217172518.3842951-3-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=620ed762
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2kLGC8x6MqDa9DCV_PQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 17, 2022 at 12:25:16PM -0500, Brian Foster wrote:
> In order to avoid aggressive recycling of in-core xfs_inode objects with
> pending grace periods and the subsequent RCU sync stalls involved with
> recycling, we must be able to identify them quickly and reliably at
> allocation time. Claim a new tag for the in-core inode radix tree and
> tag all inodes with a still pending grace period cookie as busy at the
> time they are made reclaimable.
> 
> Note that it is not necessary to maintain consistency between the tag
> and grace period status once the tag is set. The busy tag simply
> reflects that the grace period had not expired by the time the inode was
> set reclaimable and therefore any reuse of the inode must first poll the
> RCU subsystem for subsequent expiration of the grace period. Clear the
> tag when the inode is recycled or reclaimed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 693896bc690f..245ee0f6670b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -32,6 +32,8 @@
>  #define XFS_ICI_RECLAIM_TAG	0
>  /* Inode has speculative preallocations (posteof or cow) to clean. */
>  #define XFS_ICI_BLOCKGC_TAG	1
> +/* inode has pending RCU grace period when set reclaimable  */
> +#define XFS_ICI_BUSY_TAG	2
>  
>  /*
>   * The goal for walking incore inodes.  These can correspond with incore inode
> @@ -274,7 +276,7 @@ xfs_perag_clear_inode_tag(
>  	if (agino != NULLAGINO)
>  		radix_tree_tag_clear(&pag->pag_ici_root, agino, tag);
>  	else
> -		ASSERT(tag == XFS_ICI_RECLAIM_TAG);
> +		ASSERT(tag == XFS_ICI_RECLAIM_TAG || tag == XFS_ICI_BUSY_TAG);
>  
>  	if (tag == XFS_ICI_RECLAIM_TAG)
>  		pag->pag_ici_reclaimable--;
> @@ -336,6 +338,7 @@ xfs_iget_recycle(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	int			error;
>  
>  	trace_xfs_iget_recycle(ip);
> @@ -392,8 +395,9 @@ xfs_iget_recycle(
>  	 */
>  	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
>  	ip->i_flags |= XFS_INEW;
> -	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			XFS_ICI_RECLAIM_TAG);
> +
> +	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_BUSY_TAG);
> +	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);

This doesn't need any of the global mp->m_perag_tree tracking or
anything else to be tracked or queued - it's just a single state bit
that is associated with the inode and nothing more. The inode
allocation side of things is already per-ag, so it can check the
perag icache tree directly and hence there's no need for global
perag tree tracking.

Hence this could just be:

+	radix_tree_tag_clear(&pag->pag_ici_root, agino, XFS_ICI_BUSY_TAG);


>  	inode->i_state = I_NEW;
>  	spin_unlock(&ip->i_flags_lock);
>  	spin_unlock(&pag->pag_ici_lock);
> @@ -931,6 +935,7 @@ xfs_reclaim_inode(
>  	if (!radix_tree_delete(&pag->pag_ici_root,
>  				XFS_INO_TO_AGINO(ip->i_mount, ino)))
>  		ASSERT(0);
> +	xfs_perag_clear_inode_tag(pag, NULLAGINO, XFS_ICI_BUSY_TAG);
>  	xfs_perag_clear_inode_tag(pag, NULLAGINO, XFS_ICI_RECLAIM_TAG);
>  	spin_unlock(&pag->pag_ici_lock);

This becomes unnecessary, because radix_tree_delete() clears the
tags for the slot where the entry being deleted is found.

>  
> @@ -1807,6 +1812,7 @@ xfs_inodegc_set_reclaimable(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_perag	*pag;
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  
>  	if (!xfs_is_shutdown(mp) && ip->i_delayed_blks) {
>  		xfs_check_delalloc(ip, XFS_DATA_FORK);
> @@ -1821,10 +1827,12 @@ xfs_inodegc_set_reclaimable(
>  	trace_xfs_inode_set_reclaimable(ip);
>  	if (destroy_gp)
>  		ip->i_destroy_gp = destroy_gp;
> +	if (!poll_state_synchronize_rcu(ip->i_destroy_gp))
> +		xfs_perag_set_inode_tag(pag, agino, XFS_ICI_BUSY_TAG);

And this becomes:

+	if (!poll_state_synchronize_rcu(ip->i_destroy_gp))
+		radix_tree_tag_set(&pag->pag_ici_root, agino, XFS_ICI_BUSY_TAG);

---

FWIW, I have most of the inode cache life-cycle rework prototyped.
All the unlink stuff is done - unlinked inodes are freed directly
in ->destroy_inode now which gets callled on demand when the inodes
are marked clean or XFS_ISTALE cluster buffers are committed. Hence
they don't even go through an IRECLAIMABLE state anymore. I'm
currently working on the same thing for inodes that needed EOF block
trimming, and once that is done the whole XFS_IRECLAIMABLE state and
the background inode reclaim goes away. This also takes with it the 
XFS_ICI_RECLAIM_TAG, the inode cache shrinker and a few other bits
and pieces...

The prototype needs busy inode tracking now, so I was looking at
doing a simple busy inode tracking thing yesterday hence my comments
above. I'm currently just using the XFS_INACTIVE flags to delay
xfs_iget lookups from allocation until the inode has been reclaimed
(really, really slow!) and generic/001 hits this pretty hard.

I'll have a deeper look at patch 4 on Monday and chop it down to
the bare minimum tag lookups and, hopefully, I'll be able to get
rid of the need for patch 3 in this series at the same time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
