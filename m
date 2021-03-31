Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBC3C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C55CA619D7
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhCaBIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232788AbhCaBI0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6864B6190A;
        Wed, 31 Mar 2021 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152905;
        bh=MEQ5ZrsGdCTiCgWhCYJWUH1zak8tzk59jxX3faVZaRk=;
        h=Subject:From:To:Cc:Date:From;
        b=h/qWI6b4SNKo3Usz/aR4CRWSLFnZgRlfRqT5PM+9QvzTTt9nRnsU6uu2u5v2wjLHc
         RmvhDTgFS8oDt9s8fQ3sthIk0hsxkYtS3LcZGq2lch2zCATPu+k4LbLA1fhSMHJGUr
         COltslFeiLo+zSvIh2JICSpqwuye61SiZNASZT9FryBhwqsaWPulZSW1LXIuE2eTMs
         wqcl40wgVBcl1JOoLAEZsgzsouE1y4kRLhoxzcMwxbHA9wMPdPpGnxHHOQCRgkLJim
         iQ7tuDEzEj4i8qpqQTqXZHO7T9K+o+xHnqh2OMS9IPq9bSavrCpKTqVTIqIHMl9ZNZ
         mFTpFx7ze2Qpg==
Subject: [PATCHSET v2 0/2] fstests: add inode btree blocks counters to the AGI
 header
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:23 -0700
Message-ID: <161715290311.2703879.6182444659830603450.stgit@magnolia>
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
 common/xfs        |   21 ++++++++++
 tests/xfs/764     |   91 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/764.out |   17 ++++++++
 tests/xfs/773     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/773.out |   19 +++++++++
 tests/xfs/910     |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/910.out |   23 +++++++++++
 tests/xfs/group   |    3 +
 8 files changed, 400 insertions(+)
 create mode 100755 tests/xfs/764
 create mode 100644 tests/xfs/764.out
 create mode 100755 tests/xfs/773
 create mode 100644 tests/xfs/773.out
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out

