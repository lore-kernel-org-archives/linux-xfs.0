Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED05C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbjFEPhc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbjFEPhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668CF187
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 020A762171
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588A0C433EF;
        Mon,  5 Jun 2023 15:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979439;
        bh=fuXQTD/O6fPfsPLuubi3/tnTfhYJ6fq/FHR7YCyp5MM=;
        h=Subject:From:To:Cc:Date:From;
        b=TiX1HVYRkYc99eJanGLMgySMlUT6bsMMuB8h9k4fnvRL9K4veMY8iR1wuaG9bC4ch
         kCVr5O9FPq04Vw87ze+Gt3HRyHlsjh+CdV7SRL0qhKmdPH0j4qyzgQ1ZDibcZdL5Mv
         RXB1i2JSsaafc/UrzJNPqYJIkzE6s6Q9SSvgoHjZD8EvoktmrrU8nbKRt8T49CMMsJ
         7IiV09NuQ68k9Pfc1pidzicEWGSauf2J2VeGcVw5kZXVuC+1Cq5QEIofq7U9ZLp9c4
         rNTHyp2KDxKDZTnsp5N7UFlDtIs6Ydzfm0hU4qkLxVO15//PIruDNC33+qeKX2ZmL3
         VnmlIVIaBIuWw==
Subject: [PATCHSET 0/2] xfs_repair: fix missing corruption detection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:18 -0700
Message-ID: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As part of QAing the parent pointers patchset, I noticed a couple of bad
bugs in xfs_repair.  The first is our handling of directories containing
the same name more than once -- we flag that and store both names, but
then we rebuild the directory with both of the offending names!  So, fix
that.

The other problem I noticed is that if the inobt is broken, many inodes
end up in the uncertain list.  Those files will get added back to the
filesystem indexes without the attr forks being checked, which means
that any corruption in them will not be found or fixed.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fix-da-breakage
---
 repair/dino_chunks.c |    6 ++++--
 repair/phase6.c      |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

