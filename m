Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1870CC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJBSXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiJBSXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:23:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04002528C
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53BA6B80D22
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2274C433C1;
        Sun,  2 Oct 2022 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735014;
        bh=KKkTOBLDfNWEDjA2IFjCjBLgk2G3V15tJvejfgDyMD0=;
        h=Subject:From:To:Cc:Date:From;
        b=B3Uiz5a5uKbPpJ15cSWFnlKdZrt7JuCqj8d/hWEQJ8PkawiagKibUw6R3jySx21ie
         DB90YzX/ud8V5nEDaVgRmXEVyYC6Wiw8qZ11yS46x58cwR2VtkFHioVMJO0v6jOXyZ
         Rn1p+jKr5iCHQ8rpDhuFx6RKwpm9U1Y1GuJeMqUoEONlEcKrxV+HXGE9knqYKraUeW
         niXvBh7zqvH0uX8ll3GE4w8KSot39tQhqFqSXsQc637HMbBBZw7r5+F62P/7NUJCKF
         2pHSWLjgNRpm7zXyzjqxi9YJn2KYxSk0+Hda5xN4ohTfd5T9Ce/35vxbs6+0JYVB4m
         16pvcrzmY1IIQ==
Subject: [PATCHSET v23.1 0/2] xfs: clean up memory allocations in online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:51 -0700
Message-ID: <166473479188.1083296.3778962206344152398.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series standardizes the GFP_ flags that we use for memory
allocation in online scrub, and convert the callers away from the old
kmem_alloc code that was ported from Irix.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-cleanup-malloc
---
 fs/xfs/scrub/agheader.c        |    2 +-
 fs/xfs/scrub/agheader_repair.c |    2 +-
 fs/xfs/scrub/attr.c            |   11 +++++------
 fs/xfs/scrub/bitmap.c          |   11 ++++++-----
 fs/xfs/scrub/btree.c           |   10 +++++-----
 fs/xfs/scrub/dabtree.c         |    4 ++--
 fs/xfs/scrub/fscounters.c      |    2 +-
 fs/xfs/scrub/refcount.c        |   12 ++++++------
 fs/xfs/scrub/scrub.c           |    6 +++---
 fs/xfs/scrub/scrub.h           |    9 +++++++++
 fs/xfs/scrub/symlink.c         |    2 +-
 11 files changed, 40 insertions(+), 31 deletions(-)

