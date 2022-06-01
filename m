Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED614C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 01:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348894AbiFABGo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 May 2022 21:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348866AbiFABGo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 May 2022 21:06:44 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23B1B251
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 18:06:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3C30110E6EAA
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 11:06:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nwCom-001D5r-MP
        for linux-xfs@vger.kernel.org; Wed, 01 Jun 2022 11:06:36 +1000
Date:   Wed, 1 Jun 2022 11:06:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: xfsprogs: 5.19 libxfs kernel sync (updated)
Message-ID: <20220601010636.GC227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6296bb9e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=vGsIz9D5mD4i_TKSvUEA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Folks,

I just pushed out a new update for the libxfs 5.19 sync for
xfsprogs. It updates the branch to include everything up to the
current kernel for-next kernel tree, and it includes all the support
code for the new large extent counter and logged attribute code.

The branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev.git libxfs-5.19-sync

This is running through fstests in various configs without
regressions (defaults, rmapbt=1, 1kB block size, v4 format, quotas
enabled, etc) so I think this is largely ready for merge into the
upstream xfsprogs code base. If you are testing a 5.19 or for-next
kernel tree, you probably should be using an xfsprogs built from
this branch, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
