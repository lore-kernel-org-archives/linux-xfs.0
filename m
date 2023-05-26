Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27DFC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbjEZCCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbjEZCCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:02:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA19B195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 463F16179C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB28C433D2;
        Fri, 26 May 2023 02:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066526;
        bh=Yf2xL01oyDqWmj63pjILhzu/N7iJDs69HJQe2mp4zQQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XpKGdMTNBIqmg3sEGAtpIddc2w9KA0TdH8Ez0wViER2fpGuHENRW+OVLgm/B71BSw
         5a+oXuR5i+ztAw/KQGymPcfFOaF8sU+gfVMkV4XAcLuyF6S9y0JMKHKMXZcEdvwCrS
         u2oVXsCGSoWObG+p2PZrMJPW2zrxVlUVPes62nDdq8YQ+B6QW1nX53XMKNypFIfsNV
         ew7Jc0fhTGmB/sj5Yz2JoYEncRLQyXmemytCCc4/wT5xJsOGHqpkeQZScA/0rXNB2F
         zW7w58ovPixmPGRgw7GQtFatal2JU5DzydXcOg5K39b0bdz+H/IFJl34w7MqenqtkL
         k/+o+jYn2tYwA==
Date:   Thu, 25 May 2023 19:02:06 -0700
Subject: [PATCHSET v12.0 00/14] xfsprogs: fsck for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
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

The last patch teaches xfs_scrub to report pathnames of files that are
being repaired, when possible.

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
 libxfs/Makefile          |    2 
 libxfs/libxfs_api_defs.h |    4 
 libxfs/xfblob.c          |  157 ++++++
 libxfs/xfblob.h          |   27 +
 libxfs/xfile.c           |   11 
 libxfs/xfile.h           |    1 
 libxfs/xfs_bmap.c        |    2 
 libxfs/xfs_dir2.c        |    2 
 libxfs/xfs_dir2.h        |    2 
 libxfs/xfs_parent.c      |   86 +++
 libxfs/xfs_parent.h      |   18 +
 repair/Makefile          |    6 
 repair/listxattr.c       |  271 ++++++++++
 repair/listxattr.h       |   15 +
 repair/phase6.c          |  116 ++++
 repair/pptr.c            | 1274 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h            |   17 +
 repair/strblobs.c        |  212 ++++++++
 repair/strblobs.h        |   24 +
 scrub/phase6.c           |   62 ++
 20 files changed, 2291 insertions(+), 18 deletions(-)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h
 create mode 100644 repair/listxattr.c
 create mode 100644 repair/listxattr.h
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h

