Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF97C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjEZAiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjEZAiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:38:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B64EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF3B961705
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C946C433EF;
        Fri, 26 May 2023 00:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061498;
        bh=ggnfSBGZ3Aw+cq1wQy/KcwhmokCy/qZC0YLl9iwWieE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bIFp5ZngXSd4TvNZvsQySVZtwiJH5Ie2tzX4W6HJd3goJiFvzqpxWZ7RDnqqz//fX
         8rf2/vzvHjO11m65/ymjIWBhxGNTM+fIGMSWgd+0jWENmSGCnXUfcdKdLlQ8OQb7oj
         clqN/k3nXHlGUgikxRfTzPDNuQ2XqGqfPVrpYBVhZM679oIuNP1HzArPegw9chxL9C
         3Ws26uI7ZQfRWfV+SvTzMhBredAS6z4JRMtRdLtwaHYP4MOQMz7NZAzc1Xz6tDjl/I
         Evwqtsc8UIuRQzhSpsGMF5GeH8mIzNtmTo6JGinYcVBfIzc6UAZtG+f9eFtVxwKXc6
         ZZuGE5Rb9D+gg==
Date:   Thu, 25 May 2023 17:38:17 -0700
Subject: [PATCHSET v25.0 0/6] xfs_scrub: improve warnings about difficult
 repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
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

While I was poking through the QA results for xfs_scrub, I noticed that
it doesn't warn the user when the primary and secondary realtime
metadata are so out of whack that the chances of a successful repair are
not so high.  I decided that it was worth refactoring the scrub code a
bit so that we could warn the user about these types of things, and
ended up refactoring unnecessary helpers out of existence and fixing
other reporting gaps.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-better-repair-warnings
---
 scrub/phase1.c |    2 +-
 scrub/phase2.c |   53 +++++++++++++++++++++++++++++++++--------------------
 scrub/phase4.c |    9 +++++----
 scrub/phase5.c |   14 ++++++--------
 scrub/repair.c |   47 ++++++++++++++++++++++++++++++++++++-----------
 scrub/repair.h |   10 +++++++---
 scrub/scrub.c  |   52 +---------------------------------------------------
 scrub/scrub.h  |    7 ++-----
 8 files changed, 91 insertions(+), 103 deletions(-)

