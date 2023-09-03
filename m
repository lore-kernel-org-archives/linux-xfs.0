Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076CDC83F2C
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Sep 2023 16:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjICQPz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 12:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbjICQPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2023 12:15:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5556100
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 09:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 028F5CE0AEE
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 16:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5C6C433C8;
        Sun,  3 Sep 2023 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693757748;
        bh=iIGinyZfTytc4kk/ZxBcokyP6spqhgx9A02T5ebgFb4=;
        h=Subject:From:To:Cc:Date:From;
        b=RJ3diR0Z4DP+14DodqCuoE/ulvUEb2bnW2aBFykGG3E6zJTBHkOSQib49zTR9F092
         BoCIFAKVi5yuifZS1O7Ubg2vTETGyLvyx1IccZIRSm0LOYL0LFCwEC8dHE7kqXSVZ5
         Ifpto1EbFFBqGJ/103bEaAaVswDzH44MYGzP0IzCKuYVy0yM2JGFtehCbnj4wDSVm9
         Hs7lxFxP/XhPOlig8/gNPbRQpFJMldnIoKKLU7lMX3SirMz2jLZOG7jlnqb9RI8CZy
         Zkd1JEoxsLjccc9bMnxirSePljgo4xuMMQoj5XeXBD4dgUeVysFAylIvcgNcC9JVFr
         cc09J88Re37PQ==
Subject: [PATCHSET 0/3] xfs: reload entire iunlink lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 03 Sep 2023 09:15:47 -0700
Message-ID: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the second part of correcting XFS to reload the incore unlinked
inode list from the ondisk contents.  Whereas part one tackled failures
from regular filesystem calls, this part takes on the problem of needing
to reload the entire incore unlinked inode list on account of somebody
loading an inode that's in the /middle/ of an unlinked list.  This
happens during quotacheck, bulkstat, or even opening a file by handle.

In this case we don't know the length of the list that we're reloading,
so we don't want to create a new unbounded memory load while holding
resources locked.  Instead, we'll target UNTRUSTED iget calls to reload
the entire bucket.

Note that this changes the definition of the incore unlinked inode list
slightly -- i_prev_unlinked == 0 now means "not on the incore list".

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-iunlink-list-6.6
---
 fs/xfs/xfs_export.c |    6 +++
 fs/xfs/xfs_icache.c |    2 -
 fs/xfs/xfs_inode.c  |  115 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.h  |   34 ++++++++++++++-
 fs/xfs/xfs_itable.c |    9 ++++
 fs/xfs/xfs_mount.h  |    7 +++
 fs/xfs/xfs_qm.c     |    7 +++
 fs/xfs/xfs_trace.h  |   20 +++++++++
 8 files changed, 193 insertions(+), 7 deletions(-)

