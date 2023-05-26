Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D253C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjEZCBH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZCBG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:01:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5695C189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:01:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E239F64C47
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAC1C433EF;
        Fri, 26 May 2023 02:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066464;
        bh=pIr9AZqCqF0yeg+hDLbufjj3zflV//MmZEbC/TS1x8Y=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NQtWs5x0GWDREZEgNu3B2TRpgInHyLGAARtGdfdVOJtZUfw9OXq4ttNXVVCW1uGEg
         e33z4gRCdlPOMS6xS/lTBEC0MPkAV8YNhnhfbPp7Mqi0FxL88f1OM8MVdzmHoHE+M9
         AXZ1DAjB235arzMjDBK3xtv/5d1o82szH94zlaAf8QaQgcKVbInVVMBVJ/oVdI/H10
         LJ6x3dyIhxNteK2asVoBhPrtTzA0lleH3M+FTKCsu2yCbDfecFnuol0t8gXwhbDe7a
         w9XkMevpBLhmSD6e/RHW6arQ5eh+mVP2kYTg4DyDGqUqTDQOnFpkJ+JhJeuWOQjXWy
         mX3lTa6oOARvg==
Date:   Thu, 25 May 2023 19:01:03 -0700
Subject: [PATCHSET v12.0 00/17] xfs: fsck for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000710.GG11642@frogsfrogsfrogs>
References: <20230526000710.GG11642@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series implements online checking and repair for directory parent
pointer metadata.  The checking half is fairly straightforward -- for
each outgoing directory link (forward or backwards), grab the inode at
the other end, and confirm that there's a corresponding link.  If we
can't grab an inode or lock it, we'll save that link for a slower loop
that cycles all the locks, confirms the continued existence of the link,
and rechecks the link if it's actually still there.

Repairs are a bit more involved -- for directories, we walk the entire
filesystem to rebuild the dirents from parent pointer information.
Parent pointer repairs do the same walk but rebuild the pptrs from the
dirent information, but with the added twist that it duplicates all the
xattrs so that it can use the atomic extent swapping code to commit the
repairs atomically.

This introduces an added twist to the xattr repair code -- because the
VFS doesn't take i_rwsem on directory children when moving them from one
parent to another, we use dirent hooks to detect a colliding update to
the pptr data; if one is detected, we restart the xattr salvaging
process but this time hold all the ILOCKs until the end of the scan.

For offline repair, the phase6 directory connectivity scan generates an
index of all the expected parent pointers in the filesystem.  Then it
walks each file and compares the parent pointers attached to that file
against the index generated, and resyncs the results as necessary.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-fsck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-fsck
---
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_bmap.c     |    2 
 fs/xfs/libxfs/xfs_dir2.c     |    2 
 fs/xfs/libxfs/xfs_dir2.h     |    2 
 fs/xfs/libxfs/xfs_parent.c   |   86 +++
 fs/xfs/libxfs/xfs_parent.h   |   18 +
 fs/xfs/scrub/attr.c          |    2 
 fs/xfs/scrub/attr_repair.c   |  496 +++++++++++++++++
 fs/xfs/scrub/attr_repair.h   |    4 
 fs/xfs/scrub/dir.c           |  341 ++++++++++++
 fs/xfs/scrub/dir_repair.c    |  564 +++++++++++++++++++-
 fs/xfs/scrub/findparent.c    |   60 ++
 fs/xfs/scrub/findparent.h    |   12 
 fs/xfs/scrub/listxattr.c     |   10 
 fs/xfs/scrub/listxattr.h     |    4 
 fs/xfs/scrub/orphanage.c     |   66 ++
 fs/xfs/scrub/orphanage.h     |    2 
 fs/xfs/scrub/parent.c        |  599 +++++++++++++++++++++
 fs/xfs/scrub/parent_repair.c | 1207 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/scrub.c         |    6 
 fs/xfs/scrub/scrub.h         |    8 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |  190 +++++++
 23 files changed, 3605 insertions(+), 79 deletions(-)

