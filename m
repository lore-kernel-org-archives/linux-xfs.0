Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC8EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiL3W2D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiL3W2C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:28:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6711D0CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF42461C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A95BC433D2;
        Fri, 30 Dec 2022 22:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439280;
        bh=y8ecrpy9lFpD+juX+joHm83N2i1aJL1A1V5UeiOjwqY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dldvTiatHlv3n1mF9QRtK5vgZ3ZsWqbjzqE7SQTKFQRiugPllz9n3FaSdwsQavK6c
         wYO53MlSszSk3NSFWsXL830T0j33DIuRgO4sEoJyMjCZy7hZY4UccubrythyUCrPnv
         qzUsQYYpqGpjUp5YRKwFToCotrySfo/XEej6CQv/YG/KiIT+T7KtSqmzaPl3RlVGvS
         VNp2+eLXxFhppJ1aBnmKuBeaB806Tm4GJhapbqE31OkXbZk5gyxOUOMuKOmOcpAe1K
         9XpRVp1sMTjyQ0hsXlITi+dJNh+Z/wUhgfSSXAZmf+Q6cxFaf3K4ggWO6W0FuUfxYi
         VYPm8xrdc01Yw==
Subject: [PATCHSET v24.0 0/3] xfs: rework online fsck incore bitmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:50 -0800
Message-ID: <167243831043.687325.2964308291999582962.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
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
 fs/xfs/scrub/repair.c          |  104 ++++++-----
 4 files changed, 358 insertions(+), 245 deletions(-)

