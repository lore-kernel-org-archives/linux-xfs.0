Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64C1C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 05:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D77523ECF
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 05:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389328AbgLKFua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 00:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388912AbgLKFuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 00:50:04 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753F2C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 21:49:24 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id g20so3220586plo.2
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 21:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d2AY8S0arTyDm4OVAMUwH9qSMVm5ZMRl/sfEzV6vp2M=;
        b=pYQQjZMyFbnVufbO9dX0Wjy+V1LOywbaGcQycGdeJSDRTaF+2KRSZaLjOqR4qNCRRH
         14zE4NHoqR11kLuyioU8fhq5L++C+0CF+r0uBagTGzjdbqlIw0f1Q+fYD1Rq/cwL9eY9
         /EsbBUO8IbXZDLEh8ww68Z7q6aX+73VijWaea8JhC/9eKI5qbtoPt3AdeAfRdOJAISgR
         8CukcZUjrwJWnaCRms/bN5902bVMXHDUue4Uhp2Y1vm2n+5QMlA+5cWVVn1XtPsAj0MZ
         rMaurSM2Db8MdHqQF4v2WaqKP49/tDGfGT5z4d//fTL/+Mc+q9SYsqy3JP/oIjzOrpLG
         RBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d2AY8S0arTyDm4OVAMUwH9qSMVm5ZMRl/sfEzV6vp2M=;
        b=BAOdNP4NTxFugJlGbPei/asA9uwgXFsHicTpFKiMFOJAKmQrwd+IiopEd0Y71Uh536
         OHPXk41ZKlmCOQM9F8omBch24+FYDpsxHm6vdrQ8SZQeuhm9Hl25ZpiRKlDot0dVaL7g
         zbqsc0ovJqIZRbyocQdTrQpSKnuyDmvc254NoRe6f2PqOhbMBEoRJ47x+Pyv5gzkb7RB
         /C9OCOly9Bq6BU515gyetS+rEGnlqZkbqBV3zdZ40bxji7DXNW7XHI8VNmLk6cP6TnZf
         /2LNn99xu3Ccpsa7iUChCIkvW5J7rt5oxcvEK8JRp35LeK7Ex71bTWzZZ+OYoG5GhfkS
         7Qyg==
X-Gm-Message-State: AOAM532BkGWMv6cuTGqQeUgMzt/hRLvKQsoxBPVnkQ8KQT+lnRRW+2+V
        CogxubyXhXI0fEIAeGal8Io=
X-Google-Smtp-Source: ABdhPJylpIiYKkdKsPFw68CLoutqB9hd4esMBMXR7GR87iLZhyZNkZ3hcRN/VPD03orQXiyZTeDJfg==
X-Received: by 2002:a17:90b:a4a:: with SMTP id gw10mr11318448pjb.29.1607665763673;
        Thu, 10 Dec 2020 21:49:23 -0800 (PST)
Received: from garuda.localnet ([122.167.39.189])
        by smtp.gmail.com with ESMTPSA id i37sm5242466pgi.46.2020.12.10.21.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 21:49:22 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 05/14] xfs: Check for extent overflow when adding/removing dir entries
