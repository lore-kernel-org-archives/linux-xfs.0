Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339A2C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA475619B3
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhCWEVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhCWEUc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0915561990;
        Tue, 23 Mar 2021 04:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473232;
        bh=yIoXXGVv2nSE9DXKyj3BGaHRMj4hN6sdaTADiPavH2Y=;
        h=Subject:From:To:Cc:Date:From;
        b=Ns1GY6J6GjiPXDW+ugYXD1jkW68mEEv8Lxe7vbS5a8EUCFs5CjAFEB1aTVVuIOUoQ
         1nYvmrYMYLRmqbh9XyrQRSS/WbzYc215dqAh10pPimfGCyEdy5CBoO60cf+kqqVkMD
         yvVfEMkOJkImlG0R51GmV5D9I/U6SIbXUUraH4Ui1q1CrhCGZI3Zqp7SZUhVrvcCoX
         MPo7g8t7E8SIm55kyPZOOuf5O9c3eF4/gAVMTU+9k+PgbPEvg5OldNtAdzIwYoSTRc
         vm/g6eMAeetBuGHdw4DO7i85uKb9ODkKh6vmogHke2s72fznjQYaLlg17Qluo8y4P7
         cD49NwmphXHbg==
Subject: [PATCHSET 0/2] fstests: make sure NEEDSREPAIR feature stops mounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:31 -0700
Message-ID: <161647323173.3431002.17140233881930299974.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Quick test to make sure that having the new incompat "needs repair" feature
flag actally prevents mounting, and that xfs_repair can clean up whatever
happened.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=needsrepair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=needsrepair

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=needsrepair
---
 common/xfs        |    8 ++++
 tests/xfs/768     |   84 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    2 +
 tests/xfs/770     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 6 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out

