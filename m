Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67832C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiL3XPJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiL3XPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:15:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3561D0E9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BB5EB81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F3CC433D2;
        Fri, 30 Dec 2022 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442105;
        bh=bdzm/RbWCcwkIZzuCi3kh2A/e6j+trs1ngahsV7fWls=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lvK0Pcb0Cvug9WU2xn6anjOXfFtmaPx5bVM+TgMwYnVV4JYUTne4uH72s+0kno4k6
         uFNgmLmJO7DpiwbkL/PeddS7NzJR+afMQZvpURS90EUhyPSh1fTs45qk22ARWUZsRi
         cF/JkOFdu1xCNNzW4BMi2vpchiIzz9aRWCwGyjjvPrssfZ1NDbeTY85aDCKOPMUn/g
         pEizUrKqtRqKD/BnG4efv5Zduhev/2ofLnX1DdkCB6YftkTRAiWaKPNr1l4g9VnLxT
         UMxPaRFqXYMVhQlS3HsZBNBdl3Q5mX5C6r7S3EPsYqqAWyP7O/8SZgthB2up5LCalE
         jqf1LgtUn/7lA==
Subject: [PATCHSET v24.0 0/4] xfs_scrub_all: automatic media scan service
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:37 -0800
Message-ID: <167243871794.718563.17643569431631339696.stgit@magnolia>
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
 man/man8/xfs_scrub_all.8.in            |   20 ++++++
 scrub/Makefile                         |   14 ++++-
 scrub/xfs_scrub_all.cron.in            |    2 -
 scrub/xfs_scrub_all.in                 |   99 +++++++++++++++++++++++++++++++-
 scrub/xfs_scrub_all.service.in         |    9 ++-
 scrub/xfs_scrub_all_fail.service.in    |   67 ++++++++++++++++++++++
 scrub/xfs_scrub_fail                   |   44 +++++++++++---
 scrub/xfs_scrub_fail@.service.in       |    2 -
 scrub/xfs_scrub_media@.service.in      |   90 +++++++++++++++++++++++++++++
 scrub/xfs_scrub_media_fail@.service.in |   76 +++++++++++++++++++++++++
 13 files changed, 413 insertions(+), 23 deletions(-)
 rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (59%)
 create mode 100644 scrub/xfs_scrub_all_fail.service.in
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in

