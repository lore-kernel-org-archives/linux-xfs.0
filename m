Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F643C30654
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 17:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjGCRDg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjGCRDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 13:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FB4E58;
        Mon,  3 Jul 2023 10:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 303CE60FE2;
        Mon,  3 Jul 2023 17:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89152C433C7;
        Mon,  3 Jul 2023 17:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688403813;
        bh=M9lap2eq4d1GcV/OyoRcMmCQOmeJ+vEH5h9nm034Uug=;
        h=Subject:From:To:Cc:Date:From;
        b=h2YstszovHjIWJTGDmdH+/Wciwl9s+MKxbWWS/ZovE2dRSvdvVD8jiijtEus2XFr/
         iTPWBSL52wguZ2wVRbMTqVPr+rDvYOOj9zqTjyp7ztrDXE4poV5cUdqLy7HmbqYH/Y
         vIvu9UxVIWqEJrfazVln8tT/V2jyPS6jzk3WPp+vG+GHvU1fMf+pvT2TxaZX8vq3NS
         iMapkXPtDamNx0C9tZQNY3xptaQQINxYBD9qJiqRJOWqDpJpzbiMSTLvVRDzDhevuh
         NIRTmwR8ABFCioSmvCSo6AfairJK3OBVZN/CT+EcqeU4T/4KBCvNQXNpEcunNR/cSz
         Y2mdAHj70qbng==
Subject: [PATCHSET 0/5] fstests: random fixes for v2023.06.18
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 03 Jul 2023 10:03:33 -0700
Message-ID: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 tests/xfs/041     |    3 ++
 tests/xfs/439     |    6 +++-
 tests/xfs/529     |    4 +++
 tests/xfs/569     |    2 +
 tests/xfs/934     |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/934.out |   19 +++++++++++++
 6 files changed, 110 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/934
 create mode 100644 tests/xfs/934.out

