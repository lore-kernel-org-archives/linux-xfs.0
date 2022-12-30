Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97769C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiLaBAB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaBAB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:00:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEAC1C913
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1670B81DEF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FD7C433D2;
        Sat, 31 Dec 2022 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448397;
        bh=6PsiESqP3Cu5st0i1k6JFAbzivCio8aUm+ET0gs61hw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lxqGBQ9JuNKkIxaQtVAbzH1B7b9ttYehFbTFvF6LUJuNV7tuy9vr9/2sR1OWsBog1
         doCppgc53jdcT+E1LcSWXEAeUrXwp6AmG0cbpJoKGg3R9NjaLHJa64X9P2FszGCb8n
         bFlv+DmZKH5eJuP4Yil2HvVED98fD9pK11IPu+JImRkBKKmvJ0EGGdOWoz/grK4xTp
         RDUlnwIjboxuP/z+W+6YgtJwK1V6Pqh/8SRDfSEnnzPXzksnpt/jZQscMddUnmnFd+
         pImzja7/8YtxLh5pdd1wx41rqd6n+C6qGXwb2I+xjyr8X6kma+grXCdNtKiqyXP+//
         O+e71S2zxDtUw==
Subject: [PATCHSET v1.0 00/26] libxfs: hoist inode operations to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:13 -0800
Message-ID: <167243875315.723621.17759760420120912799.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add libxfs code from the kernel from the inode refactoring, then fix up
xfs_repair and mkfs to use library functions instead of open-coding
inode (re)creation.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-refactor
---
 db/sb.c                   |    4 
 include/libxfs.h          |    1 
 include/xfs_inode.h       |   85 ++++--
 include/xfs_mount.h       |    1 
 include/xfs_trace.h       |    6 
 libxfs/Makefile           |    5 
 libxfs/inode.c            |  279 ++++++++++++++++++
 libxfs/iunlink.c          |  126 ++++++++
 libxfs/iunlink.h          |   22 +
 libxfs/libxfs_api_defs.h  |    7 
 libxfs/libxfs_priv.h      |   36 ++
 libxfs/rdwr.c             |   87 ------
 libxfs/util.c             |  282 ------------------
 libxfs/xfs_bmap.c         |   42 +++
 libxfs/xfs_bmap.h         |    3 
 libxfs/xfs_dir2.c         |  480 +++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h         |   19 +
 libxfs/xfs_format.h       |    9 -
 libxfs/xfs_ialloc.c       |   20 +
 libxfs/xfs_inode_util.c   |  695 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h   |   79 +++++
 libxfs/xfs_shared.h       |    7 
 libxfs/xfs_trans_inode.c  |    2 
 mdrestore/xfs_mdrestore.c |    6 
 mkfs/proto.c              |   94 +++++-
 repair/agheader.c         |   12 -
 repair/phase6.c           |  199 ++++---------
 27 files changed, 2037 insertions(+), 571 deletions(-)
 create mode 100644 libxfs/inode.c
 create mode 100644 libxfs/iunlink.c
 create mode 100644 libxfs/iunlink.h
 create mode 100644 libxfs/xfs_inode_util.c
 create mode 100644 libxfs/xfs_inode_util.h

