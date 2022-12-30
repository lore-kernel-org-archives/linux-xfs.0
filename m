Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DAEC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiL3XCg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3XCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:02:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B64F15FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:02:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0842B81D68
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9060CC433D2;
        Fri, 30 Dec 2022 23:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441351;
        bh=0qoTUBcj2RANoqWhbYw9bnELivMFZNOoBNaAcLJgEtw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q4vQd04E/DDMvTKdD5tB8kyZDBXmcvXcKFBswjVSVqMbfva9Ir1GX51ykXMR0OL1U
         fKXQz5QTmrAiHEnjMvRadGtLL1+AVVea4rDRW8wiwE3zUYClkyBaR5oC7dVwKHSDJN
         z28ItR4lE3sAYa1dLm0f8oWwigitJbbdZFpX2OUVaUAFZeN1arQPJBw0YlP1/Gsty2
         5+tlAc6Gj0hbsR0wYR90yBEaTgmD9hgphNseNouYy2RC1GHphDvSRq1cZHqdV6c2to
         BMPQAMoOsgTBi2lRkn+3xDQSYMlk6TAJPViwCeuucIcSpIyjsf/ToQdVuDXIJjTL4r
         CZnTf7lY3Qu4g==
Subject: [PATCHSET v24.0 0/4] xfs: live inode scans for online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:03 -0800
Message-ID: <167243838331.695519.18058154683213474280.stgit@magnolia>
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

The design document discusses the need for a specialized inode scan
cursor to manage walking every file on a live filesystem to build
replacement metadata objects while receiving updates about the files
already scanned.  This series adds two pieces of infrastructure -- the
scan cursor, and live hooks to deliver information about updates going
on in other parts of the filesystem.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-iscan
---
 fs/xfs/Kconfig       |   37 ++++
 fs/xfs/Makefile      |    6 +
 fs/xfs/scrub/iscan.c |  478 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h |   62 ++++++
 fs/xfs/scrub/trace.c |    1 
 fs/xfs/scrub/trace.h |   74 ++++++++
 fs/xfs/xfs_hooks.c   |   94 ++++++++++
 fs/xfs/xfs_hooks.h   |   72 ++++++++
 fs/xfs/xfs_iwalk.c   |   13 -
 fs/xfs/xfs_linux.h   |    1 
 10 files changed, 826 insertions(+), 12 deletions(-)
 create mode 100644 fs/xfs/scrub/iscan.c
 create mode 100644 fs/xfs/scrub/iscan.h
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h

