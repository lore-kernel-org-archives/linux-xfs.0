Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D4BC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJBSZF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJBSZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:25:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C268F13EA5
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9F3FB80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B704C433D7;
        Sun,  2 Oct 2022 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735097;
        bh=0e8wlLGfdqUlNRrYNC9nDK9O6qdT2nT04SKGA6nivtA=;
        h=Subject:From:To:Cc:Date:From;
        b=IG2fiYr/CHfu74hvB4So8eo6XqbEbkU9mgjrtxDfdnt691GxbNVVojQZa9SAJAQLX
         rBUc6cBNrLvmGelTGkDN2/bX6yPqdg68NTymaZnwQAqvAIa73sYEdUylD7jZvZLqcX
         huXIcq4J0rh/GOPRS0TMl8O+bTya32LYkF9Atp+EQebYXP0RWfYMoavvoU2r1RgEsM
         Gy1y6I0xTC9X2w3/fvBffCXcODCChFJqmv1Sn+475o+gHPmipY6KEgnA5nGFqwdVny
         b5JJlEFemgTBh8wQkhTvpIMjFXuCT1rggrEgx8K1dIqBw5+xWdJPCLl0426a8Haee9
         vUGGMPSYe42qQ==
Subject: [PATCHSET v23.1 0/3] xfs: rework online fsck incore bitmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:44 -0700
Message-ID: <166473484410.1085359.13141946672747602766.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, we make some changes to the incore bitmap code: First,
we shorten the prefix to 'xbitmap'.  Then, we rework some utility
functions for later use by online repair and clarify how the walk
functions are supposed to be used.

Finally, we use all these new pieces to convert the incore bitmap to use
an interval tree instead of linked lists.  This lifts the limitation
that callers had to be careful not to set a range that was already set;
and gets us ready for the btree rebuilder functions needing to be able
to set bits in a bitmap and generate maximal contiguous extents for the
set ranges.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-bitmap-rework
---
 fs/xfs/scrub/agheader_repair.c |   99 ++++++-----
 fs/xfs/scrub/bitmap.c          |  367 +++++++++++++++++++++++++---------------
 fs/xfs/scrub/bitmap.h          |   33 ++--
 fs/xfs/scrub/repair.c          |  102 ++++++-----
 4 files changed, 357 insertions(+), 244 deletions(-)

