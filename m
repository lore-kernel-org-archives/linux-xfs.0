Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AB1C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCPTRn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCPTRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:17:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED553B1B33
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E050620EA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F3C433EF;
        Thu, 16 Mar 2023 19:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994256;
        bh=HsVXfnxXFWbuNoF0nVM3FGKzXtaRFmKh4OIB58hZfjc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pw9NVhHMSGu1IZU21oTtzOQnxPQUUQig3YbM1BVK2/DSF5F4k4yseKoMGW7l5419N
         lQbuGhP5gUH7Mm3IfxGMSGOsZ/LaFqOxUSxhGh3XkRh1vAiyygbfCq3eRkhz9l1mfg
         CziV2WyiHeopMjsN8no98KxgUQwdiEDf3iKPrSXE3ZxFB0VvEbrocMavsxEwSScWfJ
         n9Bf3BE+JmnelqDdJZeqk//deCf6tFiPW3BzDnly6Wy9X0SYZTjSS5anFIah5RBTkt
         voFl3Dv+jjTUxIKXnfy1Q9gGOoHLqE2TlWXTwiidoi3z+Gquxf0fmYXsfAonlnfddc
         yspXbaKD458Dg==
Date:   Thu, 16 Mar 2023 12:17:35 -0700
Subject: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in xattr key
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
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
length of dirent names, so instead we create a special VLOOKUP mode for
extended attributes that allows parent pointers to require matching on
both the name and the value.

The ondisk format of a parent pointer can then become:

    (parent_ino, parent_gen, dirent_name[0:242]) -> (dirent_name[243:255])

Because we can always look up a specific parent pointer.  Most of the
patches in this patchset prepare the high level xattr code and the lower
level logging code to do this correctly, and the last patch switches the
ondisk format.

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
 fs/xfs/libxfs/xfs_attr.c       |   66 +++++---
 fs/xfs/libxfs/xfs_attr.h       |    5 +
 fs/xfs/libxfs/xfs_attr_leaf.c  |   41 ++++-
 fs/xfs/libxfs/xfs_da_btree.h   |    6 +
 fs/xfs/libxfs/xfs_da_format.h  |   39 ++++-
 fs/xfs/libxfs/xfs_fs.h         |    2 
 fs/xfs/libxfs/xfs_log_format.h |   31 +++-
 fs/xfs/libxfs/xfs_parent.c     |  215 +++++++++++++++++----------
 fs/xfs/libxfs/xfs_parent.h     |   46 +++---
 fs/xfs/libxfs/xfs_trans_resv.c |    7 +
 fs/xfs/scrub/dir.c             |   34 +---
 fs/xfs/scrub/dir_repair.c      |   87 +++--------
 fs/xfs/scrub/parent.c          |   48 +-----
 fs/xfs/scrub/parent_repair.c   |   55 ++-----
 fs/xfs/scrub/trace.h           |   65 +-------
 fs/xfs/xfs_attr_item.c         |  318 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_attr_item.h         |    3 
 fs/xfs/xfs_inode.c             |   30 ++--
 fs/xfs/xfs_ondisk.h            |    1 
 fs/xfs/xfs_parent_utils.c      |    8 +
 fs/xfs/xfs_symlink.c           |    3 
 fs/xfs/xfs_xattr.c             |    5 +
 22 files changed, 660 insertions(+), 455 deletions(-)

