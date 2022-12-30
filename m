Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B32C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiL3XOF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiL3XOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:14:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60076DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:14:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 001EA61C32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7D4C433D2;
        Fri, 30 Dec 2022 23:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442042;
        bh=CmlmbZDqmqgcz/Z+7ZbCdfEUPLzMWEnJQzYk58Yc+Ts=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vq/jkO3AyZWMbmAAJEaJ4duNuGS6yh7XfSL7MYUWdz44r1SF+frWt9/0RKK8LyAPY
         woUoRSOF6wh68ZHwyEPkMfTYRkQQ1MaBGHkg1C5R14m9aZ1h9ytj7G//tecims+6cy
         a+SOxy8LP/32Z0/Hk6yQr7OG55IBctdhr633ev8/4lGgZ8WEl39jVWHBZAo287K+pt
         ygelk5cuCQ+Shuy2nh38E0PCyxrUL/hr4WANyf2K8V+1BHYDIwCfyPohEYE8ljMK3P
         GqTC9zwUt6EoLE0jo13fp6iRziNou+d13oXIlpw+5b9051t8gHWJV2VyEhvV7PEY/P
         DTrFZNQrMK7dw==
Subject: [PATCHSET v24.0 0/4] xfs_scrub: improve scheduling of repair items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870430.716640.15368107413813691968.stgit@magnolia>
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

