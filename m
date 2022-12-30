Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE94DC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbiL3XHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiL3XHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:07:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0DC2DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:07:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8080B81CBC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A369C433EF;
        Fri, 30 Dec 2022 23:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441649;
        bh=j3mE3cltC3hTBzUOb8WTsiNmlqSxLE41J7ns2sjQYvU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TvsqV9B6mEDt/jcmmbU/BiKCsf78PZUoVNQC9FEg+4KRx0Ccl/RYARURXa0sb4Un4
         3TbWIZLZFIX1za6KHeIngEcwN9IEx8zGLdlkyVFXgayvavnq6sjCpwbW+Ew03ZgUQ1
         DsFYsY1RUetwT6yY7aL6ctbVhr1U/yy6I0Ux2OjrJdwOnp6oYnsoUZhAT1H664zaU7
         niFp+DhrDe53B08CYoq3sqKGvrqCm9FDlSR8rrFUkjQ7icNBnHN9RRaMzBXC2CKypq
         3nFrAO4LSQ3aR7SwiGwVPuVrLxnxqf/VZbtyXySUc2WKjdu76AcdShsyPSqOOj9ojn
         x9SHXwBk+rA9A==
Subject: [PATCHSET v24.0 0/3] xfs: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:16 -0800
Message-ID: <167243845636.700660.17331865239070788293.stgit@magnolia>
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

This series employs atomic extent swapping to enable safe reconstruction
of directory data.  For now, XFS does not support reverse directory
links (aka parent pointers), so we can only salvage the dirents of a
directory and construct a new structure.

Directory repair therefore consists of five main parts:

First, we walk the existing directory to salvage as many entries as we
can, by adding them as new directory entries to the repair temp dir.

Second, we validate the parent pointer found in the directory.  If one
was not found, we scan the entire filesystem looking for a potential
parent.

Third, we use atomic extent swaps to exchange the entire data fork
between the two directories.

Fourth, we reap the old directory blocks as carefully as we can.

To wrap up the directory repair code, we need to add to the regular
filesystem the ability to free all the data fork blocks in a directory.
This does not change anything with normal directories, since they must
still unlink and shrink one entry at a time.  However, this will
facilitate freeing of partially-inactivated temporary directories during
log recovery.

The second half of this patchset implements repairs for the dotdot
entries of directories.  For now there is only rudimentary support for
this, because there are no directory parent pointers, so the best we can
do is scanning the filesystem and the VFS dcache for answers.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-dirs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-dirs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-dirs
---
 fs/xfs/Makefile              |    2 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1179 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.c         |    7 
 fs/xfs/scrub/iscan.h         |    3 
 fs/xfs/scrub/nlinks.c        |   23 +
 fs/xfs/scrub/nlinks_repair.c |    9 
 fs/xfs/scrub/parent.c        |    3 
 fs/xfs/scrub/parent.h        |   17 +
 fs/xfs/scrub/parent_repair.c |  461 ++++++++++++++++
 fs/xfs/scrub/repair.c        |   29 +
 fs/xfs/scrub/repair.h        |    7 
 fs/xfs/scrub/scrub.c         |    4 
 fs/xfs/scrub/tempfile.c      |   13 
 fs/xfs/scrub/tempfile.h      |    2 
 fs/xfs/scrub/trace.h         |  138 +++++
 fs/xfs/xfs_inode.c           |   51 ++
 17 files changed, 1953 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c
 create mode 100644 fs/xfs/scrub/parent.h
 create mode 100644 fs/xfs/scrub/parent_repair.c

