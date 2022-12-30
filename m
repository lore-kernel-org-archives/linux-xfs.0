Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406ACC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbiL3XAN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiL3XAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:00:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C2C1CFC9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D36061C16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A95C433EF;
        Fri, 30 Dec 2022 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441211;
        bh=hdYisSbn85PkE0srC+bjqKVg8SPysmBvsq7xlFN0WD0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uwboQPIiaURQj3hCHmHfllUqkz4fPUl78/S3vOp8bUqdiKgx7NZy9AUZMhSmgvzl8
         9lrAENHnw6+QAWF9xpxybbubA2Xi5732MRESgZee3lQYyLr1jVkLuS00aZCgIhzGOA
         e7wjXu9+j/2ZOGMoKT+5uaInVt58vC2Os1KC7+IVUe7ORG+KlGpWIO1r5vU0kKLIyy
         daHp3SMrBLk03ShwrruEczQ+vwysPCTNMUojHlVOsrSlikhoxtKaSmZ+chvfx3qRIS
         +tMcn6UcCS3U2c79MdjYgNFSZ8n9OiEwZqNg3UdNFkV9KGG4JG9T2Y197qIxKZsAaE
         qzTsLmZ6OPp1g==
Subject: [PATCHSET v24.0 0/6] xfs: prepare repair for bulk loading
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:31 -0800
Message-ID: <167243835101.692312.6690367712200502185.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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
 fs/xfs/scrub/newbt.c              |  567 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h              |   68 ++++
 fs/xfs/scrub/repair.c             |   10 +
 fs/xfs/scrub/repair.h             |    1 
 fs/xfs/scrub/scrub.c              |    2 
 fs/xfs/scrub/trace.h              |   36 ++
 fs/xfs/xfs_buf.c                  |   31 ++
 fs/xfs/xfs_buf.h                  |    1 
 fs/xfs/xfs_globals.c              |   12 +
 fs/xfs/xfs_sysctl.h               |    2 
 fs/xfs/xfs_sysfs.c                |   54 ++++
 18 files changed, 858 insertions(+), 33 deletions(-)
 create mode 100644 fs/xfs/scrub/newbt.c
 create mode 100644 fs/xfs/scrub/newbt.h

