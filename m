Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8702BC83F1D
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbjH2XEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbjH2XEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:04:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2543EE9;
        Tue, 29 Aug 2023 16:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AED6F63CEB;
        Tue, 29 Aug 2023 23:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167FAC433C8;
        Tue, 29 Aug 2023 23:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350268;
        bh=t9cswbQnVrukCIrOfa8Meir7genz9SlSJTVBTD1G5aE=;
        h=Subject:From:To:Cc:Date:From;
        b=nxNKcEDlqrbQl2Vq1jMNRLoigrCQ8kZgjqDKeXnQHKvAnCGJ2yhJtidQL/oKTGpRW
         VUSmLUtg2+jZ4Pm8tfJAshUFNrAkETmRrcm91X67wVUcTmRZgpVjriZ9zrNoLKqcgp
         eeVxt1QX02TsCHbQWIxQWvkhYbko6MWuqnaXuzzUbVEkbik9bzPYy5uGwQ75KzPuLI
         gP3rW6dmn3LpiEYlqbxiSAuSNcOhNIymLs3gDtNUwMaG+cAMCuRQ6Qz0hxGhBPUVE5
         hM8Tqnu2fl/uq+Re6R1dM8e2lQuVDsadbZlHIcPsogoZVkYB6IxB1b8qgxbl4+E5jS
         Rk4ji0t9iu0NA==
Subject: [PATCHSET v2 0/1] xfs: fix fsmap cursor handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, david@fromorbit.com
Date:   Tue, 29 Aug 2023 16:04:27 -0700
Message-ID: <169335026762.3520701.5816499712408940016.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset addresses an integer overflow bug that Dave Chinner found
in how fsmap handles figuring out where in the record set we left off
when userspace calls back after the first call filled up all the
designated record space.

v2: add RVB tags

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-fsmap
---
 tests/xfs/935     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/935.out |    2 ++
 2 files changed, 57 insertions(+)
 create mode 100755 tests/xfs/935
 create mode 100644 tests/xfs/935.out

