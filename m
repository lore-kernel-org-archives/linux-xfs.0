Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAA1C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 01:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbiDKBVg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 21:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiDKBVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 21:21:34 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D5456338
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:19:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A1D1B10CEE34;
        Mon, 11 Apr 2022 11:19:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndii8-00GFCL-FW; Mon, 11 Apr 2022 11:19:20 +1000
Date:   Mon, 11 Apr 2022 11:19:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: recalculate free rt extents after log recovery
Message-ID: <20220411011920.GR1544202@dread.disaster.area>
References: <164961485474.70555.18228016043917319266.stgit@magnolia>
 <164961486596.70555.15167639007811062573.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164961486596.70555.15167639007811062573.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62538219
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=c11YcQPciRmk-N0707YA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 11:21:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I've been observing periodic corruption reports from xfs_scrub involving
> the free rt extent counter (frextents) while running xfs/141.  That test
> uses an error injection knob to induce a torn write to the log, and an
> arbitrary number of recovery mounts, frextents will count fewer free rt
> extents than can be found the rtbitmap.
> 
> The root cause of the problem is a combination of the misuse of
> sb_frextents in the incore mount to reflect both incore reservations
> made by running transactions as well as the actual count of free rt
> extents on disk.  The following sequence can reproduce the undercount:
> 
> Thread 1			Thread 2
> xfs_trans_alloc(rtextents=3)
> xfs_mod_frextents(-3)
> <blocks>
> 				xfs_attr_set()
> 				xfs_bmap_attr_addfork()
> 				xfs_add_attr2()
> 				xfs_log_sb()
> 				xfs_sb_to_disk()
> 				xfs_trans_commit()
> <log flushed to disk>
> <log goes down>
> 
> Note that thread 1 subtracts 3 from sb_frextents even though it never
> commits to using that space.  Thread 2 writes the undercounted value to
> the ondisk superblock and logs it to the xattr transaction, which is
> then flushed to disk.  At next mount, log recovery will find the logged
> superblock and write that back into the filesystem.  At the end of log
> recovery, we reread the superblock and install the recovered
> undercounted frextents value into the incore superblock.  From that
> point on, we've effectively leaked thread 1's transaction reservation.
> 
> The correct fix for this is to separate the incore reservation from the
> ondisk usage, but that's a matter for the next patch.  Because the
> kernel has been logging superblocks with undercounted frextents for a
> very long time and we don't demand that sysadmins run xfs_repair after a
> crash, fix the undercount by recomputing frextents after log recovery.
> 
> Gating this on log recovery is a reasonable balance (I think) between
> correcting the problem and slowing down every mount attempt.  Note that
> xfs_repair will fix undercounted frextents.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good now!

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
