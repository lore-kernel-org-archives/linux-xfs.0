Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D89C7618A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCPTUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjCPTUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:20:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF096583;
        Thu, 16 Mar 2023 12:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE7F5B82321;
        Thu, 16 Mar 2023 19:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A845FC433EF;
        Thu, 16 Mar 2023 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994380;
        bh=6PEvQH52Xozy3XAaGjVUF7E67aHYC40+w96hia3sRfU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BvxquQ3oc03C+2kwBN8go5rIuBW+RLB70BOIeM1CGWEPgWani5yZTIO05VGqNAIvo
         2sPJ5W8re35X4qoNTdSMU3FpgOVNXyUSQZ22g60krIMpYuEIyawFXlvv512FG39sy/
         Gsw1AUZ5HdFlmJ3FAU9RhG1ursP5Ey8aLuqgpzViT2BNlrjxQZtinkxCaBjc2d04ZP
         SoLu5znYzbOHC8VDErjbhxoYiIUMvp5n6sKvUEri74njwu/vUgXgCpVd3jutwYXij2
         AgY1ogEapg40vfpb2INpnEowoBT/Vk+5V+DnMAc3ygHl+uP0C81PjxhK8v9aDemzH2
         2IYmBdQeAh+YA==
Date:   Thu, 16 Mar 2023 12:19:40 -0700
Subject: [PATCHSET v10r1d2 0/1] fstests: encode parent pointer name in xattr
 key
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899418443.18363.13765302382460119202.stgit@frogsfrogsfrogs>
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

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-name-in-attr-key

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-name-in-attr-key

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-name-in-attr-key
---
 tests/xfs/021.out.parent |   22 ++++++++++------------
 tests/xfs/122.out        |    2 +-
 2 files changed, 11 insertions(+), 13 deletions(-)

