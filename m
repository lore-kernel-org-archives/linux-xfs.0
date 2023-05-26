Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAA4C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEZAkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZAkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:40:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C5A194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E1A64BE8
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FB9C433D2;
        Fri, 26 May 2023 00:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061639;
        bh=RUu3zPbvX7r0rTQylVa9aDsjlDx7c1sYNqfr0pbIbBw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UZr27+uMcMn+FyJOghCjwpCsYiWwAwb2cU4l+BZJ23FUm5xMv54NrIAYe8aVhx/hs
         qSBWdm8/MNyIcBWBAT1A/I9Y2mwto7BXG92i3z+1O++IuleepSC3i4iPiZM8IT/nsC
         fs91G3l6NzVQmXgvd+urLtOehbGXArUVUKvmThlGuKnhDR0T+65418bZXDX9dfPkIV
         gODIELN/lHnQEJQBc5+3Jg0XphNgmEnAu489Krq8bnfLSh6mkYp6paz9hRwmkqhoxF
         oExaX08GHAYWwKwcR7++WFE4+Wwr3FckwZobQdkuZMTh1ljX6i9sNKQQ3QTBAQwj91
         lX/EBh1BasISQ==
Date:   Thu, 25 May 2023 17:40:38 -0700
Subject: [PATCHSET v25.0 0/6] xfs_scrub_all: automatic media scan service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074851.3746274.9049178062160647823.stgit@frogsfrogsfrogs>
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

Now that we've completed the online fsck functionality, there are a few
things that could be improved in the automatic service.  Specifically,
we would like to perform a more intensive metadata + media scan once per
month, to give the user confidence that the filesystem isn't losing data
silently.  To accomplish this, enhance xfs_scrub_all to be able to
trigger media scans.  Next, add a duplicate set of system services that
start the media scans automatically.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-scan-service
---
 debian/rules                           |    3 +
 include/builddefs.in                   |    3 +
 man/man8/Makefile                      |    7 ++
 man/man8/xfs_scrub_all.8.in            |   20 +++++
 scrub/Makefile                         |   21 +++++-
 scrub/xfs_scrub@.service.in            |    2 -
 scrub/xfs_scrub_all.cron.in            |    2 -
 scrub/xfs_scrub_all.in                 |  122 ++++++++++++++++++++++++++------
 scrub/xfs_scrub_all.service.in         |    9 ++
 scrub/xfs_scrub_all_fail.service.in    |   72 +++++++++++++++++++
 scrub/xfs_scrub_fail.in                |   46 +++++++++---
 scrub/xfs_scrub_fail@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in      |   95 +++++++++++++++++++++++++
 scrub/xfs_scrub_media_fail@.service.in |   76 ++++++++++++++++++++
 14 files changed, 435 insertions(+), 45 deletions(-)
 rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (59%)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in

