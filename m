Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 710DBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiL3WZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiL3WZ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:25:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A9D1D0CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8BE9BCE19B8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B378C433EF;
        Fri, 30 Dec 2022 22:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439124;
        bh=oy6b9nD3CittG/zSgQgeBJLpfDBncmJEcfs0gHn9ZS0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XDrvpBDQY7gibhPkINYNt8hGm6tRSyxlb1XDShmNw7vBlPXtVIzzrrfyTcWXRTINo
         e/924d99AMX6VQeQeGvG9dSLy7cI6GmswiNOW6AMT3XdvKu4+nECJBYHVDEI/gkRxs
         CGQ5sPI2Bdr9diACDxwD+dICKibZ1PHZE+wg4A6YxIdYfe7s3aoLViRknD+/TbgG6o
         Zrvi+Kms3SeE1ivql9MsYlhDBXGG9WR70BBy2mG261A53xuJZ37AWmNSPLY22TZdbn
         n3we7o/gTPVsd1lms2U0+1NQ7gHZfnENLvWAYr1FzfinPpdN8JfOFcDObLkuxXQB5d
         S9rmkqwpcj4Gg==
Subject: [PATCHSET v24.0 0/3] xfs: hoist scrub record checks into libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:15 -0800
Message-ID: <167243827537.684088.11219968589590305107.stgit@magnolia>
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

There are a few things about btree records that scrub checked but the
libxfs _get_rec functions didn't.  Move these bits into libxfs so that
everyone can benefit.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-hoist-scrub-checks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-hoist-scrub-checks
---
 fs/xfs/libxfs/xfs_ialloc.c |    4 ++++
 fs/xfs/libxfs/xfs_rmap.c   |   27 +++++++++++++++++++++++++++
 fs/xfs/scrub/ialloc.c      |    6 ------
 fs/xfs/scrub/rmap.c        |   22 ----------------------
 4 files changed, 31 insertions(+), 28 deletions(-)

