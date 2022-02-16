Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92547C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245325AbiBPBQu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:16:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245429AbiBPBQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:16:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0847F65F5
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8211E616CD
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45D2C340EB;
        Wed, 16 Feb 2022 01:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644974193;
        bh=K6zv6OHJiQ2Ct114rF3vKLowtzZcIzRvVfM0MBdybOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JDQz5kmifWXS1bPGN7jzch4y9KU0dhYlWuq3UuNgTzutG9QscEBvQJmB2moVxzLLk
         jrmXfRRuZCLgAx8g8GJDx25HXBGZIIGIWfsjou7pPVwpNVkCj4jBaDYpX2HStpT14s
         bsYCl+DCgXgVxNfAOSE5SqYdIaapfxtNbeO49rAdMiZy5pCsY7YfTmZwsfMolBWY8P
         YQ1bCqCyLdAcJMxQOEVzSeeqgDWu5rzGpv7Wj5rJ+9AUyn9bPRCwk+QahL2FFs/zgl
         vMlRGE3b6EFa2YFCsh7R68lrwTIVfgXO8rgcc4wX5L8wdp5xHk5hONaYsvvqbkxvke
         MSck7l2jq5fTA==
Date:   Tue, 15 Feb 2022 17:16:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220216011633.GH8338@magnolia>
References: <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
 <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220214170728.GI8313@magnolia>
 <87v8xglj59.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220215093301.GZ59715@dread.disaster.area>
 <87sfskl5z6.fsf@debian-BULLSEYE-live-builder-AMD64>
 <87pmnol17j.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmnol17j.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 15, 2022 at 06:46:16PM +0530, Chandan Babu R wrote:
> On 15 Feb 2022 at 17:03, Chandan Babu R wrote:
> > On 15 Feb 2022 at 15:03, Dave Chinner wrote:
> >> On Tue, Feb 15, 2022 at 12:18:50PM +0530, Chandan Babu R wrote:
> >>> On 14 Feb 2022 at 22:37, Darrick J. Wong wrote:
> >>> > On Fri, Feb 11, 2022 at 05:40:30PM +0530, Chandan Babu R wrote:
> >>> >> On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
> >>> >> > On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
> >>> >> >> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
> >>> >> >> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
> >>> >> >> I went through all the call sites of xfs_iext_count_may_overflow() and I think
> >>> >> >> that your suggestion can be implemented.
> >>> >> 
> >>> >> Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
> >>> >> xfs_symlink().
> >>> >> 
> >>> >> Just after invoking xfs_iext_count_may_overflow(), we execute the following
> >>> >> steps,
> >>> >> 
> >>> >> 1. Allocate inode chunk
> >>> >> 2. Initialize inode chunk.
> >>> >> 3. Insert record into inobt/finobt.
> >>> >> 4. Roll the transaction.
> >>> >> 5. Allocate ondisk inode.
> >>> >> 6. Add directory inode to transaction.
> >>> >> 7. Allocate blocks to store symbolic link path name.
> >>> >> 8. Log symlink's inode (data fork contains block mappings).
> >>> >> 9. Log data blocks containing symbolic link path name.
> >>> >> 10. Add name to directory and log directory's blocks.
> >>> >> 11. Log directory inode.
> >>> >> 12. Commit transaction.
> >>> >> 
> >>> >> xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
> >>> >> occur before step 1 since xfs_trans_roll would unlock the inode by executing
> >>> >> xfs_inode_item_committing().
> >>> >> 
> >>> >> xfs_create() has a similar flow.
> >>> >> 
> >>> >> Hence, I think we should retain the current logic of setting
> >>> >> XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.
> >>> >
> >>> > File creation shouldn't ever run into problems with
> >>> > xfs_iext_count_may_overflow because (a) only symlinks get created with
> >>> > mapped blocks, and never more than two; and (b) we always set NREXT64
> >>> > (the inode flag) on new files if NREXT64 (the superblock feature bit) is
> >>> > enabled, so a newly created file will never require upgrading.
> >>> 
> >>> The inode representing the symbolic link being created cannot overflow its
> >>> data fork extent count field. However, the inode representing the directory
> >>> inside which the symbolic link entry is being created, might overflow its data
> >>> fork extent count field.
> >>
> >> I dont' think that can happen. A directory is limited in size to 3
> >> segments of 32GB each. In reality, only the data segment can ever
> >> reach 32GB as both the dabtree and free space segments are just
> >> compact indexes of the contents of the 32GB data segment.
> >>
> >> Hence a directory is never likely to reach more than about 40GB of
> >> blocks which is nowhere near large enough to overflowing a 32 bit
> >> extent count field.
> >
> > I think you are right.
> >
> > The maximum file size that can be represented by the data fork extent counter
> > in the worst case occurs when all extents are 1 block in size and each block
> > is 1k in size.
> >
> > With 1k byte sized blocks, a file can reach upto,
> > 1k * (2^31) = 2048 GB
> >
> > This is much larger than the asymptotic maximum size of a directory i.e.
> > 32GB * 3 = 96GB.

The downside of getting rid of the checks for directories is that we
won't be able to use the error injection knob that limits all forks to
10 extents max to see what happens when that part of directory expansion
fails.  But if it makes it easier to handle nrext64, then that's
probably a good enough reason to forego that.

> Also, I think I should remove extent count overflow checks performed in the
> following functions,
> 
> xfs_create()
> xfs_rename()
> xfs_link()
> xfs_symlink()

Those are probably ok to remove the checks.

> xfs_bmap_del_extent_real()

Not sure about this one, since it actually /can/ result in more extents.

--D

> ... Since they do not accomplish anything.
> 
> Please let me know your views on this.
> 
> -- 
> chandan
