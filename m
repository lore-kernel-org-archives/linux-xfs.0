Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9D4C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjEZAad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbjEZAac (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:30:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A32419C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC1D6615D4
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161C1C433D2;
        Fri, 26 May 2023 00:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061030;
        bh=3Ib2q2MnO6R7pbcNMCRZA45YU8b9ozdfenuZLKMMQCg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=unvgXw68ogHMMfAzmgZzIAIz4tU0qryPDaAobPePQpL9gpkcr2EIe1np169q0wdi1
         qxcZiEToDLiQaaVsggxNBr3V4zt5w7R7Jlote6MQUkbqusy4CO7URQNIdPRnfkzlpW
         9tp7ynZ+a+uOacakk5fSS2Rt7yvhVjkEXALgFZQqMV6WEl/RxqjHn9X+2XTIGkJyaY
         tgF4iOYV9Z0Uosc24nEPyVlcQzua85QW7b9gOzq8kNeOeU+y3fS3nTQLtiWOQiyTB1
         1fGHkLnYoVJkOPWG8U0KtvYfbLGUDKu5/cRJFmwZciDQ2vlh3ozqRgvwYAAuoOW0j+
         giPmufKccePFw==
Date:   Thu, 25 May 2023 17:30:29 -0700
Subject: [PATCHSET v25.0 0/5] xfs: online repair of file fork mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058705.3730621.6175016885493289346.stgit@frogsfrogsfrogs>
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

In this series, online repair gains the ability to rebuild data and attr
fork mappings from the reverse mapping information.  It is at this point
where we reintroduce the ability to reap file extents.

Repair of CoW forks is a little different -- on disk, CoW staging
extents are owned by the refcount btree and cannot be mapped back to
individual files.  Hence we can only detect staging extents that don't
quite look right (missing reverse mappings, shared staging extents) and
replace them with fresh allocations.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-file-mappings

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-file-mappings

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-file-mappings
---
 fs/xfs/Makefile                   |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c    |  112 +++++
 fs/xfs/libxfs/xfs_bmap_btree.h    |    5 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 -
 fs/xfs/libxfs/xfs_btree_staging.h |    2 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/libxfs/xfs_refcount.c      |   41 ++
 fs/xfs/libxfs/xfs_refcount.h      |   10 
 fs/xfs/scrub/bitmap.h             |   28 +
 fs/xfs/scrub/bmap.c               |   18 +
 fs/xfs/scrub/bmap_repair.c        |  776 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/cow_repair.c         |  609 +++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.c               |  145 +++++++
 fs/xfs/scrub/reap.h               |    2 
 fs/xfs/scrub/repair.c             |   50 ++
 fs/xfs/scrub/repair.h             |   11 +
 fs/xfs/scrub/scrub.c              |   20 -
 fs/xfs/scrub/trace.h              |  118 ++++++
 fs/xfs/xfs_trans.c                |   95 +++++
 fs/xfs/xfs_trans.h                |    4 
 22 files changed, 2041 insertions(+), 45 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/cow_repair.c

