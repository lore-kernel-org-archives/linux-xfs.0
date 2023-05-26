Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA6CC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjEZAa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjEZAa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B77E194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB258615D4
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58765C433D2;
        Fri, 26 May 2023 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061014;
        bh=aGX74VXLiiwKKXsRrC1S555BqA2KxATWDM1rbmo1d8U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=f4RSBPQACoMDWqS/UfveUjwMcNZxRYRa/UCn2HDqGGZJY7UtJgPAtKUNkJT3SfTn/
         Uvwn7L9k9SyrfJlw0coV8Scn/h9EFfFyPu4wL7M/0B/gHGeKxxrW1oRFPGiXIIkV9Q
         akeHEEDNG5O27MzxeUi2PCB8JQhLfGQxX1VP5bBSjr6V6r3khVuWH5uS4bKndDXLpH
         EML8jVgvZKPXQOVDP4Y/QjNLJeKQE/Y9P/Y+X3DvX8e76rYAZoEye43xSG0IyoCLxe
         OY9GHcBj62hknxZqv0y9hJI+KvN/dqtZByYZ3r50Xj+obEvuzxgDxFjS+satWYNOaB
         Go8Dpva52Lfsg==
Date:   Thu, 25 May 2023 17:30:13 -0700
Subject: [PATCHSET v25.0 0/6] xfs: online repair of inodes and forks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058301.3730405.12262241466147528228.stgit@frogsfrogsfrogs>
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

In this series, online repair gains the ability to repair inode records.
To do this, we must repair the ondisk inode and fork information enough
to pass the iget verifiers and hence make the inode igettable again.
Once that's done, we can perform higher level repairs on the incore
inode.  The fstests counterpart of this patchset implements stress
testing of repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inodes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-inodes
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_attr_leaf.c      |   32 -
 fs/xfs/libxfs/xfs_attr_leaf.h      |    2 
 fs/xfs/libxfs/xfs_bmap.c           |   22 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    2 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   29 -
 fs/xfs/libxfs/xfs_format.h         |    3 
 fs/xfs/libxfs/xfs_shared.h         |    1 
 fs/xfs/libxfs/xfs_symlink_remote.c |   21 
 fs/xfs/scrub/alloc.c               |    2 
 fs/xfs/scrub/bmap.c                |    4 
 fs/xfs/scrub/common.c              |   26 +
 fs/xfs/scrub/common.h              |    8 
 fs/xfs/scrub/dir.c                 |   21 
 fs/xfs/scrub/inode.c               |   14 
 fs/xfs/scrub/inode_repair.c        | 1618 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c              |   10 
 fs/xfs/scrub/repair.c              |   47 +
 fs/xfs/scrub/repair.h              |   28 +
 fs/xfs/scrub/rtbitmap.c            |    4 
 fs/xfs/scrub/rtsummary.c           |    4 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |  174 ++++
 24 files changed, 2034 insertions(+), 43 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c

