Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF763C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbiLaBEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiLaBEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:04:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF4A1DDE4;
        Fri, 30 Dec 2022 17:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE6F7B81DFB;
        Sat, 31 Dec 2022 01:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6F0C433EF;
        Sat, 31 Dec 2022 01:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448646;
        bh=rIYxkUDlz265Yg6+kEk3fy+cqf2vke66TjSyz3DKS8o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VPcmaay+T4EGtEAAizR8RVqDC2IE4wvHbd0wmv/ne4oWOpxeMSoXwuFer52BhggkL
         NobmV63uK2R4hsOOIS6Snv7pbsRihHOrAT2xTng2f3/zE45nMnOz0fe8eWu9a4keyx
         YYJmWisE2x5N6bhEmfeNXSKNVXQ+UVC7fCeq7iqePJszWPq+KMqqLmWChzCNALzeJN
         EsB+ETsGJZg3BuV8l/F/m0VbiH0FEWHS4IR8feIJMy0zZvs4uYGj1D1/3JamZQB6sz
         d9h8CJQDDHzLkJW/5ZDKUT0+22h/Q74sWrW/t3HUINULe2dLmhK0pweTki8gthN/r1
         Fgw21QKd9qC0Q==
Subject: [PATCHSET v1.0 00/12] xfsprogs: shard the realtime section
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:39 -0800
Message-ID: <167243883943.739029.3041109696120604285.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Right now, the realtime section uses a single pair of metadata inodes to
store the free space information.  This presents a scalability problem
since every thread trying to allocate or free rt extents have to lock
these files.  It would be very useful if we could begin to tackle these
problems by sharding the realtime section, so create the notion of
realtime groups, which are similar to allocation groups on the data
section.

While we're at it, define a superblock to be stamped into the start of
each rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and helpfully avoids the situation
where a file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups
---
 common/fuzzy            |   33 +++++++++++++++----
 common/populate         |   12 ++++++-
 common/xfs              |   83 ++++++++++++++++++++++++++++++++++++++++-------
 src/punch-alternating.c |   28 +++++++++++++++-
 tests/xfs/114           |    4 ++
 tests/xfs/122           |    2 +
 tests/xfs/122.out       |    8 +++++
 tests/xfs/146           |    2 +
 tests/xfs/185           |    2 +
 tests/xfs/187           |    3 +-
 tests/xfs/206           |    3 +-
 tests/xfs/271           |    3 +-
 tests/xfs/341           |    4 +-
 tests/xfs/449           |    6 +++
 tests/xfs/556           |   16 ++++++---
 tests/xfs/800           |    2 +
 tests/xfs/840           |    2 +
 tests/xfs/841           |    2 +
 18 files changed, 176 insertions(+), 39 deletions(-)

