Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D34FC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350465AbiDKW4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348185AbiDKW4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C0FA195;
        Mon, 11 Apr 2022 15:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DBC161773;
        Mon, 11 Apr 2022 22:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB233C385A5;
        Mon, 11 Apr 2022 22:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717671;
        bh=6c0PSMb/5v7u7faMEElV48N7fj9H4fs8ekzx127fTe0=;
        h=Subject:From:To:Cc:Date:From;
        b=gCDpXtbCB85/I/8UAnhdon+HO3aDeL3d4uBLIUkm5RaMl3k/533vxoVP9ovKHJAiR
         i/MX40nVmAikTooM9hZhIYM7QoqvS9v0jSZ7mQMaAzRu6VvbbjNZHGAN5HkUG79iG8
         7V+0CIFWGq/wqc8Ze2hFmpVt/JmQ+OGAP2aV+nse/nMKFf0z6D0gxiBznfalVU/MHe
         Kd4MP1FxyvKQANDHSY/gSvTbcH+4PGXHlK/Xd073Shxz4tUaHp7yJgi11WUK0wIMX6
         UtKYVGhv/OB+KhtNPcmktfi/JuOWjfWPcCvHFuwc0FmAGqWtpkhzVurf4JEWGdCodN
         RnGhJcz6jC42g==
Subject: [PATCHSET 0/4] fstests: new tests for kernel 5.18
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:54:31 -0700
Message-ID: <164971767143.169983.12905331894414458027.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new tests for bugfixes merged during 5.18.  Specifically, we now
check quota enforcement when linking and renaming into a directory.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-merge-5.18

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-5.18
---
 tests/generic/832     |   67 ++++++++++++++++++++++++++
 tests/generic/832.out |    3 +
 tests/generic/833     |   71 +++++++++++++++++++++++++++
 tests/generic/833.out |    3 +
 tests/generic/834     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/834.out |   33 +++++++++++++
 tests/generic/835     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/835.out |   33 +++++++++++++
 tests/generic/836     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/836.out |   33 +++++++++++++
 tests/generic/837     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/837.out |   33 +++++++++++++
 tests/generic/838     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/838.out |   33 +++++++++++++
 tests/generic/839     |   77 ++++++++++++++++++++++++++++++
 tests/generic/839.out |   13 +++++
 tests/xfs/839         |   42 ++++++++++++++++
 tests/xfs/839.out     |    2 +
 18 files changed, 1078 insertions(+)
 create mode 100755 tests/generic/832
 create mode 100644 tests/generic/832.out
 create mode 100755 tests/generic/833
 create mode 100644 tests/generic/833.out
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

