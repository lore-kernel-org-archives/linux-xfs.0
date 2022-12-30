Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D089BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiL3XJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:09:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC522DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:09:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EFD061BA9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF27DC433EF;
        Fri, 30 Dec 2022 23:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441743;
        bh=5COw04FTMNDbtzKrAeKojzDMRQzu3yCCxjcaiWy5c28=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bUiJ5hGMvTXl/GBTwNLFdEB8NdHqiePHymvLgVB7aONIvyVyQ4holHvcDNYxo3xXJ
         E3aqJcTtTTagyIYwzp0ol0l2kghF+/7jXaleO/n/Q8+/LKV50J744f2Gencez8ZMl+
         kx6HT7H7wKtakDygcyyzv/T0ZXNLfivMhcIZMelq0d7T9YT/3zUa+6myHQTdIYVw6u
         kUl9j1Avj1usmUs9FZqxVR1n+IfnFK2n9/mPf7Tj2prbpdO+9X44NNC4P33vK3or4u
         Cw4ZcMglhh8ghMVKlo8a+zwBxFijl60t4YbndjyUD2u3YBElDQxlJzM9m52ULlRI2u
         IxnQkWLuMvh7Q==
Subject: [PATCHSET v24.0 0/5] libxfs: prepare repair for bulk loading
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863904.707598.12385476439101029022.stgit@magnolia>
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
 libxfs/libxfs_api_defs.h   |    1 
 libxfs/libxfs_io.h         |   11 +++
 libxfs/xfs_btree.c         |    2 
 libxfs/xfs_btree.h         |    3 +
 libxfs/xfs_btree_staging.c |   67 +++++++++++-----
 libxfs/xfs_btree_staging.h |   32 +++++---
 repair/agbtree.c           |  182 ++++++++++++++++++++++++++++----------------
 7 files changed, 198 insertions(+), 100 deletions(-)

