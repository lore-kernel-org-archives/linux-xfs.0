Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383ACC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjEZAcW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjEZAcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B7EEE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00EF964AFD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61305C433D2;
        Fri, 26 May 2023 00:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061139;
        bh=KIvqt49YqJP7m0GgBO4z104zqwozlSskB04jBk3vL7o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qMMBAKBlPoksmeH1cUvQIZBhUuqEoSGlkz434j9eV/zSBXYCt5pbZJfo+yOo0Al8j
         yqe7jvdKXBqVlp+43guyuQAt/mU5X8IVgQh8byReS3z6wXaSFiqIcNNc5BNkK5FW5z
         UeZ71IZck5X054JAGAxaEq2M/LMVyx+/ei/NnKj31TXGhKFmKoHdvNYS+5r/QBEd14
         wDViTfiGSamnWXX7cNEcXIu8Ysih6OcmiCuu+5CRC3cgruV87qfQUdBlSpoAmJX0RW
         +usi4F4fUyB4wvcp13KJKBHNl56+ELdo0zWEzrIp0nB8aRTwxIFZ99qrQATB3zEpEL
         m/qMILTqsvIrw==
Date:   Thu, 25 May 2023 17:32:18 -0700
Subject: [PATCHSET v25.0 0/3] xfs: online repair for fs summary counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs>
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
 fs/super.c                       |  172 +++++++++++++++++++++++++++++++++--
 fs/xfs/Makefile                  |    1 
 fs/xfs/scrub/fscounters.c        |  185 ++++++++++++++++++++++++++++----------
 fs/xfs/scrub/fscounters.h        |   20 ++++
 fs/xfs/scrub/fscounters_repair.c |   72 +++++++++++++++
 fs/xfs/scrub/repair.h            |    2 
 fs/xfs/scrub/scrub.c             |    8 +-
 fs/xfs/scrub/scrub.h             |    1 
 fs/xfs/scrub/trace.c             |    1 
 fs/xfs/scrub/trace.h             |   22 ++++-
 include/linux/fs.h               |    8 +-
 11 files changed, 428 insertions(+), 64 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.h
 create mode 100644 fs/xfs/scrub/fscounters_repair.c

