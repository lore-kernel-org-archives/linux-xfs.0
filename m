Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D321FEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjG0WSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjG0WSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:18:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A97187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1847B61F57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782FFC433C9;
        Thu, 27 Jul 2023 22:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496328;
        bh=PyFrGrj6637YP7X8znaPrKjPyabhGbMTh5/y1OBk5n0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jzZaOUG86X4r5sDORwqVAlNFibdgHG6KlmI12LAAsns0HtMeVwB540NH8Q5zV7Zix
         gciRc75poMACWY8utcijC/6JtQKMzZmUqiz2LX6D3RCH5HvB9No3r3W7r7pfGUqu+o
         dwscVK0GcGqWkssRMtfjt4Xp2YXIwE+6mP2MSAM3shTzOpgCw1CIqpPa9aEwrZ56A3
         OiFy5uAB1zY25z31WOqbjSILgfOGtbcjIijuzE5BCREYDB6Q0Kf7dgQLyfH01p4AYt
         ogFwkor3LhkmtyOu3t1hxI2oc7+MzbcEFw15CYl+fWsiIoWxGKf5jwdIGsk4lrFTbm
         3yTG50nuY0s+A==
Date:   Thu, 27 Jul 2023 15:18:48 -0700
Subject: [PATCHSET v26.0 0/6] xfs: prepare repair for bulk loading
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Before we start merging the online repair functions, let's improve the
bulk loading code a bit.  First, we need to fix a misinteraction between
the AIL and the btree bulkloader wherein the delwri at the end of the
bulk load fails to queue a buffer for writeback if it happens to be on
the AIL list.

Second, we introduce EFIs in the btree bulkloader block allocator to to
guarantee that staging blocks are freed if the filesystem goes down
before committing the new btree.

Third, we change the bulkloader itself to copy multiple records into a
block if possible, and add some debugging knobs so that developers can
control the slack factors, just like they can do for xfs_repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-prep-for-bulk-loading

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-prep-for-bulk-loading
---
 fs/xfs/Makefile                   |    1 
 fs/xfs/libxfs/xfs_btree.c         |    2 
 fs/xfs/libxfs/xfs_btree.h         |    3 
 fs/xfs/libxfs/xfs_btree_staging.c |   67 +++-
 fs/xfs/libxfs/xfs_btree_staging.h |   32 +-
 fs/xfs/scrub/agheader_repair.c    |    1 
 fs/xfs/scrub/common.c             |    1 
 fs/xfs/scrub/newbt.c              |  629 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h              |   66 ++++
 fs/xfs/scrub/repair.c             |   10 +
 fs/xfs/scrub/repair.h             |    1 
 fs/xfs/scrub/scrub.c              |    2 
 fs/xfs/scrub/trace.h              |   37 ++
 fs/xfs/xfs_buf.c                  |   47 +++
 fs/xfs/xfs_buf.h                  |    1 
 fs/xfs/xfs_globals.c              |   12 +
 fs/xfs/xfs_sysctl.h               |    2 
 fs/xfs/xfs_sysfs.c                |   54 +++
 18 files changed, 931 insertions(+), 37 deletions(-)
 create mode 100644 fs/xfs/scrub/newbt.c
 create mode 100644 fs/xfs/scrub/newbt.h

