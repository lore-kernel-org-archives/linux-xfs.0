Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84450C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJBSYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiJBSYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5C4D48
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A05760EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54BCC433C1;
        Sun,  2 Oct 2022 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735080;
        bh=w5fNzhYNWvbI8Bui3kq5Ct2Em5XL5W7QzFdD3Zl5Bdo=;
        h=Subject:From:To:Cc:Date:From;
        b=BcXuibOJHUwfmzERAqlGprtVqWgPEjn7M2zs0b+eXleOQCjMJAmelo3fmQcNulZB0
         3HaFm7TRPZKvGhy2U6dJwZTBhlCIxOnyNgHelp3t1pqENDI2nEpQOFAdE0s7feWi+P
         V98HYv7BQPuoA7H/pIaWpa7P7XgBcGT/t/oRLlc6Z6Ve9q+Yu2Kx+YK2/s07TGkP24
         j9GZRBFfvIYk3U6wKgGNPpcGruC8/PkJt899Ei3IuKYRNcu94W+Czk2QTNIujausDI
         7tkdxzcL/1f3kaVwNMih4opMwLeELJNeo0aAvtDkn6/tWZSZmjCctgjfbwYXkEnU6R
         rzrtpdAQh49eQ==
Subject: [PATCHSET v23.1 0/3] xfs: fix iget usage in directory scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:32 -0700
Message-ID: <166473483259.1084804.16578148649615408100.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, we fix some problems with how the directory scrubber
grabs child inodes.  First, we want to reduce EDEADLOCK returns by
replacing fixed-iteration loops with interruptible trylock loops.
Second, we add UNTRUSTED to the child iget call so that we can detect a
dirent that points to an unallocated inode.  Third, we fix a bug where
we weren't checking the inode pointed to by dotdot entries at all.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-dir-iget-fixes
---
 fs/xfs/scrub/common.c |   22 -----
 fs/xfs/scrub/common.h |    1 
 fs/xfs/scrub/dir.c    |   79 +++++++------------
 fs/xfs/scrub/parent.c |  203 +++++++++++++++++++++++--------------------------
 4 files changed, 126 insertions(+), 179 deletions(-)

