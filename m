Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9B1C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbiLaBDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235878AbiLaBDV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:03:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1B31DDF0;
        Fri, 30 Dec 2022 17:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A93A61D68;
        Sat, 31 Dec 2022 01:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C48C433D2;
        Sat, 31 Dec 2022 01:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448599;
        bh=MJ7lGJplFFURUHpwrj75AmVRtotvao1YzPEYvdbAumc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u/hC9jR3ndeLMVwW78l8pbJs+On82UqvrsaMnHhvIJNWVitbgABzkLK/WKPAzNniz
         Au3L3zZaw5VXMRoiliNfWkxek20P4BJHOVaVzClYzxr1lkHXJsmzosFd48uJ6XLvDD
         +5SjxIgnrq6NnacVRv0+otwyVV75RY3UJys1vTL3aWBSWEbTU9j4N3dWz5hwwIIAOI
         +tz2AOcJrM9wxoFTmZgagFY6jAGdQtJ3onvJ5EP9mRdhkTFxz0ztMu90+Wdkxrx8jX
         y1l7u4TSU+Ao/HrKmeTQOGEDUesVhkaaik+IeuvqlDn0GATyPo4QLmk+ZcorR3FPdq
         Ls7OnomINi/Xg==
Subject: [PATCHSET 0/1] fstests: test upgrading older features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:29 -0800
Message-ID: <167243882949.736459.9627363155663418213.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here is a general regression test to make sure that we can invoke the
xfs_repair feature to add new features to V5 filesystems without errors.
There are already targeted functionality tests for inobtcount and
bigtime; this new one exists as a general upgrade exerciser.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-older-features

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=upgrade-older-features
---
 tests/xfs/769     |  248 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/769.out |    2 
 2 files changed, 250 insertions(+)
 create mode 100755 tests/xfs/769
 create mode 100644 tests/xfs/769.out

