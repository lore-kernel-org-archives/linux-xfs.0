Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AA6C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjFEPhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjFEPhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F379EA
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A014461539
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C9EC433D2;
        Mon,  5 Jun 2023 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979454;
        bh=8ZvmVa3riron01S1N/B0sAFXpJkza74pidEkO0CVZm4=;
        h=Subject:From:To:Cc:Date:From;
        b=mwcQ46+Wn8ob98ewfiK+X220TXSFPVkF34HlR0Njvxzw8XMFb9/iTSM0EwuVbtgya
         n31p2aiVX6IFv3u7rQIrDDpWkyJyTT/+zKGb8lEnJj9Z66CXIg4mTmOayFSphPWT0i
         V/ltMCe/hCe+9GfW2bBh9TnKmvfEs/wP0ObmyzyHTKz3abwqaVM6ApH7Ep/1VSGN9q
         3nr3n4DEHr/bRcVPmMqUoXAikj/ZBQ/xwtNbh+SAPEbLjAp3LEV0UgxMsYt7TshIkw
         twjrFxPtT3aTzUsA2va2ILZpW5YZHqre4BsxUlwxA17EXqQW5p0/uM+pRAmDOE6ryD
         zIy7/d2fVg7aQ==
Subject: [PATCHSET 0/5] xfs_repair: fix corruption messaging with verbose mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:33 -0700
Message-ID: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While I was running xfs/155 and fuzz testing of the parent pointers
patchset, I noticed that there were quite a few places in xfs_repair
where adding the -v flag caused repair either not to say that it was
correcting something, or that it would spit out the wrong action message
entirely.  This series resolves all of those problems.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fix-corruption-messaging
---
 repair/dino_chunks.c |    8 +++-----
 repair/phase6.c      |   43 ++++++++++++++++++-------------------------
 2 files changed, 21 insertions(+), 30 deletions(-)

