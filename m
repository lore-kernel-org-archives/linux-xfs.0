Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E47C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbjEZAd6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbjEZAd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:33:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2F019D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA7B64B87
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A50DC433EF;
        Fri, 26 May 2023 00:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061233;
        bh=wxHzXouCI7f4OwJ/SQAEOfu3QVArUaYmCae0+WjATBs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WxtgrNADQkZleIjJAm2HgFh322ZmHSjlbknz0DKRuSnquoOnu2iKE2JbewwWNCqMI
         N/iYyp/U32aV8yVaWuaT1bigBBj76yd/1ajDDnuAcFa//hAFRjkPVZzi3iut9lrk+/
         1+BpLVj5bGZZDhX+5sj+UNl+6I+YJZZ6NMj6sjO6VBPIzKdHuUkfZXsalSCgELUOBp
         ZOenzyabHKB42RPUI2eK6mx72XZD8IItoBeR4o+XXz6Q/wDcEVtN+JubjjTSupeBhY
         0xm1iFKDoTbKpPythfBW4sDu2LQG4ndkevtzmxeiHDAzfCHxODhP71onMcunct/dPq
         O36Acx7cMW19g==
Date:   Thu, 25 May 2023 17:33:52 -0700
Subject: [PATCHSET v25.0 0/4] xfs: widen BUI formats to support realtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
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

Atomic extent swapping (and later, reverse mapping and reflink) on the
realtime device needs to be able to defer file mapping and extent
freeing work in much the same manner as is required on the data volume.
Make the BUI log items operate on rt extents in preparation for atomic
swapping and realtime rmap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-bmap-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-bmap-intents
---
 fs/xfs/libxfs/xfs_bmap.c       |   24 +++++-------------------
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.c         |   17 +++++++++++++++++
 fs/xfs/xfs_rtalloc.h           |    5 +++++
 fs/xfs/xfs_trace.h             |   23 ++++++++++++++++++-----
 6 files changed, 81 insertions(+), 25 deletions(-)

