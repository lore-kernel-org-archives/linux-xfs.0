Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF1DC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 03:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353464AbiCPDbo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353461AbiCPDbn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 23:31:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D983981F;
        Tue, 15 Mar 2022 20:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D07961727;
        Wed, 16 Mar 2022 03:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D05C340F6;
        Wed, 16 Mar 2022 03:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401429;
        bh=+nih/g+u9hHc0So5XncVSpdzCn2N9x4GpFVfzdQ/d8k=;
        h=Subject:From:To:Cc:Date:From;
        b=KL9t+A02S6loRrmvI+Y1SIdU5Mm/B9PCK5u0FF5BKz3ZDqbxT0LIx2gvp/3Hc0b/J
         erQusPo/fCdDZLcjnv6EJf5BGdn4yJClzqrYEXO87Smd6S/D/1HdYfUHQzfOW3rCI4
         Fd7efvQvmH9YujwwZBal3GM9uIeBd/jx7S398CV4E0OjHmdky7koBvuOxf/gUmTewR
         YOUCQv3xot1KaQrMFDy7LHdI/3d90wB6vwA9bpKk950/t/EZLQ3TLUnfidKIPLToOT
         Cn/q3tvAJYzpOmFXa5IyWA9lyhhpNCnUpqTl7euTbj3D8+dJqk1pgEgC325yVDJcRe
         1X5fhpGyW7IkQ==
Subject: [PATCHSET 0/2] fstests: new tests for kernel 5.17
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 15 Mar 2022 20:30:29 -0700
Message-ID: <164740142940.3371809.12686819717405148022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new tests for bugfixes merged during 5.17.  Specifically, we now
check that failures in xfs_fs_sync_fs actually get propagated to
userspace, and that fallocate actually updates setuid/setgid bits /and/
file capabilities correctly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-5.17

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-fixes-5.17
---
 tests/generic/834     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/834.out |   33 +++++++++++++
 tests/generic/835     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/835.out |   33 +++++++++++++
 tests/generic/836     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/836.out |   33 +++++++++++++
 tests/generic/837     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/837.out |   33 +++++++++++++
 tests/generic/838     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/838.out |   33 +++++++++++++
 tests/generic/839     |   79 ++++++++++++++++++++++++++++++
 tests/generic/839.out |   13 +++++
 tests/xfs/839         |   42 ++++++++++++++++
 tests/xfs/839.out     |    2 +
 14 files changed, 946 insertions(+)
 create mode 100755 tests/generic/834
 create mode 100644 tests/generic/834.out
 create mode 100755 tests/generic/835
 create mode 100644 tests/generic/835.out
 create mode 100755 tests/generic/836
 create mode 100644 tests/generic/836.out
 create mode 100755 tests/generic/837
 create mode 100644 tests/generic/837.out
 create mode 100755 tests/generic/838
 create mode 100644 tests/generic/838.out
 create mode 100755 tests/generic/839
 create mode 100755 tests/generic/839.out
 create mode 100755 tests/xfs/839
 create mode 100644 tests/xfs/839.out

