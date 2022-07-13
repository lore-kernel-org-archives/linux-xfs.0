Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1F1C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 01:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiGMBKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiGMBKG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 21:10:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA4FD0394
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 18:10:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A94B0B81C95
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 01:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC32C3411E;
        Wed, 13 Jul 2022 01:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657674603;
        bh=jBBVlR7p/4jq8BIuKvSAQfN7V3BrjxEd9ZwY6edk8FY=;
        h=Subject:From:To:Cc:Date:From;
        b=ltM9BP6+7EvYwQHO04c9dAvc1ovYgrasLTGye+pmqYJOOKEyg/Gmzw5G5L8Kk7/yV
         hXQqBZfGlbAlJu4R9J0uAs9zS/07NKaaN1QVLlkTtxmpbNaA5NIJb5PKEc0JSESncD
         HzlloWfTpGC3b6EeqHt0fC65vBKKxohfwV9K6n1OejPMFndKVAyGvdPGmakHJJ3MpY
         r6FyBKHkeT4JJGq7mm/LojBrvM7OeVYYuNLOWenreYIpNhh2hTdn5C6Sq+MbJRU9B5
         rEuVBcRtHlul7vJ5TnP47NWC7wu9s9hMciNGaynyrItr9t/RVc7KN1O2rWX3QpYe3b
         S9/lWL/qmsPeA==
Subject: [PATCHSET v4 0/2] xfs_repair: enable upgrading to nrext64
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 12 Jul 2022 18:10:02 -0700
Message-ID: <165767460292.892222.8527830050022729631.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset enables sysadmins to upgrade an existing filesystem to use
large extent counts.

v4: get rid of the free space checks entirely since none of the supported
    features actually use up any disk space
v3: don't allow upgrades for filesystems that are more than 90 percent full
    because we just dont want to go there
v2: pull in patches from chandan/dave

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=nrext64-upgrade
---
 include/xfs_mount.h      |    1 
 libxfs/init.c            |   24 +++++---
 libxfs/libxfs_api_defs.h |    3 +
 man/man8/xfs_admin.8     |    7 ++
 repair/globals.c         |    1 
 repair/globals.h         |    1 
 repair/phase2.c          |  137 +++++++++++++++++++++++++++++++++++++++++++---
 repair/xfs_repair.c      |   11 ++++
 8 files changed, 168 insertions(+), 17 deletions(-)

