Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8389AEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjG0WTX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjG0WTV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0F12D5E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6023361F57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D73C433C8;
        Thu, 27 Jul 2023 22:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496359;
        bh=YFgxBPmvYADRMYpgzJ0l894qJrcZdf3CFk11FaHuy6E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=F3kbxL/56ZnewNG7VPKkgIHZtsZ775ABnXSWeNL2UTYlzpri7quS14SwY8dd4jSCd
         2bpQ1EUh7UFookO3pZnau/4UGHESMvMeKAb+nbSERXhanWCz4RXm3APhlQZ+re5LS+
         3aeuugwBgjcOT9arlw8pprr57hfC9cVoQYwA8dQoEDdbL/GT3ONBcuZB6V3NZPm1Xt
         8XPUgNTQqqkGOsgQpVGkUzqkoqDdqH+mTMF8QKSsvOm1UKnJP5g0PDFEiIoqRdf9fH
         eCkQ1dSS/i/jDeUHDHVv7CK0slX0Ku2sGxhucryVvibwcuCWlPXKGz6ZlEFZ97LndT
         AJFoOFh1cQuKw==
Date:   Thu, 27 Jul 2023 15:19:19 -0700
Subject: [PATCHSET v26.0 0/2] xfs: add usage counters for scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623967.921701.643201943864960800.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series introduces simple usage and performance counters for the
online fsck subsystem.  The goal here is to enable developers and
sysadmins to look at summary counts of how many objects were checked and
repaired; what the outcomes were; and how much time the kernel has spent
on these operations.  The counter file is exposed in debugfs because
that's easier than cramming it into the device model, and debugfs
doesn't have rules against complex file contents, unlike sysfs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-usage-stats
---
 fs/xfs/Kconfig        |   17 ++
 fs/xfs/Makefile       |    1 
 fs/xfs/scrub/repair.c |   11 +
 fs/xfs/scrub/repair.h |    7 +
 fs/xfs/scrub/scrub.c  |   11 +
 fs/xfs/scrub/stats.c  |  405 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/stats.h  |   59 +++++++
 fs/xfs/xfs_linux.h    |    1 
 fs/xfs/xfs_mount.c    |    9 +
 fs/xfs/xfs_mount.h    |    4 
 fs/xfs/xfs_super.c    |   53 ++++++
 fs/xfs/xfs_super.h    |    2 
 12 files changed, 569 insertions(+), 11 deletions(-)
 create mode 100644 fs/xfs/scrub/stats.c
 create mode 100644 fs/xfs/scrub/stats.h