Date:   Fri, 11 Dec 2020 11:19:19 +0530
Message-ID: <4456170.lelFaBd9DB@garuda>
In-Reply-To: <20201209192404.GM1943235@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com> <3689375.PeLr2PdtSZ@garuda> <20201209192404.GM1943235@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 09 Dec 2020 11:24:04 -0800, Darrick J. Wong wrote:
> On Mon, Dec 07, 2020 at 01:48:50PM +0530, Chandan Babu R wrote:
> > On Fri, 04 Dec 2020 14:34:32 +0530, Chandan Babu R wrote:
> > > On Thu, 03 Dec 2020 11:04:22 -0800, Darrick J. Wong wrote:
> > > > On Tue, Nov 17, 2020 at 07:14:07PM +0530, Chandan Babu R wrote:
> > > > > Directory entry addition/removal can cause the following,
> > > > > 1. Data block can be added/removed.
> > > > >    A new extent can cause extent count to increase by 1.
> > > > > 2. Free disk block can be added/removed.
> > > > >    Same behaviour as described above for Data block.
> > > > > 3. Dabtree blocks.
> > > > >    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
> > > > >    can be new extents. Hence extent count can increase by
> > > > >    XFS_DA_NODE_MAXDEPTH.
> > > > > 
> > > > > To be able to always remove an existing directory entry, when adding a
> > > > > new directory entry we make sure to reserve inode fork extent count
> > > > > required for removing a directory entry in addition to that required for
> > > > > the directory entry add operation.
> > > > > 
> > > > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
> > > > >  fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
> > > > >  fs/xfs/xfs_symlink.c           |  5 +++++
> > > > >  3 files changed, 45 insertions(+)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > > index 5de2f07d0dd5..fd93fdc67ee4 100644
> > > > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > > > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > > > > @@ -57,6 +57,19 @@ struct xfs_ifork {
> > > > >  #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> > > > >  	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> > > > >  
> > > > > +/*
> > > > > + * Directory entry addition/removal can cause the following,
> > > > > + * 1. Data block can be added/removed.
> > > > > + *    A new extent can cause extent count to increase by 1.
> > > > > + * 2. Free disk block can be added/removed.
> > > > > + *    Same behaviour as described above for Data block.
> > > > > + * 3. Dabtree blocks.
> > > > > + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> > > > > + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> > > > > + */
> > > > > +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> > > > > +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> > > > > +
> > > > >  /*
> > > > >   * Fork handling.
> > > > >   */
> > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > index 2bfbcf28b1bd..f7b0b7fce940 100644
> > > > > --- a/fs/xfs/xfs_inode.c
> > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > @@ -1177,6 +1177,11 @@ xfs_create(
> > > > >  	if (error)
> > > > >  		goto out_trans_cancel;
> > > > >  
> > > > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > > > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > > 
> > > > Er, why did these double since V10?  We're only adding one entry, right?
> > > 
> > > To be able to always guarantee the removal of an existing directory entry, we
> > > reserve inode fork extent count required for removing a directory entry in
> > > addition to that required for the directory entry add operation.
> > > 
> > > A bug was discovered when executing the following sequence of
> > > operations,
> > > 1. Keep inserting directory entries until the pseudo max extent count limit is
> > >    reached.
> > > 2. At this stage, a directory entry remove operation will fail because it
> > >    tries to reserve XFS_IEXT_DIR_MANIP_CNT(mp) worth of extent count. This
> > >    reservation fails since the extent count would go over the pseudo max
> > >    extent count limit as it did in step 1.
> > > 
> > > We would end up with a directory which can never be deleted.
> > 
> > I just found that reserving an extra XFS_IEXT_DIR_MANIP_CNT(mp) extent count,
> > when performing a directory insert operation, would not prevent us from ending
> > up with a directory which can never be deleted.
> > 
> > Let x be a directory's data fork extent count and lets assume its value to be,
> > 
> > x = MAX_EXT_COUNT - XFS_IEXT_DIR_MANIP_CNT(mp)
> > 
> > So in this case we do have sufficient "extent count" to be able to perform a
> > directory entry remove operation. But the directory remove operation itself
> > can cause extent count to increase by XFS_IEXT_DIR_MANIP_CNT(mp) units in the
> > worst case. This happens when freeing 5 dabtree blocks, one data block and one
> > free block causes file extents to be split for each of the above mentioned
> > blocks.
> > 
> > If on the other hand, the current value of 'x' were,
> > 
> > x = MAX_EXT_COUNT - (2 * XFS_IEXT_DIR_MANIP_CNT(mp))
> > 
> > 'x' can still reach MAX_EXT_COUNT if two consecutive directory remove
> > operations can each cause extent count to increase by
> > XFS_IEXT_DIR_MANIP_CNT(mp).
> > 
> > IMHO there is no way to prevent a directory from becoming un-deletable
> > once its data fork extent count reaches close to MAX_EXT_COUNT. The other
> > choice of not checking for extent overflow would mean silent data
> > corruption. Hence maybe the former result is better one to go with.
> 
> So in other words you're doubling the amount you pass into the overflow
> check so that we can guarantee that a future dirent removal will work.
> 
> In other words, the doubling is to preserve future functionality, and is
> not required by the create() call itself.  This should be captured in
> a comment above the call to xfs_iext_count_may_overflow.
> 
> Or I guess you could create an XFS_IEXT_DIRENT_CREATE macro that wraps
> all that (along with that comment explaining why).

Sorry, the previous explaination I had provided earlier was not clear
enough. I hope the following will add more clarity.

The bottom line is that extent count reservation cannot guarantee that a
future "directory entry remove" operation will always have sufficient amount
of "extent count" left in the inode's data fork extent count.

Doubling the extent count that gets reserved during directory entry insert
operation can leave a minimum of XFS_IEXT_DIR_MANIP_CNT extent count units
free after the operation is completed. But this extent count can be consumed
away by a directory entry remove operation that ends up freeing directory
blocks due to the fact that it can cause extent count of directory inode to
increase by XFS_IEXT_DIR_MANIP_CNT units.

For example, Assume that a directory's data fork extent count is X and it has
the following extent record in its bmbt,

 | Y | Y+1 | Y+2 |

Here Y is the offset within the directory. The directory blocks are within the
same extent record since they are contiguous in terms of both file offset and
disk offset. Now, if a directory entry remove operation is executed, it can
free the block Y+1. This causes an increase in the extent count.

So a single directory entry remove operation has the potential to increase
extent count by XFS_IEXT_DIR_MANIP_CNT units in the worst case (one data
block, one free disk block and 5 dabtree blocks). Hence reserving an extra
XFS_IEXT_DIR_MANIP_CNT units of extent count during directory entry insertion
would not help solve the problem.

The above mentioned scenario can be further extended:
If a directory has (2 * XFS_IEXT_DIR_MANIP_CNT) units of free extent count
left, two directory entry remove operations can potentially increase extent
count by XFS_IEXT_DIR_MANIP_CNT units each and hence the execution of a third
consecutive directory entry remove operation fails due to lack of availability
of free extent count.

A related problem has already been solved in XFS.

File deletion can fail in the case of low disk space scenarios. This happens
because of failure to successfully reserve disk blocks for "directory entry
remove" transaction. In such a case, xfs_remove() allocates a transaction with
tp->t_blk_res set to 0. During the execution of the operation, if we end up
having to remove a block (say a "directory data block") from the directory,
the following events could occur,

1. xfs_bmap_del_extent_real(): Extent count increases because the block that
   is being unmapped from bmbt occurs in the middle of an extent record.
2. We truncate the length of the existing extent record and try to insert a
   new extent record which maps the blocks of the original extent record that
   occurs after the block being freed.
3. The following sequence of functions are invoked if inserting a new record
   requires a btree block to be split,
   xfs_btree_insert() => xfs_btree_insrec() => xfs_btree_make_block_unfull()
   => __xfs_btree_split() => xfs_bmbt_alloc_block()
4. xfs_bmbt_alloc_block() returns -ENOSPC when it notices tp->t_blk_res having
   a value of 0.
5. Upon receiving -ENOSPC return value, xfs_bmap_del_extent_real() restores
   the original extent record.
6. Invokers of xfs_dir2_shrink_inode() (e.g. xfs_dir3_data_block_free()) would
   ignore the -ENOSPC error code and hence the corresponding directory block
   is not freed. It is left to a future user of the block to be able to free
   it.

I think we have to use a similar approach to solve the "undeletable directory"
problem. To that end, I have written a patch which implements the following
logic,

W.r.t directory entry remove operation, we check for extent count overflow in
xfs_bmap_del_extent_real() only when the block being unmapped could cause an
increase the extent count overflow. If unmapping can cause extent count to
overflow, xfs_bmap_del_extent_real() would return -ENOSPC, causing the
invokers of xfs_dir2_shrink_inode() to ignore -ENOSPC and leaving the
responsibility of freeing the directory block for future.

For "directory rename operation", the explanation provided for "directory
entry remove" operation holds for the "source directory entry". For rename's
destination directory entry, we now check for extent overflow only when we
have successfully reserved non-zero blocks for the transaction. This is
because with zero block-sized reservation, the rename either
1. Fails due to non-availability of space in existing directory blocks for
   holding the new directory entry.
2. Succeeds since the directory has enough space in existing blocks to hold
   the new directory entry. In this case, XFS wouldn't add new blocks to the
   directory.

For the remaining directory operations (e.g. create, link and symlink) we
continue to reserve XFS_IEXT_ATTR_MANIP_CNT units of extent count before the
corresponding transaction starts dirtying metadata.

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 505358839d2f..b388b7d55cb9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5050,6 +5050,12 @@ xfs_bmap_del_extent_real(
 	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
 		return -ENOSPC;
 
+	if (S_ISDIR(VFS_I(ip)->i_mode) &&
+	    whichfork == XFS_DATA_FORK &&
+	    del->br_startoff > got.br_startoff && del_endoff < got_endoff &&
+	    xfs_iext_count_may_overflow(ip, whichfork, 1))
+		return -ENOSPC;
+
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 		xfs_filblks_t	len;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 5de2f07d0dd5..fd93fdc67ee4 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -57,6 +57,19 @@ struct xfs_ifork {
 #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
+/*
+ * Directory entry addition/removal can cause the following,
+ * 1. Data block can be added/removed.
+ *    A new extent can cause extent count to increase by 1.
+ * 2. Free disk block can be added/removed.
+ *    Same behaviour as described above for Data block.
+ * 3. Dabtree blocks.
+ *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
+ *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
+ */
+#define XFS_IEXT_DIR_MANIP_CNT(mp) \
+	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..c4f3a42d5733 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1177,6 +1177,11 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * A newly created regular or special file just has one directory
 	 * entry pointing to them, but a directory also the "." entry
@@ -1393,6 +1398,11 @@ xfs_link(
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto error_return;
+
 	/*
 	 * If we are using project inheritance, we only allow hard link
 	 * creation in our tree when the project IDs are the same; else
@@ -3246,12 +3256,27 @@ xfs_rename(
 		/*
 		 * If there's no space reservation, check the entry will
 		 * fit before actually inserting it.
+		 *
+		 * If the entry does fit in, then there is no need to check for
+		 * extent count overflow since no new extents will be added to
+		 * the directory's data fork.
 		 */
 		if (!spaceres) {
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
 				goto out_trans_cancel;
 		}
+		/*
+		 * Otherwise, Check if inserting the new entry can cause extent
+		 * count to overflow.
+		 */
+		else {
+			error = xfs_iext_count_may_overflow(target_dp,
+					XFS_DATA_FORK,
+					XFS_IEXT_DIR_MANIP_CNT(mp));
+			if (error)
+				goto out_trans_cancel;
+		}
 	} else {
 		/*
 		 * If target exists and it's a directory, check that whether
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..581a4032a817 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -220,6 +220,11 @@ xfs_symlink(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Allocate an inode for the symlink.
 	 */

The ideal way to test this patch would be to have a directory whose extent
count has reached the maximum limit and also has an extent record with atleast
three blocks. Freeing directory entries occupying the middle block in such an
extent record would trigger the -ENOSPC error code handling described above.

However, I don't think it is possible to deterministically create such a
directory layout by executing commands from userspace. Hence my testing was
limited to, 
1. Fill a directory with entries until the maximum extent count limit is
   reached. Remove the corresponding directory. The remove operation should
   succeed.
2. Regular run of fstests with various mount options.

> 
> > W.r.t xattrs, not reserving an extra XFS_IEXT_ATTR_MANIP_CNT(mp) extent count
> > units would prevent the user from removing xattrs when the inode's attr fork
> > extent count value is close to MAX_EXT_COUNT. However, the file and the
> > associated extents will be removed during file deletion operation.
> 
> <shrug> I doubt xattr trees often get close to 64k extents, so you might
> as well apply the same logic to them.  Better to cut off the user early
> than to force them to delete the whole file just to wipe out the xattrs.

As described above reserving twice the amount of extent count units during
xattr insertion would not guarantee a future xattr remove operation to obtain
extent count reservation successfully. Hence to always allow xattr remove
operation, we have to implement some of the logic associated with "directory
remove operation". This includes adding the ability to swap dabtree
block (whose removal can cause -ENOSPC to be returned from xfs_bunmapi()) with
the last block of the xattr dabtree (i.e. the logic implemented by
xfs_da3_swap_lastblock()). Please let me know if you prefer this approach to
be implemented instead of file deletion.

> 
> > > 
> > > Hence V11 doubles the extent count reservation for "directory entry insert"
> > > operations. The first XFS_IEXT_DIR_MANIP_CNT(mp) instance is for "insert"
> > > operation while the second XFS_IEXT_DIR_MANIP_CNT(mp) instance is for
> > > guaranteeing a possible future "remove" operation to succeed.
> > > 
> > > > 
> > > > > +	if (error)
> > > > > +		goto out_trans_cancel;
> > > > > +
> > > > >  	/*
> > > > >  	 * A newly created regular or special file just has one directory
> > > > >  	 * entry pointing to them, but a directory also the "." entry
> > > > > @@ -1393,6 +1398,11 @@ xfs_link(
> > > > >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> > > > >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> > > > >  
> > > > > +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> > > > > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > > 
> > > > Same question here.
> > > 
> > > Creating a new hard link involves adding a new directory entry. Hence apart
> > > from reserving extent count for directory entry addition we will have to
> > > reserve extent count for a future directory entry removal as well.
> 
> In other words, we also want XFS_IEXT_DIRENT_CREATE here?
> 
> > > 
> > > > 
> > > > > +	if (error)
> > > > > +		goto error_return;
> > > > > +
> > > > >  	/*
> > > > >  	 * If we are using project inheritance, we only allow hard link
> > > > >  	 * creation in our tree when the project IDs are the same; else
> > > > > @@ -2861,6 +2871,11 @@ xfs_remove(
> > > > >  	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> > > > >  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > > > >  
> > > > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > > > +	if (error)
> > > > > +		goto out_trans_cancel;
> > > > > +
> > > > >  	/*
> > > > >  	 * If we're removing a directory perform some additional validation.
> > > > >  	 */
> > > > > @@ -3221,6 +3236,18 @@ xfs_rename(
> > > > >  	if (wip)
> > > > >  		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> > > > >  
> > > > > +	error = xfs_iext_count_may_overflow(src_dp, XFS_DATA_FORK,
> > > > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > > > > +	if (error)
> > > > > +		goto out_trans_cancel;
> > > > > +
> > > > > +	if (target_ip == NULL) {
> > > > > +		error = xfs_iext_count_may_overflow(target_dp, XFS_DATA_FORK,
> > > > > +				XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > > 
> > > > Why did this change to "<< 1" since V10?
> > > 
> > > Extent count is doubled since this is essentially a directory insert operation
> > > w.r.t target_dp directory. One instance of XFS_IEXT_DIR_MANIP_CNT(mp) is for
> > > the directory entry being added to target_dp directory and another instance of
> > > XFS_IEXT_DIR_MANIP_CNT(mp) is for guaranteeing a future directory entry
> > > removal from target_dp directory to succeed.
> 
> ...and here too?
> 
> > > 
> > > > 
> > > > I'm sorry, but I've lost my recollection on how the accounting works
> > > > here.  This seems (to me anyway ;)) a good candidate for a comment:
> > > > 
> > > > For a rename between dirs where the target name doesn't exist, we're
> > > > removing src_name from src_dp and adding target_name to target_dp.
> > > > Therefore we have to check for DIR_MANIP_CNT overflow on each of src_dp
> > > > and target_dp, right?
> > > 
> > > Extent count check is doubled since this is a directory insert operation w.r.t
> > > target_dp directory ... One instance of XFS_IEXT_DIR_MANIP_CNT(mp) is for the
> > > directory entry being added to target_dp directory and another instance of
> > > XFS_IEXT_DIR_MANIP_CNT(mp) is for guaranteeing a future directory entry
> > > removal from target_dp directory to succeed.
> 
> Or in other words, another place for XFS_IEXT_DIRENT_CREATE...
> 
> > > Since a directory entry is being removed from src_dp, reserving only a single
> > > instance of XFS_IEXT_DIR_MANIP_CNT(mp) would suffice.
> 
> <nod>
> 
> > > > 
> > > > For a rename within the same dir where target_name doesn't yet exist, we
> > > > are removing a name and then adding a name.  We therefore check for iext
> > > > overflow with (DIR_MANIP_CNT * 2), right?  And I think that "target name
> > > > does not exist" is synonymous with target_ip == NULL?
> > > 
> > > Here again we have to reserve two instances of XFS_IEXT_DIR_MANIP_CNT(mp) for
> > > target_name insertion and one instance of XFS_IEXT_DIR_MANIP_CNT(mp) for
> > > src_name removal. This is because insertion and removal of src_name may each
> > > end up consuming XFS_IEXT_DIR_MANIP_CNT(mp) extent counts in the worst case. A
> > > future directory entry remove operation will require
> > > XFS_IEXT_DIR_MANIP_CNT(mp) extent counts to be reserved.
> 
> ...and another place for DIRENT_CREATE...
> 
> > > 
> > > Also, You are right about "target name does not exist" being synonymous with
> > > target_ip == NULL.
> > > 
> > > > 
> > > > For a rename where target_name /does/ exist, we're only removing the
> > > > src_name, so we have to check for DIR_MANIP_CNT on src_dp, right?
> > > 
> > > Yes, you are right.
> > > 
> > > > 
> > > > For a RENAME_EXCHANGE we're not removing either name, so we don't need
> > > > to check for iext overflow of src_dp or target_dp, right?
> > > 
> > > You are right. Sorry, I missed this. I will move the extent count reservation
> > > logic to come after the invocation of xfs_cross_rename().
> 
> Ok.
> 
> > > I will also add appropriate comments into xfs_rename() describing the
> > > scenarios that have been discussed above.
> 
> Thanks.
> 
> > > PS: I have swapped the order of two comments from your original reply since I
> > > think it is easier to explain the scenarios with the order of
> > > comments/questions swapped.
> 
> Ok.
> 
> > > 
> > > > 
> > > > > +		if (error)
> > > > > +			goto out_trans_cancel;
> > > > > +	}
> > > > > +
> > > > >  	/*
> > > > >  	 * If we are using project inheritance, we only allow renames
> > > > >  	 * into our tree when the project IDs are the same; else the
> > > > > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > > > > index 8e88a7ca387e..08aa808fe290 100644
> > > > > --- a/fs/xfs/xfs_symlink.c
> > > > > +++ b/fs/xfs/xfs_symlink.c
> > > > > @@ -220,6 +220,11 @@ xfs_symlink(
> > > > >  	if (error)
> > > > >  		goto out_trans_cancel;
> > > > >  
> > > > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > > > > +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);
> > > > 
> > > > Same question as xfs_create.
> > > 
> > > This is again similar to adding a new directory entry. Hence, apart from
> > > reserving extent count for directory entry addition we will have to reserve
> > > extent count for a future directory entry removal as well.
> 
> ...and here yet another place to use XFS_IEXT_DIRENT_CREATE?
> 
> --D
> 
> > > 
> > > > 
> > > > --D
> > > > 
> > > > > +	if (error)
> > > > > +		goto out_trans_cancel;
> > > > > +
> > > > >  	/*
> > > > >  	 * Allocate an inode for the symlink.
> > > > >  	 */
> > > > 
> > > 
> > > 
> > 
> > 
> 


-- 
chandan



