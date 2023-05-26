Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C9CC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEZAkZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZAkZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44898195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5433616EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E00CC4339B;
        Fri, 26 May 2023 00:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061623;
        bh=LB479GqyeJfBnDPf1jCAuoiFKTTam8TrfqAPKJJ8YjI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SBSBcZgPYam9bOmgfou7McsrETj09WlvLvaYS9V49nGLfI2Q7JeY7ddjTHhWA1sKF
         zWVwdrsI7RN6o337Pc4SoXakpiONK2skAqej5ScLCt/XBPG6ziH8gaHOC2PPRkFJY6
         rOs7uRI1Of1j1OGy8DSUjw+DnLFZ63jDRxxdpLYADYFdfpvsR8eFGIbcwrCQKdD+lZ
         sMLCViTQLU0qWOkc0uVkeOsDjNYmdpXbKuHIoRCSyHX0BygY1Yh2DgsJ2wN2SWKpg4
         xEizBd4Uirz6lwkZGK0JsvFiEq++4OWzGPNH3t46AE1dI/lMBzYrwLnw39jaBuT72d
         XtsT4rygOYARA==
Date:   Thu, 25 May 2023 17:40:22 -0700
Subject: [PATCHSET v25.0 0/5] xfs_scrub: tighten security of systemd services
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
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
 scrub/xfs_scrub@.service.in      |   90 ++++++++++++++++++++++++++++++++++----
 scrub/xfs_scrub_all.service.in   |   66 ++++++++++++++++++++++++++++
 scrub/xfs_scrub_fail@.service.in |   60 +++++++++++++++++++++++++
 10 files changed, 258 insertions(+), 17 deletions(-)
 create mode 100644 scrub/system-xfs_scrub.slice

