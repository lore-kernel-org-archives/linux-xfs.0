Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB0AC54EE9
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 04:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiI1EXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 00:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiI1EXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 00:23:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80B71F01AB;
        Tue, 27 Sep 2022 21:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E0CA61CE6;
        Wed, 28 Sep 2022 04:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A83DC433C1;
        Wed, 28 Sep 2022 04:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664339031;
        bh=/UYsHX6L1OusPVE6L+cwdsYwdGo9NYQPD4LYYFjYzwc=;
        h=Subject:From:To:Cc:Date:From;
        b=KajiU4WfA5rgWvu61BEMzAhnZ0Fisz3SdKJg/O+r62zuqvzA0dpRwlKTP5K31XhKI
         Z36OTxSM4iDFU1sdyehITcfRv7Kzb5AYWhpGfmhpIfMV2KRoB3CrAEUpG8uvAyXB1p
         RXtZrAmbWfnALtOHshd1cYjMrEIuNdZd+iyVRibHqZkCFXnP5l/bV+P3AwrYpkrerK
         dIdkHEKt6qf91XFT6qL8qi82O8FeZVOwKFSNMWpHFl60bZmYJj2bRy+2BhYVDymnw5
         ZGC0V7akcB/hcMKSD/BKpseZ8CQjRC02SbdhaQXA8hNoI240kj9AyrtWfmk8epvmBB
         JSyGVWQg1lp5A==
Subject: [PATCHSET v23.1 0/3] fstests: random fixes for v2022.09.25
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Sep 2022 21:23:51 -0700
Message-ID: <166433903099.2008389.13181182359220271890.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual batch of odd fixes for fstests.

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
 common/xfs        |    3 +++
 tests/generic/092 |    6 ++++++
 tests/xfs/114     |    2 ++
 tests/xfs/229     |    7 ++++++-
 4 files changed, 17 insertions(+), 1 deletion(-)

