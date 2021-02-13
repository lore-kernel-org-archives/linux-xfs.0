Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E92C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A006B64E23
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbhBMFeU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhBMFeM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2968E64E95;
        Sat, 13 Feb 2021 05:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194412;
        bh=wyO6gUyQeclIJb/dq8Czo/iT9ALO0qYTd6soo6aQ80k=;
        h=Subject:From:To:Cc:Date:From;
        b=OP80OvdMtJFnekClxiIt19tYGVhh8PAUr6DB7VQa9tjwF1s0o43AFczyZ+mSXzYch
         bOsSA0GuTTovzhNmUjkfpVlEdxkEWrfN2rELdOr0qaYkM10dqq7KwJuy0bxIU2y375
         Gs2+7/6T/Lf3NxWtVZnY/yEGAi1DSvHCBYFHZfV0Evcv6MnYvmTgUDQj8jKYHXNW2o
         4K3SmxoopxohtGu8HR4a0LVPiIoM/iBlBeY8iF31mxuvprdYhG467haqlWUnYsnPi2
         Y6zPfEYfd0srSD0eWPBb3GBRCyRHgjvAiuautX+Bb9ecOdm2u64OOJ+SnqDIl+zafs
         5cqbg+jxgFleg==
Subject: [PATCHSET RFC 0/3] fstests: add inode btree blocks counters to the
 AGI header
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:31 -0800
Message-ID: <161319441183.403510.7352964287278809555.stgit@magnolia>
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
 common/xfs        |   20 ++++++
 tests/xfs/010     |    3 +
 tests/xfs/030     |    2 +
 tests/xfs/122.out |    2 -
 tests/xfs/764     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/764.out |   21 ++++++
 tests/xfs/910     |   84 +++++++++++++++++++++++
 tests/xfs/910.out |    8 ++
 tests/xfs/group   |    2 +
 9 files changed, 330 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/764
 create mode 100644 tests/xfs/764.out
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out

