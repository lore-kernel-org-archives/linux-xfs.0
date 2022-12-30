Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F55C10F1B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiL3W3W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3W3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:29:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BE71D0E2;
        Fri, 30 Dec 2022 14:29:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C92BDCE19BB;
        Fri, 30 Dec 2022 22:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131BBC433EF;
        Fri, 30 Dec 2022 22:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439358;
        bh=Tea2cDALhGhYv7r3QiZFvT544ztxUfUUk5+tD7XtxRU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IokQuVRxiV1g+Vm/AsXqx3QEMgT3340GpGGjQ9QUltaNWVjcM4YrMbR4PPJ7y/shX
         MhOlX66DeCaRe8DyVrfmXm8vQnEnHjIV4QoC37aCDAtk6jyAkLMYos1OhmdgWYbtPo
         tzfTxcyrlFhF+UTM7e1O98+wFkB3p+qixPU9z+cmzTTEcacONbgXAtTkj/RtU/yWT1
         Ox832AG7BnJuu4IFnDmkoEnLCFs7iCS1UE965XAH+XegF08qFedyuYMnEoF28GET32
         OYdwGl1MD4ihUW5EOjVSrdhPulurJQs66v2bhE7/DDAHkzd+wLITg5QT/g1PzlK3Nr
         CmFF9cOwvOjbA==
Subject: [PATCHSET v24.0 0/2] fstests: race online scrub with mount state
 changes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:13:00 -0800
Message-ID: <167243838066.695417.12457890635253015617.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Introduce the ability to run xfs_scrub(8) itself from our online fsck
stress test harness.  Create two new tests to race scrub and repair
against fsstress, and four more tests to do the same but racing against
fs freeze and ro remounts.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=race-scrub-and-mount-state-changes
---
 common/fuzzy      |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 tests/xfs/285     |   44 ++++++++++---------------------------
 tests/xfs/285.out |    4 +--
 tests/xfs/286     |   46 ++++++++++-----------------------------
 tests/xfs/286.out |    4 +--
 tests/xfs/733     |   39 +++++++++++++++++++++++++++++++++
 tests/xfs/733.out |    2 ++
 tests/xfs/771     |   39 +++++++++++++++++++++++++++++++++
 tests/xfs/771.out |    2 ++
 tests/xfs/824     |   40 ++++++++++++++++++++++++++++++++++
 tests/xfs/824.out |    2 ++
 tests/xfs/825     |   40 ++++++++++++++++++++++++++++++++++
 tests/xfs/825.out |    2 ++
 13 files changed, 252 insertions(+), 75 deletions(-)
 create mode 100755 tests/xfs/733
 create mode 100644 tests/xfs/733.out
 create mode 100755 tests/xfs/771
 create mode 100644 tests/xfs/771.out
 create mode 100755 tests/xfs/824
 create mode 100644 tests/xfs/824.out
 create mode 100755 tests/xfs/825
 create mode 100644 tests/xfs/825.out

