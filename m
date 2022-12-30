Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1CFC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiL3XDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:03:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA83915FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:03:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7774561C30
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8ABC433EF;
        Fri, 30 Dec 2022 23:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441429;
        bh=QCAIP1SjFKBef+j7vFX7LNeNNWwqDwGRgG89yb8maFw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AaBsQvjFaHhIdVpQVyLd+UJ46XsBKxEP4VWlxoCGA1cf1ITXR1wJLXzHtf8lpyG2r
         ehp3lHr9mxXXZvcHEJaDKSnz1aEyc940nI/oXUJUHfvFGIOIdhL1qxszEWSA8v3UtM
         3vkzkl0Td2Q3XjzshtVnDarJKPdv5AKxfRuRBQUDnyMH3V+DcA/Nwv7yQJym/hMy2q
         /4JeCGLO380gwO0VTuv3qlKancabGI9G0SQ9h7YCjSXBC/siynDSMnxlApNtQknkr7
         1/Adq/gZ8hiWehgpHyU+fNWNpzoIZgy3qIAG50Fu2rVv4DOKMMKUOZIcW8agAlNdUY
         +axRbOHqB7rjg==
Subject: [PATCHSET v24.0 0/3] xfs: online repair for fs summary counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:22 -0800
Message-ID: <167243840246.696415.12006477739455537131.stgit@magnolia>
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

A longstanding deficiency in the online fs summary counter scrubbing
code is that it hasn't any means to quiesce the incore percpu counters
while it's running.  There is no way to coordinate with other threads
are reserving or freeing free space simultaneously, which leads to false
error reports.  Right now, if the discrepancy is large, we just sort of
shrug and bail out with an incomplete flag, but this is lame.

For repair activity, we actually /do/ need to stabilize the counters to
get an accurate reading and install it in the percpu counter.  To
improve the former and enable the latter, allow the fscounters online
fsck code to perform an exclusive mini-freeze on the filesystem.  The
exclusivity prevents userspace from thawing while we're running, and the
mini-freeze means that we don't wait for the log to quiesce, which will
make both speedier.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fscounters

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-fscounters
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/scrub/common.c            |   26 ----
 fs/xfs/scrub/common.h            |    2 
 fs/xfs/scrub/fscounters.c        |  264 +++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/fscounters.h        |   20 +++
 fs/xfs/scrub/fscounters_repair.c |   72 ++++++++++
 fs/xfs/scrub/repair.h            |    2 
 fs/xfs/scrub/scrub.c             |   10 +
 fs/xfs/scrub/scrub.h             |    2 
 fs/xfs/scrub/trace.c             |    1 
 fs/xfs/scrub/trace.h             |   23 +++
 11 files changed, 339 insertions(+), 84 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.h
 create mode 100644 fs/xfs/scrub/fscounters_repair.c

