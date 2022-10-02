Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AE8C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJBSXm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiJBSXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A0625295
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3376D60EFE
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAF2C433D6;
        Sun,  2 Oct 2022 18:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735019;
        bh=zA4eHCtrpwDZg8wAjV71nqWhDR5MI23rDLPLbzXqmXs=;
        h=Subject:From:To:Cc:Date:From;
        b=l0vLpmZsOjs2f9P58a16agS7K9fwMskqmcXXdsWMzP0dlCc382RSXMcl/2PhDJxTK
         fl22TFIZjYgTujPw59Vz2fO024hu1QgROM+ZpeRIJSI68hIIP3/KEKxj71+CD8Lgjr
         xHM1nVLC/CY05dSalScE8jZ2EHSSfcISJBAOl68s2vnRxQR80mk93QHpALW/SfNXmd
         6Lse3CyLyzPH1hZhg4KeT7LM+wEIJHWLigxwXkUM1HONxTw6MDtFv6fRmyqX3VcsFj
         bmB0z5wPITE1npW1HwXvgwMhHP883Yo3vwhV8mDOwudTlbOIPltOxMDQCI4jfrq1bn
         igXMe+g7SgnlA==
Subject: [PATCHSET v23.1 0/4] xfs: fix incorrect return values in online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:55 -0700
Message-ID: <166473479505.1083393.7049311366138032768.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here we fix a couple of problems with the errno values that we return to
userspace.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fix-return-value
---
 fs/xfs/scrub/common.h |    2 +-
 fs/xfs/scrub/quota.c  |    2 +-
 fs/xfs/scrub/repair.c |    9 ++++++---
 3 files changed, 8 insertions(+), 5 deletions(-)

