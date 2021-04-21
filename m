Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0399EC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC65761420
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhDUAXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233936AbhDUAXR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E4826141D;
        Wed, 21 Apr 2021 00:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964565;
        bh=viGOzm7D2P5FEzYjq/2EyTlsrs0baffcyg6OlbG5//0=;
        h=Subject:From:To:Cc:Date:From;
        b=TyNN59ZHHMG0A6dbvCnT7ExwOtS7KadRxM95YRIlQkY2jln4X5cX0T4yECM/BjeOG
         lFowJy/d3goZPT0znWCXex/Zzpq4G6v6HhhjzpdeTySUAjGfoN7xUHfoO5/VBuQuuM
         ZgAujyVfjG1Q4I92DrYoD1XLftUias3clUiYPrIbLujoTQwU62kprnvhOAf838cEHU
         EIk7DAntO2FG4H2L7OOpc3vbUha0/U4ByzfY/iPt07IqY5LEWR+pfEp8ndhxP+DcLC
         2Lz8+m31fX2GArd72acLsVD5y3nxaTPz3dxiQTCFQWuuT3eomyESkcCvYoK9nDDF79
         JxW5tcqzCp9eQ==
Subject: [PATCHSET v2 0/2] fstests: add inode btree blocks counters to the AGI
 header
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:22:44 -0700
Message-ID: <161896456467.776366.1514131340097986327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Years ago, Christoph diagnosed a problem where freeing an inode on a
totally full filesystem could fail due to finobt expansion not being
able to allocate enough blocks.  He solved the problem by using the
per-AG block reservation system to ensure that there are always enough
blocks for finobt expansion, but that came at the cost of having to walk
the entire finobt at mount time.  This new feature solves that
performance regression by adding inode btree block counts to the AGI
header.  The patches in this series amend fstests to handle the new
metadata fields and to test that upgrades work properly.

v2: move the xfs_admin functional test into a separate patch file and
    split them into one test for basic functionality and another for
    the extended functionality testing that modifies the test run config

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inobt-counters

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inobt-counters

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=inobt-counters
---
 common/xfs        |   23 +++++++++++
 tests/xfs/764     |   93 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/764.out |   17 ++++++++
 tests/xfs/773     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/773.out |   19 +++++++++
 tests/xfs/910     |   98 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/910.out |   23 +++++++++++
 tests/xfs/group   |    3 +
 8 files changed, 390 insertions(+)
 create mode 100755 tests/xfs/764
 create mode 100644 tests/xfs/764.out
 create mode 100755 tests/xfs/773
 create mode 100644 tests/xfs/773.out
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out

