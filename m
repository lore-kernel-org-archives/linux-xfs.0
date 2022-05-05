Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A3BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381635AbiEEQJ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381637AbiEEQJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:09:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FDA5B3E1
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:05:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E278B61D05
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E005C385A8;
        Thu,  5 May 2022 16:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766746;
        bh=X4SQqjhptxgkkKRRobnyS/10u1Km2gdteQwkshiFwpM=;
        h=Subject:From:To:Cc:Date:From;
        b=d2/pYOvACWgllGQlvsKGM76biIJMfw361KVtItevOFU4a47K2om+mnqE9hV0CvfsZ
         e/LW+/hXbevgchtEilhIunHDTW65QtzRUgwgkSw8y0gPQUDGfCwdFcDI4NJ/jHTdP1
         vQShbBPkiLg1leyq92s+mOIrizdH5I5emawOcTyVx+8jyp8e5SJyyEv+cbbyVUAWO2
         hTIugVgQyBHvXPXdAusCvGvrwWfsKb8+9yGMBa2J1ZvR/vfKuHZS2h9m0+NCEAzGMg
         5mZihp6aaCSbeIAQB/nBG1t0NzYJ2KNff2DwQFKPUBXi64wKMOs+G2BJ7gwR8aGMpv
         PcnfLz/2hH69A==
Subject: [PATCHSET 0/3] xfs_repair: various small fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:05:45 -0700
Message-ID: <165176674590.248791.17672675617466150793.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Bug fixes for 5.16 include:

 - checking V5 feature bits in secondary superblocks against whatever we
   decide is the primary
 - consistently warning if repair can't check existing rmap and refcount
   btrees
 - checking the ftype of dot and dotdot entries

Enjoy!

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes
---
 repair/agheader.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/phase4.c   |   20 +++---------
 repair/phase6.c   |   79 +++++++++++++++++++++++++++++++++---------------
 repair/rmap.c     |   65 +++++++++++++++++++++++++++------------
 repair/rmap.h     |    4 +-
 5 files changed, 194 insertions(+), 62 deletions(-)

