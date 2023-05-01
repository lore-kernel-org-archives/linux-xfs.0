Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C1AC77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 18:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjEAS04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 14:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjEAS0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:26:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F9BDF
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CE0D61E7D
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 18:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BE9C433D2;
        Mon,  1 May 2023 18:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965613;
        bh=tCeTWDZyJsiusqyPxB3bW3r0CYDh6dOg+nsonJ3y7Ms=;
        h=Subject:From:To:Cc:Date:From;
        b=CrxLpGBA2DionbCMqqHI38xBlnrLkU93+CfSFVni/boNSCDL0i/GQWS4wyK4t0pTz
         M5jf9+T23Wd6L9PPgCupuObxOTxho+T/UYNsV0g9YIUrCCvkOdyu1Z5jvn/vHpO8ti
         MdLZDQcvHb+3JeMGVcabrkmtKe15WydcYHx+epQDBxrPeCdO28jzNXJwfbZU9dH9bH
         j1IXxmmEMtVEewH8F/o/ZxwFKwgDxV1a4eBDKJnqOr+FauTqzK4xK7Ki7xOd+3pvY7
         YvtzmH8Dla31crv6duhFQBVYeIhKyLnh/e7OPPGdTbh5uMezrEPaFkosfwLfrzbmJ3
         z6rAiocf8xFhw==
Subject: [PATCHSET v2 0/4] xfs: bug fixes for 6.4-rc1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 01 May 2023 11:26:53 -0700
Message-ID: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are some assorted bug fixes for 6.4:

 * A regression fix for the allocator refactoring that we did in 6.3.
 * Fix a bug that occurs when formatting an internal log with a stripe
   alignment such that there's free space before the start of the log
   but not after.
 * Make scrub actually take the MMAPLOCK (to lock out page faults) when
   scrubbing the COW fork
 * If we call FUNSHARE on a hole in the data fork, don't create a
   delalloc reservation in the cow fork for that hole.

v2: fix some comments that fell out of sync with the code

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=kernel-fixes-6.4
---
 fs/xfs/libxfs/xfs_ag.c   |   19 +++++++++----------
 fs/xfs/libxfs/xfs_bmap.c |    5 +++--
 fs/xfs/scrub/bmap.c      |    4 ++--
 fs/xfs/xfs_iomap.c       |    5 +++--
 4 files changed, 17 insertions(+), 16 deletions(-)

