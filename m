Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38636C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEZAbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjEZAbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:31:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2502198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3747764B2A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E74EC433D2;
        Fri, 26 May 2023 00:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061092;
        bh=PYBj8ne3uu0JQc5Zw0BjMuCNrr3sNhctE/XSo775wVs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oN9RDYqlqVsUXgllPeBZSoXHvb4rG+p2Qq8x6q4hJM704xSmuTBV0QfrDeH5nRa/j
         CGuLjGtW6O5fzDSu8h3XrOHHh9SZaEC4cFhxGJDRmGQamsCvi7yRDkqHxMGkdBa3y1
         2tx5B52+2jt0nQESmMtY5lenE+DufVZwTCg1uiZDjhDEqK8XVjDUoRpynZ8vqPjb31
         t2VWO1bBTbDc6O/QEc7ocgTb56ZR3Sw5yp6OMSOMw6gCGcoMJ0Ah6invMIYmouAX/M
         ihpp3exzIvceHbcruv8Q+zNt7RwdjE0EzrT4H7jGjrtumoTUUFb2mOPzaD8HlQLs6S
         g6ttXnwu8n1og==
Date:   Thu, 25 May 2023 17:31:32 -0700
Subject: [PATCHSET v25.0 0/5] xfs: online repair of file link counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060263.3731332.723936389513300302.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Now that we've created the infrastructure to perform live scans of every
file in the filesystem and the necessary hook infrastructure to observe
live updates, use it to scan directories to compute the correct link
counts for files in the filesystem, and reset those link counts.

This patchset creates a tailored readdir implementation for scrub
because the regular version has to cycle ILOCKs to copy information to
userspace.  We can't cycle the ILOCK during the nlink scan and we don't
need all the other VFS support code (maintaining a readdir cursor and
translating XFS structures to VFS structures and back) so it was easier
to duplicate the code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-nlinks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-nlinks

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-nlinks
---
 fs/xfs/Makefile               |    4 
 fs/xfs/libxfs/xfs_da_format.h |   11 
 fs/xfs/libxfs/xfs_dir2.c      |    6 
 fs/xfs/libxfs/xfs_dir2.h      |   10 
 fs/xfs/libxfs/xfs_fs.h        |    4 
 fs/xfs/libxfs/xfs_health.h    |    4 
 fs/xfs/scrub/common.c         |    3 
 fs/xfs/scrub/common.h         |    1 
 fs/xfs/scrub/dir.c            |    4 
 fs/xfs/scrub/health.c         |    1 
 fs/xfs/scrub/nlinks.c         |  918 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.h         |  102 +++++
 fs/xfs/scrub/nlinks_repair.c  |  227 ++++++++++
 fs/xfs/scrub/repair.c         |   37 ++
 fs/xfs/scrub/repair.h         |    3 
 fs/xfs/scrub/scrub.c          |    9 
 fs/xfs/scrub/scrub.h          |    5 
 fs/xfs/scrub/trace.c          |    2 
 fs/xfs/scrub/trace.h          |  183 ++++++++
 fs/xfs/xfs_health.c           |    1 
 fs/xfs/xfs_inode.c            |  108 +++++
 fs/xfs/xfs_inode.h            |   31 +
 fs/xfs/xfs_mount.h            |    2 
 fs/xfs/xfs_super.c            |    2 
 fs/xfs/xfs_symlink.c          |    1 
 25 files changed, 1672 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks.c
 create mode 100644 fs/xfs/scrub/nlinks.h
 create mode 100644 fs/xfs/scrub/nlinks_repair.c

