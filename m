Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D68C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbiL3XNT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiL3XNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:13:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005A7DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:13:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAE18B81DAC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64500C433D2;
        Fri, 30 Dec 2022 23:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441995;
        bh=ggnfSBGZ3Aw+cq1wQy/KcwhmokCy/qZC0YLl9iwWieE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XfE2wrPcDBzNnnNTy/OHUjv10CrbjkKYwZHJNjxGe0lY+GNpwXhgDaVyM6mioWIOz
         BasUYvocaxLP2opQoDXk6ZdJkVmuAazk1GHuxkuffyg+99MvsHW3SOv/lVdf/VRuJK
         xvLOh4gN/xauMiF3/lqrVVVnr9kRNpjK2bL7Os1qplY2IkRrovAUsLibB9gXCHBIAw
         OYSIrrfkAeqlCZvrRuVZyI+puXiXqCZsX6rzd9Urfa5uvSb5wF9HNfv9f2peeimgQ2
         +9TkBp300gMPfIWp49s8rmbWyg0ytJr8mGnG/Fvgd35y0XswChT9IdnPLKHK2V8vLs
         OKKsNg3Q8DJNw==
Subject: [PATCHSET v24.0 0/6] xfs_scrub: improve warnings about difficult
 repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:13 -0800
Message-ID: <167243869365.715119.17881025524336922669.stgit@magnolia>
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

