Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D782C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Feb 2022 17:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiBNRHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Feb 2022 12:07:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348210AbiBNRHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Feb 2022 12:07:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E79A65171
        for <linux-xfs@vger.kernel.org>; Mon, 14 Feb 2022 09:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2981B811F0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Feb 2022 17:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DADC340E9;
        Mon, 14 Feb 2022 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644858449;
        bh=dmi3Vz7LRSdf/uhfzAf+AH6Rs7ds7OhLpG3GUIyPdPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o+2FlziFp6zQvxjRImPxWYyRH1NpY4sg67l/7fTRfywQyg7pnnwXYMPNgkSBJm+FD
         daCjtaqQhV3M6WJeWMH4IDj+0yMTuerUQYukI+DbCSz3ErPVrhC9KrS+EL4Gff/Ehp
         m8G85AGgqtd+RbTQZgP2hXSbS8S1j+DvpcpL/Ub1TfEm7vwt6b2iTY0O56h0ftDZiU
         +lMiLZ9wGrgW9Gpu+G8LeUhlSz3PFX+E0q72c/YWCzKWP1SeIXYBtjiF14Ldn0sGUO
         qWkERo8VLdmnSleiOKbpo8A3Zni+kWWjAmKLkXstJkISvj04cv2xRlER/x0SIoBbX+
         +wydTBzerYUxA==
Date:   Mon, 14 Feb 2022 09:07:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220214170728.GI8313@magnolia>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
 <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 11, 2022 at 05:40:30PM +0530, Chandan Babu R wrote:
> On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
> > On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
> >> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
> >> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
> >> >> This commit upgrades inodes to use 64-bit extent counters when they are read
> >> >> from disk. Inodes are upgraded only when the filesystem instance has
> >> >> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
> >> >> 
> >> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> >> ---
> >> >>  fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
> >> >>  1 file changed, 6 insertions(+)
> >> >> 
> >> >> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> >> >> index 2200526bcee0..767189c7c887 100644
> >> >> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> >> >> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> >> >> @@ -253,6 +253,12 @@ xfs_inode_from_disk(
> >> >>  	}
> >> >>  	if (xfs_is_reflink_inode(ip))
> >> >>  		xfs_ifork_init_cow(ip);
> >> >> +
> >> >> +	if ((from->di_version == 3) &&
> >> >> +	     xfs_has_nrext64(ip->i_mount) &&
> >> >> +	     !xfs_dinode_has_nrext64(from))
> >> >> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> >> >
> >> > Hmm.  Last time around I asked about the oddness of updating the inode
> >> > feature flags outside of a transaction, and then never responded. :(
> >> > So to quote you from last time:
> >> >
> >> >> The following is the thought process behind upgrading an inode to
> >> >> XFS_DIFLAG2_NREXT64 when it is read from the disk,
> >> >>
> >> >> 1. With support for dynamic upgrade, The extent count limits of an
> >> >> inode needs to be determined by checking flags present within the
> >> >> inode i.e.  we need to satisfy self-describing metadata property. This
> >> >> helps tools like xfs_repair and scrub to verify inode's extent count
> >> >> limits without having to refer to other metadata objects (e.g.
> >> >> superblock feature flags).
> >> >
> >> > I think this makes an even /stronger/ argument for why this update
> >> > needs to be transactional.
> >> >
> >> >> 2. Upgrade when performed inside xfs_trans_log_inode() may cause
> >> >> xfs_iext_count_may_overflow() to return -EFBIG when the inode's
> >> >> data/attr extent count is already close to 2^31/2^15 respectively.
> >> >> Hence none of the file operations will be able to add new extents to a
> >> >> file.
> >> >
> >> > Aha, there's the reason why!  You're right, xfs_iext_count_may_overflow
> >> > will abort the operation due to !NREXT64 before we even get a chance to
> >> > log the inode.
> >> >
> >> > I observe, however, that any time we call that function, we also have a
> >> > transaction allocated and we hold the ILOCK on the inode being tested.
> >> > *Most* of those call sites have also joined the inode to the transaction
> >> > already.  I wonder, is that a more appropriate place to be upgrading the
> >> > inodes?  Something like:
> >> >
> >> > /*
> >> >  * Ensure that the inode has the ability to add the specified number of
> >> >  * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
> >> >  * the transaction.  Upon return, the inode will still be in this state
> >> >  * upon return and the transaction will be clean.
> >> >  */
> >> > int
> >> > xfs_trans_inode_ensure_nextents(
> >> > 	struct xfs_trans	**tpp,
> >> > 	struct xfs_inode	*ip,
> >> > 	int			whichfork,
> >> > 	int			nr_to_add)
> >> > {
> >> > 	int			error;
> >> >
> >> > 	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> >> > 	if (!error)
> >> > 		return 0;
> >> >
> >> > 	/*
> >> > 	 * Try to upgrade if the extent count fields aren't large
> >> > 	 * enough.
> >> > 	 */
> >> > 	if (!xfs_has_nrext64(ip->i_mount) ||
> >> > 	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
> >> > 		return error;
> >> >
> >> > 	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> >> > 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> >> >
> >> > 	error = xfs_trans_roll(tpp);
> >> > 	if (error)
> >> > 		return error;
> >> >
> >> > 	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> >> > }
> >> >
> >> > and then the current call sites become:
> >> >
> >> > 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
> >> > 			dblocks, rblocks, false, &tp);
> >> > 	if (error)
> >> > 		return error;
> >> >
> >> > 	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
> >> > 			XFS_IEXT_ADD_NOSPLIT_CNT);
> >> > 	if (error)
> >> > 		goto out_cancel;
> >> >
> >> > What do you think about that?
> >> >
> >> 
> >> I went through all the call sites of xfs_iext_count_may_overflow() and I think
> >> that your suggestion can be implemented.
> 
> Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
> xfs_symlink().
> 
> Just after invoking xfs_iext_count_may_overflow(), we execute the following
> steps,
> 
> 1. Allocate inode chunk
> 2. Initialize inode chunk.
> 3. Insert record into inobt/finobt.
> 4. Roll the transaction.
> 5. Allocate ondisk inode.
> 6. Add directory inode to transaction.
> 7. Allocate blocks to store symbolic link path name.
> 8. Log symlink's inode (data fork contains block mappings).
> 9. Log data blocks containing symbolic link path name.
> 10. Add name to directory and log directory's blocks.
> 11. Log directory inode.
> 12. Commit transaction.
> 
> xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
> occur before step 1 since xfs_trans_roll would unlock the inode by executing
> xfs_inode_item_committing().
> 
> xfs_create() has a similar flow.
> 
> Hence, I think we should retain the current logic of setting
> XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.

File creation shouldn't ever run into problems with
xfs_iext_count_may_overflow because (a) only symlinks get created with
mapped blocks, and never more than two; and (b) we always set NREXT64
(the inode flag) on new files if NREXT64 (the superblock feature bit) is
enabled, so a newly created file will never require upgrading.

--D

> >> 
> >> However, wouldn't the current approach suffice in terms of being functionally
> >> and logically correct? XFS_DIFLAG2_NREXT64 is set when inode is read from the
> >> disk and the first operation to log the changes made to the inode will make
> >> sure to include the new value of ip->i_diflags2. Hence we never end up in a
> >> situation where a disk inode has more than 2^31 data fork extents without
> >> having XFS_DIFLAG2_NREXT64 flag set.
> >> 
> >> But the approach described above does go against the convention of changing
> >> metadata within a transaction. Hence I will try to implement your suggestion
> >> and include it in the next version of the patchset.
> >
> > Ok, that sounds good. :)
> >
> 
> -- 
> chandan
