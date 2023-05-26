Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDA6C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjEZAiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjEZAiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:38:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87CEEE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C84761705
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DADC433D2;
        Fri, 26 May 2023 00:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061529;
        bh=n3E27CvzH8V8pQ8AUVyaX6Z5mL0g50pTiKRHSe+U2Lk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=TmK3MaR3ngGqJ0eOwmTtRbr+2tYdNBNZSeN3hvbH/OaoKEhOvG27sH2ISim8UkMu7
         thDzVD1hz/9LjsWzbv3G2zqFTUj2ThfJLqunGtdStG127uquJidJBfbctHufj9YT49
         M+86ljN5rE+QIuPtbeip/vqC5KbSt49zLauMxBRuumRIkdzF9k/M70L23acFKzf+Fn
         COD58RCg4vAbwTtXttYfC/TMaHb0/oOv+BvYadI3kb/bDWh6KxYmsySiN3pP8S9i46
         aCTsZHzGb8DvCOg139svjTME31Ssh8MNmuMGcNbHV61jmb9QL+KOcbmMesCbaZv0xu
         MSyUwUe/3CK1Q==
Date:   Thu, 25 May 2023 17:38:49 -0700
Subject: [PATCHSET v25.0 0/5] xfs_scrub: use scrub_item to track check
 progress
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072412.3744014.10740186421005934865.stgit@frogsfrogsfrogs>
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

Now that we've introduced tickets to track the status of repairs to a
specific principal XFS object (fs, ag, file), use them to track the
scrub state of those same objects.  Ultimately, we want to make it easy
to introduce vectorized repair, where we send a batch of repair requests
to the kernel instead of making millions of ioctl calls.  For now,
however, we'll settle for easier bookkeepping.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-object-tracking
---
 scrub/phase1.c        |    3 
 scrub/phase2.c        |   12 +-
 scrub/phase3.c        |   39 ++----
 scrub/phase4.c        |   16 +-
 scrub/phase5.c        |    5 -
 scrub/phase7.c        |    5 +
 scrub/repair.c        |   71 +++++------
 scrub/scrub.c         |  321 ++++++++++++++++++++++---------------------------
 scrub/scrub.h         |   40 ++++--
 scrub/scrub_private.h |   14 ++
 10 files changed, 258 insertions(+), 268 deletions(-)

