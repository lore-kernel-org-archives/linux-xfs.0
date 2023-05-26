Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C27FC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbjEZAgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbjEZAgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E3E1AC
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64B9261B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F8EC433EF;
        Fri, 26 May 2023 00:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061357;
        bh=2CF9FYqA9+BKsMpKbWo4HhWYB9H153qYLkPy3eXKYKY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UCkX2MhtkN0PL2JUCdRm5SpUKNl8Cl5Rh3a8PHrL/Oy0op+ZuAWz+WbGf10VsrAtO
         MjG6Kz7M8irOigsIpUxY1bZphHOWdg/C1BM90wO3n7K9VvArlrOgqp4TLrDXY/FhdV
         bZfVZq0s3jaZ395zKgxkbtbCQMeEN77uO9hTalpuajVFmMiAbuleTCPZ4/GYX0zXaG
         6G4zkthkWFkWI+RDy6xw34XcuuUzx50do7bwylWhNweUULHC9ZQ1TkUp7PCu931BZW
         ye3dDOL6mis0q4K4HmuTarrKyGSwR3rKB6pLORnU5atUx70KeE/tjI9pY9+rUhQDjs
         +qMPnV3mqNUbA==
Date:   Thu, 25 May 2023 17:35:57 -0700
Subject: [PATCHSET v25.0 0/7] xfs: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067222.3737555.8668637245740627164.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile              |    3 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1370 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |  453 ++++++++++++++
 fs/xfs/scrub/findparent.h    |   50 ++
 fs/xfs/scrub/inode.c         |   19 +
 fs/xfs/scrub/inode_repair.c  |   42 +
 fs/xfs/scrub/iscan.c         |   18 +
 fs/xfs/scrub/iscan.h         |    1 
 fs/xfs/scrub/nlinks.c        |   23 +
 fs/xfs/scrub/nlinks_repair.c |   51 +-
 fs/xfs/scrub/parent.c        |   14 
 fs/xfs/scrub/parent_repair.c |  226 +++++++
 fs/xfs/scrub/readdir.c       |    7 
 fs/xfs/scrub/repair.c        |   29 +
 fs/xfs/scrub/repair.h        |    9 
 fs/xfs/scrub/scrub.c         |    4 
 fs/xfs/scrub/tempfile.c      |   13 
 fs/xfs/scrub/tempfile.h      |    2 
 fs/xfs/scrub/trace.h         |  115 ++++
 fs/xfs/xfs_icache.c          |    2 
 fs/xfs/xfs_inode.c           |   59 ++
 fs/xfs/xfs_inode.h           |   22 +
 23 files changed, 2520 insertions(+), 21 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c
 create mode 100644 fs/xfs/scrub/findparent.c
 create mode 100644 fs/xfs/scrub/findparent.h
 create mode 100644 fs/xfs/scrub/parent_repair.c

