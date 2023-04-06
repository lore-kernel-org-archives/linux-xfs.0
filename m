Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3812C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbjDFTOq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240548AbjDFTOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A6B10F1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C796365E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482A1C433D2;
        Thu,  6 Apr 2023 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808482;
        bh=vFsVpuoT1FI4/gpKyF0/KZh0SioGLAsAIgARE6zR2/4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qIVpiqDVtzrwSqwa9lDDm54gTLfA/ksjWzCXAQ5y5bxmVBMNWpLYH0du9+WXkEBzd
         20YYZvn020Kr9XCfme+42hI/5q7G18a8USWvz9s6aboKmWxDVc4ECxV7OAm0eVpL6s
         ggaVIYlnEu7p10Rwp+91m7fTogbH9yErhNJH3f/cgCez9JFk5mFcML0KiBFfYU018q
         MI3GDRhFsUILM3DnJ9ftdC37i2L241yfjLLcUFzFYXCQ1Wt7K2BesiRwPunF/8VvX8
         kSwGe96Z/cOhDEzWqFp0uZPBFSc/s3n979crnm4O3xh4/rAuM75EnJGcgn6YyVsJlF
         5UDxH9cqze5kw==
Date:   Thu, 06 Apr 2023 12:14:41 -0700
Subject: [PATCHSET v11 0/3] xfs: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825278.615785.11418750801629760336.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
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
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_dir2.c  |    2 
 fs/xfs/libxfs/xfs_dir2.h  |    2 
 fs/xfs/scrub/common.c     |   15 +
 fs/xfs/scrub/common.h     |   28 +
 fs/xfs/scrub/dir.c        |    9 
 fs/xfs/scrub/dir_repair.c | 1125 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h     |   16 +
 fs/xfs/scrub/scrub.c      |    2 
 fs/xfs/scrub/tempfile.c   |   42 ++
 fs/xfs/scrub/tempfile.h   |    2 
 fs/xfs/scrub/trace.c      |    1 
 fs/xfs/scrub/trace.h      |   65 +++
 13 files changed, 1307 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c

