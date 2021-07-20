Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79FFC07E9B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAB32611ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381582AbhGTAcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381034AbhGTA2G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73E7C610D2;
        Tue, 20 Jul 2021 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743323;
        bh=8ZRxh2vdEVL6nhqh6dzlhr4dW8QPSFm7m8DO33sBWfw=;
        h=Subject:From:To:Cc:Date:From;
        b=iO777ONrRm8Bkua3wIQdcbSG/q/zhi7/0bgwmCe28Ar4aS4HEc7A1SM89IiHf/cya
         zAVQl96hmzsbkM47iGEPe01E7W4MOPZNjZg4sragrFTly7WAKYdbb0mAy4OqsaZJmz
         PSkx/r7WHwtkeUt2GA1NxHU+C1cmc/yLDPIX5KEPaQR1lnacGbLkgl5P8yY+GDUBOD
         JML/F2lJ27twpyaIPclhojFxzPfzwqw5WUMI3Y7oax+TmoCYGApDvPQicINuoH9esH
         XXp8BfWUG7+hC5TF4Z3IvQPpN/UlsFSMnJny0c7ELhUYhk/6FZhyy5nazEopppv8G/
         IprnZWmTlLhWw==
Subject: [PATCHSET 0/2] fstests: exercise code refactored in 5.14
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:43 -0700
Message-ID: <162674332320.2650898.17601790625049494810.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add a few tests to exercise code that got refactored in 5.14.  The xattr
tests shook out some bugs in the big extended attributes refactoring,
and the nested shutdown test simulates the process of recovering after a
VM host filesystem goes down and the guests have to recover.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.14
---
 tests/generic/724     |   57 +++++++++++++++++++++
 tests/generic/724.out |    2 +
 tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/725.out |    2 +
 4 files changed, 197 insertions(+)
 create mode 100755 tests/generic/724
 create mode 100644 tests/generic/724.out
 create mode 100755 tests/generic/725
 create mode 100644 tests/generic/725.out

