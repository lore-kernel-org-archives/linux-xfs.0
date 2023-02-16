Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D40C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBPUbZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBPUbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:31:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3A6196B9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 187BC60AB9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B523C433EF;
        Thu, 16 Feb 2023 20:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579482;
        bh=S0K6poQWJABUcczox8tjiDXPG9EeVwuUTOXSsWAJDqU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QzTilxRKsQhUQBr8vledurYXgmBxZpmivXEW1YnBumPDTt1jDrfSD/4byZdeJgklK
         HnN280CD0EFaadD2Z19qp1nRON5U2czR/IxBmufFxzCDSvNfe924vxvsKg9z66+dQc
         0lggImwhMJUhq5e3BMYWPbibGNba+PxTKdf4zi7+M9nKFRO4RTRyCQONvlH2/H5I3/
         nXmBs8vTjiOcKgYOBNxjR+CfHabVqGyK29tPu2UDdF45RiceTOtNJ/vwEJy6I+0uM5
         1q3qGkc9DpsavB3ZgOQSVibZ6vuygcPsyVLdjdgaZzEENmUeMsLXxNEvVV+2HADLK+
         q47/moyAfkSEA==
Date:   Thu, 16 Feb 2023 12:31:21 -0800
Subject: [PATCHSET v9r2d1 0/6] xfsprogs: encode parent pointer name in xattr
 key
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882371.3478037.12485693506644718323.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As I've mentioned in past comments on the parent pointers patchset, the
proposed ondisk parent pointer format presents a major difficulty for
online directory repair.  This difficulty derives from encoding the
directory offset of the dirent that the parent pointer is mirroring.
Recall that parent pointers are stored in extended attributes:

    (parent_ino, parent_gen, diroffset) -> (dirent_name)

If the directory is rebuilt, the offsets of the new directory entries
must match the diroffset encoded in the parent pointer, or the
filesystem becomes inconsistent.  There are a few ways to solve this
problem.

One approach would be to augment the directory addname function to take
a diroffset and try to create the new entry at that offset.  This will
not work if the original directory became corrupt and the parent
pointers were written out with impossible diroffsets (e.g. overlapping).
Requiring matching diroffsets also prevents reorganization and
compaction of directories.

This could be remedied by recording the parent pointer diroffset updates
necessary to retain consistency, and using the logged parent pointer
replace function to rewrite parent pointers as necessary.  This is a
poor choice from a performance perspective because the logged xattr
updates must be committed in the same transaction that commits the new
directory structure.  If there are a large number of diroffset updates,
then the directory commit could take an even longer time.

Worse yet, if the logged xattr updates fill up the transaction, repair
will have no choice but to roll to a fresh transaction to continue
logging.  This breaks repair's policy that repairs should commit
atomically.  It may break the filesystem as well, since all files
involved are pinned until the delayed pptr xattr processing completes.
This is a completely bad engineering choice.

Note that the diroffset information is not used anywhere in the
directory lookup code.  Observe that the only information that we
require for a parent pointer is the inverse of an pre-ftype dirent,
since this is all we need to reconstruct a directory entry:

    (parent_ino, dirent_name) -> NULL

The xattr code supports xattrs with zero-length values, surprisingly.
The parent_gen field makes it easy to export parent handle information,
so it can be retained:

    (parent_ino, parent_gen, dirent_name) -> NULL

Moving the ondisk format to this format is very advantageous for repair
code.  Unfortunately, there is one hitch: xattr names cannot exceed 255
bytes due to ondisk format limitations.  We don't want to constrain the
length of dirent names, so instead we could use collision resistant
hashes to handle dirents with very long names:

    (parent_ino, parent_gen, sha512(dirent_name)) -> (dirent_name)

The first two patches implement this schema.  However, this encoding is
not maximally efficient, since many directory names are shorter than the
length of a sha512 hash.  The last three patches in the series bifurcate
the parent pointer ondisk format depending on context:

For dirent names shorter than 243 bytes:

    (parent_ino, parent_gen, dirent_name) -> NULL

For dirent names longer than 243 bytes:

    (parent_ino, parent_gen, dirent_name[0:178],
     sha512(child_gen, dirent_name)) -> (dirent_name[179:255])

The child file's generation number is mixed into the sha512 computation
to make it a little more difficult for unprivileged userspace to attempt
collisions.

A messier solution to this problem would be to extend the xattr ondisk
format to allow parent pointers to have xattr names up to 267 bytes.
This would likely involve redefining the ondisk namelen field to omit
the size of the parent ino/gen information and might be madness.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-name-in-attr-key

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-name-in-attr-key

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-name-in-attr-key
---
 db/attr.c                |   29 +++++
 db/attrshort.c           |   19 +++
 db/field.c               |    2 
 db/field.h               |    1 
 db/fprint.c              |   31 +++++
 db/fprint.h              |    2 
 db/metadump.c            |   39 +++----
 include/libxfs.h         |    1 
 io/crc32cselftest.c      |   22 ++++
 libfrog/Makefile         |   10 +-
 libfrog/sha512.c         |  249 +++++++++++++++++++++++++++++++++++++++++++
 libfrog/sha512.h         |   33 ++++++
 libfrog/sha512selftest.h |   86 +++++++++++++++
 libxfs/libxfs_api_defs.h |    2 
 libxfs/libxfs_priv.h     |    1 
 libxfs/xfs_da_format.h   |   49 ++++++++-
 libxfs/xfs_fs.h          |    4 -
 libxfs/xfs_parent.c      |  264 +++++++++++++++++++++++++++++++++++++---------
 libxfs/xfs_parent.h      |   48 ++++++--
 libxfs/xfs_trans_resv.c  |    6 +
 logprint/log_redo.c      |  124 ++++++++++++++++------
 logprint/logprint.h      |    3 -
 man/man3/xfsctl.3        |    1 
 man/man8/xfs_io.8        |    4 +
 mkfs/proto.c             |    7 +
 mkfs/xfs_mkfs.c          |    8 +
 repair/init.c            |    5 +
 repair/phase6.c          |   13 +-
 repair/pptr.c            |  199 +++++++++++++++++++++++------------
 repair/pptr.h            |    2 
 30 files changed, 1043 insertions(+), 221 deletions(-)
 create mode 100644 libfrog/sha512.c
 create mode 100644 libfrog/sha512.h
 create mode 100644 libfrog/sha512selftest.h

