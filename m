Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B41C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiL3XOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiL3XOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:14:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B5B1D0C0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B9FE61C32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A094C433EF;
        Fri, 30 Dec 2022 23:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442089;
        bh=awN7eRYej3A3RonOfSy8/rZeL8tfeJLEEzL7nH/LNnE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KYtQcsOMpAk+WUclMW/46i0my3sCeph0ZEkhvzZ1VTwvjMaDxsp+P+ithsA12HwT8
         iGhkRepq/i2CWR2ukgaaUyfWepXK0e43KkwJ+3r4lGwSIaubRaAim7WEiMV4MYAJzU
         OarQ6zhqYQefhcClEXmHkIl4MH9a8CbTyNPsp7iZp6uGhgju8XPkDp86D2lW5axXu1
         P+2J12SAdmv7ZQVtCxU08LbphbvNcmDZi+Slu03FtakUU7c+UqSsZaen2cve8ugc7y
         e1Z0EY0UV7+S4glpSNEdkPv4eBQKduG1IU/cm0ndW9khsHUflTEJVxjxPyYZCHfKl9
         4cS4Yu25igO4A==
Subject: [PATCHSET v24.0 0/5] xfs_scrub: tighten security of systemd services
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871464.718298.4729609315819255063.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

To reduce the risk of the online fsck service suffering some sort of
catastrophic breach that results in attackers reconfiguring the running
system, I embarked on a security audit of the systemd service files.
The result should be that all elements of the background service
(individual scrub jobs, the scrub_all initiator, and the failure
reporting) run with as few privileges and within as strong of a sandbox
as possible.

Granted, this does nothing about the potential for the /kernel/ screwing
up, but at least we could prevent obvious container escapes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-security
---
 doc/README-env-vars.txt          |    2 +
 scrub/Makefile                   |    7 +++
 scrub/phase1.c                   |    4 +-
 scrub/system-xfs_scrub.slice     |   30 +++++++++++++
 scrub/vfs.c                      |    2 -
 scrub/xfs_scrub.c                |    9 +++-
 scrub/xfs_scrub.h                |    5 ++
 scrub/xfs_scrub@.service.in      |   85 ++++++++++++++++++++++++++++++++++----
 scrub/xfs_scrub_all.service.in   |   66 ++++++++++++++++++++++++++++++
 scrub/xfs_scrub_fail@.service.in |   60 +++++++++++++++++++++++++++
 10 files changed, 253 insertions(+), 17 deletions(-)
 create mode 100644 scrub/system-xfs_scrub.slice

