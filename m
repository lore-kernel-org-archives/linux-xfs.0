Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FFCC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbjEZAgW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241800AbjEZAgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508A195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 048E564AFD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6974DC433EF;
        Fri, 26 May 2023 00:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061373;
        bh=IPmEEWWdAtb6IcVbKM06r9KNxnbsTJvF/4TBCXV3sVA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OXCuLL54ob3DSomSmm3sBGny1Wfyhw3QThhFFRfGcoeoN4SCbhOr9cJx6thv88Hg3
         6RtQotdMBdsDMbg5BQChtSdnT/8JXdSulSo7/lC69K0XN2PgOHKuCJ63v9s375hPJx
         Af1OFfP3hB2p/rpEeIV9A5JxSM5DDwnzWsWbsIUtTDXQt5PHstXjTyln+TkY9ZRF3M
         pYgf5T2AfYtRKyRIG/IlgKu2Xy0fUZWwtLl4gIeJ+f9wjAuoNwxZ06RH6SXivegU0s
         nFqffSfXuS9ZPIzC/8iIxT8+EtBjb28W0iCabtJ8aicLCkq4kOcDi6vaVl/XLU8XRs
         Acs+6ZNkJ4UyA==
Date:   Thu, 25 May 2023 17:36:12 -0700
Subject: [PATCHSET v25.0 0/3] xfs: move orphan files to lost and found
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067639.3737779.12844625794200417040.stgit@frogsfrogsfrogs>
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

Orphaned files are defined to be files with nonzero ondisk link count
but no observable parent directory.  This series enables online repair
to reparent orphaned files into the filesystem directory tree, and wires
up this reparenting ability into the directory, file link count, and
parent pointer repair functions.  This is how we fix files with positive
link count that are not reachable through the directory tree.

This patch will also create the orphanage directory (lost+found) if it
is not present.  In contrast to xfs_repair, we follow e2fsck in creating
the lost+found without group or other-owner access to avoid accidental
disclosure of files that were previously hidden by an 0700 directory.
That's silly security, but people have been known to do it.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-orphanage
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir_repair.c    |  129 +++++++++-
 fs/xfs/scrub/nlinks.c        |   11 +
 fs/xfs/scrub/nlinks.h        |    6 
 fs/xfs/scrub/nlinks_repair.c |  129 ++++++++++
 fs/xfs/scrub/orphanage.c     |  539 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.h     |   73 ++++++
 fs/xfs/scrub/parent_repair.c |   94 +++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/scrub.h         |    4 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   81 ++++++
 fs/xfs/xfs_inode.c           |    6 
 fs/xfs/xfs_inode.h           |    1 
 15 files changed, 1054 insertions(+), 25 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h

