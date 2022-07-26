Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F78C3F6B0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbiGZTsf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGZTsd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:48:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E2524BE8;
        Tue, 26 Jul 2022 12:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BD6B60682;
        Tue, 26 Jul 2022 19:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88FFC433D6;
        Tue, 26 Jul 2022 19:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864911;
        bh=0xESo7dCETL1ZcrR1vjLMW/BwuPCcQ+S65QRkCi9QFQ=;
        h=Subject:From:To:Cc:Date:From;
        b=HpSJLlEstGDT77PFSgS9E3qPHbi/O4HpivakgMEyMjWX251cd4UQnugK00GlaQyqJ
         0UnDawBsEU9MbXf0su5sBvF75GZcapynmSh+Wkl8534ea+SP8cdwtb5zdRFbUdLTai
         q11m3NVbBetJ220gNQYFtZI8ShoZ/tY2B3OxQbnH+NA/YAMajsCDo/KUCcL8XTD+sv
         g/yivBvvluJ4U4UheEaDVL9fCWjhkukH+QlxJNTt9J/oxJmPq8V22mWm0Ji3fHmog6
         1QP2d2C3IMxDyVduRA35hvNZd1tCYrE36kiDllyT5v1BB+yAHh1H0wcPGpUCCHYqkN
         u320F+tY227XA==
Subject: [PATCHSET 0/2] dmerror: support external log and rt devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 26 Jul 2022 12:48:31 -0700
Message-ID: <165886491119.1585061.14285332087646848837.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are a growing number of fstests that examine what happens to a
filesystem when the block device underneath it goes offline.  Many of
them do this to simulate system crashes, and none of them (outside of
btrfs) can handle filesystems with multiple devices.  XFS is one of
those beasts that does, so enhance the dm-error helpers to take the log
and rt devices offline when they're testing the data device.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=dmerror-on-rt-devices
---
 common/dmerror    |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 common/rc         |    5 ++
 tests/generic/441 |    2 -
 tests/generic/487 |    2 -
 4 files changed, 161 insertions(+), 7 deletions(-)

