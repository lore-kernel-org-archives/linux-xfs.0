Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFDEC04A68
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbiGZTs5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGZTs4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C4A33E3E;
        Tue, 26 Jul 2022 12:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F94D61513;
        Tue, 26 Jul 2022 19:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5CFC433D7;
        Tue, 26 Jul 2022 19:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864935;
        bh=2mdOZNHdE4uojgiWPVd4NzDoIRFvMwRwSAXIKqMUg9Q=;
        h=Subject:From:To:Cc:Date:From;
        b=sZUz3r347fdAtt/12tYjfP/Wa8Qfv2BGcL24pvNthVj55Rjvz7hglghV0nQGjUAeR
         0SrkLIho0a1qzvz8ugpKjHvF+6Yo3nDy6NxDq2s94FLbrbr/iLF32HIm8ukREMjsan
         /asvDSKTD92GOXOywY6sOQ27IKv9LBbOuapl9x46GKyGZbdEV/rWuykWmLI0pePXGH
         HFyfsh3F1dW8QzpEiSmaAJ8EEWoPHdqIV73Aqk47O/HfSg7NUs0QrjBpP7cGA3iDru
         f2M/+zHYNasgLRwzhMDRMzeOybzkQNFzzXlUlTZ2UcLtwri9sU2GvNYCdh2crEJbB9
         8p8+2/rJj6fIg==
Subject: [PATCHSET 0/2] fstests: enhance fail_make_request
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:48:54 -0700
Message-ID: <165886493457.1585218.32410114728132213.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series starts by refactoring boilerplate code around
fail_make_request (aka error injection in the block layer) and then
enhances it to play nicely with multi-device XFS filesystems.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-fail-make-request
---
 common/fail_make_request |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 common/rc                |    7 -----
 tests/btrfs/088          |   14 ++++------
 tests/btrfs/150          |   13 ++++-----
 tests/generic/019        |   40 ++++-------------------------
 5 files changed, 78 insertions(+), 59 deletions(-)
 create mode 100644 common/fail_make_request

