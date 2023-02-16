Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D8BC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBPU1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBPU13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:27:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCADD3B0ED
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:27:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A8C160C0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD380C433D2;
        Thu, 16 Feb 2023 20:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579247;
        bh=MFu5c1l3Ef9AdWo+D8voR5YKz5QvOhLJnzfPa63MUzU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=J6S1l/0pDByIVZyPfOpl5V/8My3JD+M5MoMO6qzSkL5uMsfk4W51+gOTz5dNKa/L8
         oTtv9rl8Ukhti+0gCavXM+i7tDQdbjmX9xH9Dp/EL42nw6u/9DO+SEESVs2DczaFVg
         rgtRyh/6l1co86/AE1ECpAhou+FMyoAtguluEupCnjTL0hLTSg1yvCb3MyYVTU74Qw
         vcI0KUVM5fqOPt2n8pCNGZUt0qFzZVz1uyZCtSjEAAzDKV/wN8511i1lAg99s17ycK
         V/T7O52dvmbHcZ/vqITCIWZZDf79dH16AorwkliCXo7sza66f7eyhG3jvfefQQvlQO
         Rzhrwa8hGeuEQ==
Date:   Thu, 16 Feb 2023 12:27:27 -0800
Subject: [PATCHSET v9r2d1 0/7] xfs: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874461.3474898.12919390014293805981.stgit@magnolia>
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

With this patchset, we implement online reconstruction of directories by
scanning the entire filesystem looking for parent pointer data.  This
mostly works, except for the part where we need to resync the diroffset
field of the parent pointers to match the new directory structure.

Fixing that is left as an open research question, with a few possible
solutions:

1. As part of committing the new directory, queue a bunch of parent
pointer updates to make those changes.

2. Leave them inconsistent and let the parent pointer repair fix it.

3. Change the ondisk format of parent pointers (and xattrs) so that we
can encode the full dirent name in the xattr name.

4. Change the ondisk format of parent pointers to encode a sha256 hash
of the dirent name in the xattr name.  This will work as long as nobody
breaks sha256.

Thoughts?  Note that the atomic swapext and block reaping code is NOT
ported for this PoC, so we do not commit any repairs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-repair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-dir-repair
---
 fs/xfs/Makefile               |    1 
 fs/xfs/libxfs/xfs_da_format.h |   11 
 fs/xfs/libxfs/xfs_dir2.c      |    2 
 fs/xfs/libxfs/xfs_dir2.h      |    2 
 fs/xfs/libxfs/xfs_parent.c    |   47 +-
 fs/xfs/libxfs/xfs_parent.h    |   24 -
 fs/xfs/scrub/common.c         |   15 +
 fs/xfs/scrub/common.h         |   28 +
 fs/xfs/scrub/dir.c            |   11 
 fs/xfs/scrub/dir_repair.c     | 1129 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/readdir.c        |   12 
 fs/xfs/scrub/readdir.h        |    3 
 fs/xfs/scrub/repair.h         |   16 +
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/tempfile.c       |   42 ++
 fs/xfs/scrub/tempfile.h       |    2 
 fs/xfs/scrub/trace.c          |    1 
 fs/xfs/scrub/trace.h          |   69 +++
 fs/xfs/xfs_inode.c            |   56 +-
 fs/xfs/xfs_inode.h            |    5 
 fs/xfs/xfs_symlink.c          |    4 
 21 files changed, 1428 insertions(+), 54 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c

