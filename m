Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC087C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjEZAjH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbjEZAjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58105198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEDA061B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF1AC433EF;
        Fri, 26 May 2023 00:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061545;
        bh=CmlmbZDqmqgcz/Z+7ZbCdfEUPLzMWEnJQzYk58Yc+Ts=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Hmfcv1ebJpRQ5pvVYUdmUO5ec5VtoObFakR1tih1UbnenXaolsbzetXyNPXFMrfNz
         rcpgF2LNaUr4eb7vW1nGj70I04uZDjleqQAv7sjwKfIvWYsLsKfsIXuQLBs+NO1Vnt
         KvdNzpm0Ir6mIXMDk60PSM5oBLuxWAmz9a8blr3IX/i/SXtPvNHZShEzVEswmaVHn8
         aC1wtPgGZkppaLJ0G+9p6KivPo1xFr8CFk2V3S9k00Q2weLjodNkikbsg6tT1OeW7p
         rSrJgP+6dkBAWJRKmLMUgjIZcALkr2nOZNVnv3XfIzALKSaeTeP6AYQaZLBCMqW17g
         c9tfQ9/LXrWHw==
Date:   Thu, 25 May 2023 17:39:04 -0700
Subject: [PATCHSET v25.0 0/4] xfs_scrub: improve scheduling of repair items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072752.3744428.6237393655315422413.stgit@frogsfrogsfrogs>
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

Currently, phase 4 of xfs_scrub uses per-AG repair item lists to
schedule repair work across a thread pool.  This scheme is suboptimal
when most of the repairs involve a single AG because all the work gets
dumped on a single pool thread.

Instead, we should create a thread pool with the same number of workers
as CPUs, and dispatch individual repair tickets as separate work items
to maximize parallelization.

However, we also need to ensure that repairs to space metadata and file
metadata are kept in separate queues because file repairs generally
depend on correctness of space metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-scheduling
---
 include/list.h        |   14 +++
 libfrog/ptvar.c       |    9 ++
 libfrog/ptvar.h       |    4 +
 scrub/counter.c       |    2 
 scrub/descr.c         |    2 
 scrub/phase1.c        |   15 ++-
 scrub/phase2.c        |   23 ++++-
 scrub/phase3.c        |  106 ++++++++++++++--------
 scrub/phase4.c        |  240 ++++++++++++++++++++++++++++++++++++-------------
 scrub/phase7.c        |    2 
 scrub/read_verify.c   |    2 
 scrub/repair.c        |  172 +++++++++++++++++++++++------------
 scrub/repair.h        |   37 ++++++--
 scrub/scrub.c         |    5 +
 scrub/scrub.h         |   10 ++
 scrub/scrub_private.h |    2 
 scrub/xfs_scrub.h     |    3 -
 17 files changed, 465 insertions(+), 183 deletions(-)

