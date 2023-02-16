Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A98FC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBPU1t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBPU1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:27:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B30939BBC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 187A160C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B02C433EF;
        Thu, 16 Feb 2023 20:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579263;
        bh=7UBxZY9ZHqenjQRpfNTDtWIOTb73oUa9efDY1Sz8YD0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=f9LMjfr96hvJ7G3JRc4SFcOIIiL2kR3izT+PQ9I9tuXZtaAQjM6p2eHPflToRlMBp
         XyzdFYa4cp9MA0YTJJk7MCOVNvRoX2ar9Ej7xxO5dPQHU4xFfYYUNEN3I8W9QO99ZS
         5teYCXZgw4ARrCFTMv+Z3W4aqx7MbP/7he4HG9ZtftBKZhiWzmTdM0S+fh6HBrsewb
         23s4FUU7n6jvEOF5nyvxRPUYWUziXULSTnel8ISg5GrhSZnhCTUaeIZ4RyFsaEOPQ9
         MaVXIjUyznlnrrpY9UdcWTD7x7j51A0g5Hf3XZE+GDBG/0ig7gQcQWDAMeTyFk4ugb
         NGBKScRNR66fQ==
Date:   Thu, 16 Feb 2023 12:27:43 -0800
Subject: [PATCHSET v9r2d1 0/2] xfs: online checking of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874864.3475106.13930268587808485264.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Update the existing online parent pointer checker to confirm the
directory entries that should also exist.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-check

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-parent-check
---
 fs/xfs/Makefile            |    2 
 fs/xfs/libxfs/xfs_parent.c |   38 +++
 fs/xfs/libxfs/xfs_parent.h |   10 +
 fs/xfs/scrub/parent.c      |  529 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h       |   66 +++++
 5 files changed, 644 insertions(+), 1 deletion(-)

