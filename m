Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A89C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiJBSXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJBSXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:23:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B8F25295
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FF18B80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC586C433C1;
        Sun,  2 Oct 2022 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735030;
        bh=XlN0yFpnVUtGcbQBBBcOA9meUIixzVJsa0iSiIUp4Fs=;
        h=Subject:From:To:Cc:Date:From;
        b=Im0Xd1SL+XgpvQlQmKvR8+t1a//XLgSJUIzaEObSPm9luD7x5vWzcX1n061Rfmym8
         gycPavDXYvP5HYjsVpmgt+kIc6uV3vdHJcI9rgtI5VbZo4BCxyjGn7y5CzUXyO2VdG
         6NxGIlFw6wHO0SJDQkze5+0oDzVKeaV9O8ICwktRdmW/x2L7iUF3o4kBm7rrvFicz2
         EFVScwe5QC5RadpnMv538CPI4ZMfBCVzuFgFSMJIxOw1qhxyC5ZnQAzVtij/KiaK5/
         l0w+hWMxLjUfrQ9PDe3hPddnDPp8iv+PbHT4Jx1Y4UIERauC6YICP8QzvWia1GVkpp
         r70y7wKLXsDYg==
Subject: [PATCHSET v23.1 0/2] xfs: improve rt metadata use for scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:02 -0700
Message-ID: <166473480232.1083697.18352887736798889545.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This short series makes some small changes to the way we handle the
realtime metadata inodes.  First, we now make sure that the bitmap and
summary file forks are always loaded at mount time so that every
scrubber won't have to call xfs_iread_extents.  This won't be easy if
we're, say, cross-referencing realtime space allocations.  The second
change makes the ILOCK annotations more consistent with the rest of XFS.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fix-rtmeta-ilocking
---
 fs/xfs/xfs_fsmap.c   |    4 ++-
 fs/xfs/xfs_rtalloc.c |   60 +++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 8 deletions(-)

