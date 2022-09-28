Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C054C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 21:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiI1V4a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 17:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiI1V4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 17:56:24 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B052870B2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 14:56:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 312278AC3AA
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 07:56:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1odf2S-00DK2i-F5
        for linux-xfs@vger.kernel.org; Thu, 29 Sep 2022 07:56:20 +1000
Date:   Thu, 29 Sep 2022 07:56:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next updated to dc256418235a
Message-ID: <20220928215620.GD3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6334c306
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=kR6-9MUt5XfikCYSSSYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I just pushed a small bug fix update to the for-next branch of the
XFS repository. If there's anything that absolutely needs to be
included in the next release, please let me know ASAP. Changes can
be found here:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

-Dave.

----------------------------------------------------------------
Head commit:

	d9e8a5cdd6bfe36c942bc367296bf95d3c3a83ec
	d9e8a5cdd6bf xfs: on memory failure, only shut down fs after scanning all mappings

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: on memory failure, only shut down fs after scanning all mappings

Stephen Zhang (2):
      xfs: trim the mapp array accordingly in xfs_da_grow_inode_int
      xfs: rearrange the logic and remove the broken comment for xfs_dir2_isxx

 fs/xfs/libxfs/xfs_da_btree.c |  2 +-
 fs/xfs/libxfs/xfs_dir2.c     | 50 ++++++++++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_dir2.h     |  4 ++--
 fs/xfs/scrub/dir.c           |  2 +-
 fs/xfs/xfs_dir2_readdir.c    |  2 +-
 fs/xfs/xfs_notify_failure.c  | 26 +++++++++++++++++---------
 6 files changed, 52 insertions(+), 34 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
