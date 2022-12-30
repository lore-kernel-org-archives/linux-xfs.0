Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B22AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiLaDVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:21:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680C212A80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:21:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18A3CB81E72
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B900EC433F0;
        Sat, 31 Dec 2022 03:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456899;
        bh=jIRmEsZb6lvlkKP33wAGxWZTT6HSW4zktnk3W9Xv+wQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pfULerc0pjJmgyr3yi35H9qDZPzBv7EWVqnxMlU9VN76OwfKBZWa1j/V0kMEWbp+u
         FF/94wdN6nIn2CZ4jxqeGfA3PtIXlR4olEH1LrNgxYKewuqdDUh7l7b9Ikg0C1p/cW
         EX3tyF8mWTmAnoFMv6WNY2nluv/GQB5kfEk79gqXoJOlSZniysCeZKtj63ZRuZfosm
         jQkQBaqPnlJcrqQ6y9equjZwGTeVb53j4WgVJEWz9LCPbLgxQ+ZMHY0Kx+PaCFGLW6
         dY+7gAYN8r04IxgLWHAy5LVp8WXEyOBQ6KfFd1jlmlmDPfQdl8dxiTocXKw/meHFcY
         eN02/n52sh1xQ==
Subject: [PATCHSET 0/5] xfsprogs: defragment free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:47 -0800
Message-ID: <167243884763.740087.13414287212519500865.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These patches contain experimental code to enable userspace to defragment
the free space in a filesystem.  Two purposes are imagined for this
functionality: clearing space at the end of a filesystem before
shrinking it, and clearing free space in anticipation of making a large
allocation.

The first patch adds a new fallocate mode that allows userspace to
allocate free space from the filesystem into a file.  The goal here is
to allow the filesystem shrink process to prevent allocation from a
certain part of the filesystem while a free space defragmenter evacuates
all the files from the doomed part of the filesystem.

The second patch amends the online repair system to allow the sysadmin
to forcibly rebuild metadata structures, even if they're not corrupt.
Without adding an ioctl to move metadata btree blocks, this is the only
way to dislodge metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defrag-freespace

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=defrag-freespace
---
 Makefile                 |    2 
 db/agfl.c                |  297 +++++
 include/xfs_trace.h      |    4 
 io/prealloc.c            |   37 +
 libfrog/Makefile         |    6 
 libfrog/clearspace.c     | 2940 ++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/clearspace.h     |   72 +
 libxfs/libxfs_api_defs.h |    3 
 libxfs/libxfs_priv.h     |   10 
 libxfs/xfs_alloc.c       |   88 +
 libxfs/xfs_alloc.h       |    4 
 libxfs/xfs_bmap.c        |  149 ++
 libxfs/xfs_bmap.h        |    3 
 man/man8/xfs_db.8        |   11 
 man/man8/xfs_io.8        |    8 
 man/man8/xfs_spaceman.8  |   17 
 spaceman/Makefile        |    6 
 spaceman/clearfree.c     |  164 +++
 spaceman/init.c          |    1 
 spaceman/space.h         |    2 
 20 files changed, 3815 insertions(+), 9 deletions(-)
 create mode 100644 libfrog/clearspace.c
 create mode 100644 libfrog/clearspace.h
 create mode 100644 spaceman/clearfree.c

