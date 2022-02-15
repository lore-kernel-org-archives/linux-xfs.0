Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1E4C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 09:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiBOJdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 04:33:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbiBOJdN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 04:33:13 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF24EB12C3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 01:33:03 -0800 (PST)
Received: from dread.disaster.area (pa49-186-85-251.pa.vic.optusnet.com.au [49.186.85.251])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DE52E10C7148;
        Tue, 15 Feb 2022 20:33:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nJuCj-00CGSp-Bk; Tue, 15 Feb 2022 20:33:01 +1100
Date:   Tue, 15 Feb 2022 20:33:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220215093301.GZ59715@dread.disaster.area>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
 <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220214170728.GI8313@magnolia>
 <87v8xglj59.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8xglj59.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=620b734e
        a=2CV4XU02g+4RbH+qqUnf+g==:117 a=2CV4XU02g+4RbH+qqUnf+g==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=sLS7d3TKV57v9N-bVlwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 15, 2022 at 12:18:50PM +0530, Chandan Babu R wrote:
> On 14 Feb 2022 at 22:37, Darrick J. Wong wrote:
> > On Fri, Feb 11, 2022 at 05:40:30PM +0530, Chandan Babu R wrote:
> >> On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
> >> > On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
> >> >> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
> >> >> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
> >> >> I went through all the call sites of xfs_iext_count_may_overflow() and I think
> >> >> that your suggestion can be implemented.
> >> 
> >> Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
> >> xfs_symlink().
> >> 
> >> Just after invoking xfs_iext_count_may_overflow(), we execute the following
> >> steps,
> >> 
> >> 1. Allocate inode chunk
> >> 2. Initialize inode chunk.
> >> 3. Insert record into inobt/finobt.
> >> 4. Roll the transaction.
> >> 5. Allocate ondisk inode.
> >> 6. Add directory inode to transaction.
> >> 7. Allocate blocks to store symbolic link path name.
> >> 8. Log symlink's inode (data fork contains block mappings).
> >> 9. Log data blocks containing symbolic link path name.
> >> 10. Add name to directory and log directory's blocks.
> >> 11. Log directory inode.
> >> 12. Commit transaction.
> >> 
> >> xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
> >> occur before step 1 since xfs_trans_roll would unlock the inode by executing
> >> xfs_inode_item_committing().
> >> 
> >> xfs_create() has a similar flow.
> >> 
> >> Hence, I think we should retain the current logic of setting
> >> XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.
> >
> > File creation shouldn't ever run into problems with
> > xfs_iext_count_may_overflow because (a) only symlinks get created with
> > mapped blocks, and never more than two; and (b) we always set NREXT64
> > (the inode flag) on new files if NREXT64 (the superblock feature bit) is
> > enabled, so a newly created file will never require upgrading.
> 
> The inode representing the symbolic link being created cannot overflow its
> data fork extent count field. However, the inode representing the directory
> inside which the symbolic link entry is being created, might overflow its data
> fork extent count field.

I dont' think that can happen. A directory is limited in size to 3
segments of 32GB each. In reality, only the data segment can ever
reach 32GB as both the dabtree and free space segments are just
compact indexes of the contents of the 32GB data segment.

Hence a directory is never likely to reach more than about 40GB of
blocks which is nowhere near large enough to overflowing a 32 bit
extent count field.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
