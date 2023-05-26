Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56421C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjEZAbT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZAbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:31:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C6718D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D07608CC
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0416EC433EF;
        Fri, 26 May 2023 00:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061077;
        bh=GmeJ6e/78CwFSmEMBpRRsuxcKLzSSnx/f63vrKaL1zI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VVnTw3bpOnVtKSbpIL1GS17qHN3R5fzR8XNl6nybyzw4VlKoqI7UVLANtDXmd5bOL
         5hhuunngPGYLW5aBecx2eY6V2jI58na6LEBZharWr6aOtto8esfwGGnesI+5Cm9DZg
         TxTdUeRADFwWp4xbFySouLwC6MWgsbMgRz3BsORX9lA2P3VYFpTzduQQSR6rY9/9Eo
         dRmIs4sivqpLSdG0yxjMoD4H2v5r6T8D1z/UIDldXCc9rXopEVhTY1thf1t74+q2nl
         EIujNHk9sdLCIrhISQ74TnXSNKi+kQMxeu03BJazM+QmRECQiZ8WYrNWzm8m0UuXaL
         W2tcOk/pJOshQ==
Date:   Thu, 25 May 2023 17:31:16 -0700
Subject: [PATCHSET v25.0 0/7] xfs: online repair of quota counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059833.3731102.13017065640910413459.stgit@frogsfrogsfrogs>
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

This series uses the inode scanner and live update hook functionality
introduced in the last patchset to implement quotacheck on a live
filesystem.  The quotacheck scrubber builds an incore copy of the
dquot resource usage counters and compares it to the live dquots to
report discrepancies.

If the user chooses to repair the quota counters, the repair function
visits each incore dquot to update the counts from the live information.
The live update hooks are key to keeping the incore copy up to date.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quotacheck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quotacheck
---
 fs/xfs/Makefile                  |    2 
 fs/xfs/libxfs/xfs_fs.h           |    4 
 fs/xfs/libxfs/xfs_health.h       |    4 
 fs/xfs/scrub/common.c            |   47 ++
 fs/xfs/scrub/common.h            |   11 
 fs/xfs/scrub/health.c            |    1 
 fs/xfs/scrub/iscan.c             |  244 +++++++++--
 fs/xfs/scrub/iscan.h             |   14 +
 fs/xfs/scrub/quotacheck.c        |  847 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quotacheck.h        |   76 +++
 fs/xfs/scrub/quotacheck_repair.c |  254 +++++++++++
 fs/xfs/scrub/repair.c            |   46 ++
 fs/xfs/scrub/repair.h            |    5 
 fs/xfs/scrub/scrub.c             |    9 
 fs/xfs/scrub/scrub.h             |   10 
 fs/xfs/scrub/trace.h             |   62 +++
 fs/xfs/scrub/xfarray.h           |   19 +
 fs/xfs/xfs_health.c              |    1 
 fs/xfs/xfs_inode.c               |   21 +
 fs/xfs/xfs_inode.h               |    3 
 fs/xfs/xfs_qm.c                  |   23 +
 fs/xfs/xfs_qm.h                  |   16 +
 fs/xfs/xfs_qm_bhv.c              |    1 
 fs/xfs/xfs_quota.h               |   45 ++
 fs/xfs/xfs_trans_dquot.c         |  158 +++++++
 25 files changed, 1857 insertions(+), 66 deletions(-)
 create mode 100644 fs/xfs/scrub/quotacheck.c
 create mode 100644 fs/xfs/scrub/quotacheck.h
 create mode 100644 fs/xfs/scrub/quotacheck_repair.c

