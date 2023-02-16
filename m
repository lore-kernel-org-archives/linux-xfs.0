Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85215C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBPUc3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBPUc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:32:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2EC4B53D;
        Thu, 16 Feb 2023 12:32:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E25B82962;
        Thu, 16 Feb 2023 20:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9849C433D2;
        Thu, 16 Feb 2023 20:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579544;
        bh=4zwYMNgFJ/mJWEt/CCL01wnlgbqt0Kc75oRTNa7hkjo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FDVdUb+Fp0SO5KDvPlPZ32FRTsBQx5VuJZHDTuD7hwBjylbMfkrrUHY4UiG9Owa1X
         ogrOZZ+n1zvajTKXvzSIjIO4Nkb63KQswCPipQKZxjk3gZd/acWkiBF2JA5lXG+fY4
         y5McSVax6n9wWcvBIzXRAu0f+D0vsfTwMLrlVA/bAxem83Dd8SW/TAPG47tAlx/GN0
         yj74fvIQpoahINVNZ0CsUKW6UoZAqd5uCxQysYeJej8QjH7dxktQvP/Djxklq9AkqQ
         VALW5ocDQ/jjnSkCxPmMM0V0el37z1miOOIQ87SlBQ9Nh9bKLD0RB+Yz4BO/qfbdc9
         E2cAXshc362IQ==
Date:   Thu, 16 Feb 2023 12:32:24 -0800
Subject: [PATCHSET v9r2 0/4] fstests: encode parent pointer name in xattr key
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884979.3481738.5353655058338554587.stgit@magnolia>
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

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-name-in-attr-key

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-name-in-attr-key

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-name-in-attr-key
---
 common/punch             |    8 ++++++++
 tests/xfs/021.out.parent |   22 ++++++++++------------
 tests/xfs/122.out        |    4 ++--
 3 files changed, 20 insertions(+), 14 deletions(-)

