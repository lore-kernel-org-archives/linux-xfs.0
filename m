Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0225FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381632AbiEEQI0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381640AbiEEQIY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECD85C374
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26B4C61DDC
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79995C385A4;
        Thu,  5 May 2022 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766683;
        bh=mLjTybn0IwoQ6LeZtP6OmXWJrwqqhgCmDQAhtqczREs=;
        h=Subject:From:To:Cc:Date:From;
        b=aPSS4Qu2vUD0spJ4FQhBTiYkzYhdjp4Y2eF/++2O/5cWvPTf2ThlpupstqZuPodbb
         nriGgSWnART46uTqJ84AWP/uOhWbI1a6SS01YjNsfEulYHR6Msr+9hNGlTvOxC6n6t
         Fbd0l+jyHrDIiaKuD79UvNqzlAnNtHaOwJ5GAhzMxe0GmRAMpHXnd0wrDnVucjyCtv
         StCcYeb6xUCz2lFdsSyhYphsvlWR3G+9boaLqeI9uF9OTOl2IDITx0UBUgQE75LGmI
         c8LknRyNzhBdBujqG844Mdwuc3da/UznWEaCfFzj9KaXA2jhpQT1aGgEgdXkkI53L1
         PR8OHHV8JuFsA==
Subject: [PATCHSET 0/4] xfs_repair: check rt bitmap and summary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:43 -0700
Message-ID: <165176668306.247207.13169734586973190904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I was evaluating the effectiveness of xfs_repair vs. xfs_scrub with
realtime filesystems the other day, and noticed that repair doesn't
check the free rt extent count, the contents of the rt bitmap, or the
contents of the rt summary.  It'll rebuild them with whatever
observations it makes, but it doesn't actually complain about problems.
That's a bit untidy, so let's have it do that.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-check-rt-metadata
---
 repair/incore.c     |    2 
 repair/phase5.c     |   15 ++++
 repair/rt.c         |  214 ++++++++++++++++++---------------------------------
 repair/rt.h         |   18 +---
 repair/xfs_repair.c |    6 -
 5 files changed, 97 insertions(+), 158 deletions(-)

