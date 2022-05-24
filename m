Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CED1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiEXFfs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiEXFfr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E1C7CDF6
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D264561484
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365FFC385AA;
        Tue, 24 May 2022 05:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370545;
        bh=jTcQRfSMk1Dy18SfiAYcOl++e6xOaLBiTH4QQUGbET4=;
        h=Subject:From:To:Cc:Date:From;
        b=QnlK+bmkp76CotokUfuhQRMYMoLwhF1p+I61zSJ9dhEkKx1q3g5QxZUW0Lq4YJxqd
         bpk53ZBF2GoerEr8H568fLAUet7LL5H6PlWlocdbg7NXuzHwrQxBMz2rzyzXyRMz3O
         /iYTScvjy9/ijM/Lwq/NJX0Ko5q10WbcjQJyKrS8ysS52BcTS+DJHhehpZRiEawUrQ
         CBxKJxEQJlMs9hYyFUywUsO9+tZYCqvHwddhe6rgDTGY6upPGkblAGfj5pGBPMEuNV
         s4dVdObuiZ64JwMbYtrPqWmxcwf60MMUXSfkoZpWsJ1jXeAbEGTFQkkki3dhrK8Vdz
         GzqDRwmu81TmA==
Subject: [PATCHSET v2 0/3] xfs: fix buffer cancellation table leak during log
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Date:   Mon, 23 May 2022 22:35:44 -0700
Message-ID: <165337054460.992964.11039203493792530929.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As part of solving the memory leaks and UAF problems, kmemleak also
reported that log recovery will leak the table used to hash buffer
cancellations if the recovery fails.  Fix this problem by creating
alloc/free helpers that initialize and free the hashtable contents
correctly.

v2: rebase against most recent for-next

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-recovery-leak-fixes-5.19
---
 fs/xfs/libxfs/xfs_log_recover.h |   14 +++++---
 fs/xfs/xfs_buf_item_recover.c   |   66 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h           |    3 --
 fs/xfs/xfs_log_recover.c        |   34 +++++++-------------
 4 files changed, 85 insertions(+), 32 deletions(-)

