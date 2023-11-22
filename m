Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2095C61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjKVXGx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjKVXGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:06:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB26101
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:06:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3EAC433C8;
        Wed, 22 Nov 2023 23:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694408;
        bh=D7acxMYGJ72vGK6WSKcJe58f9ewiH90F4lysxZpQjGU=;
        h=Subject:From:To:Cc:Date:From;
        b=XhV0voKRrPEpqa3SEr8DyeQk+ro8dE30luDWYuj9Qm6eMIpl+srP6pgtCHXsPgMvJ
         GzUYAORhfxrEaaq/l1hx+7BwpitZcgxHcXZlM4DKB0uCw2uUXMVea+QrNHpsVhIkSC
         y6C9LOYnqwAMuOHUsQTha3It6ZhuyYJMMXLv+artoTyPZb51Jg7YxjoW+VLIySnd4n
         QFwDzoH4bvZr97ITplCUf2lDmwSJ1ReT+aL4ikjWZiTaIc9AurLp8NsfAn/jAotdIm
         xyYguXhVHxQUBfEd/Vf2/KCjSDKZ/OSagQlteY7lxM8Dc3XVA3HK35ATtw6tCPRzLu
         KXznwlG6PJOcQ==
Subject: [PATCHSET 0/9] xfsprogs: minor fixes for 6.6
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:06:48 -0800
Message-ID: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes some bugs that I and others have found in the
userspace tools.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 copy/xfs_copy.c           |   10 +++--
 db/block.c                |   14 ++++++-
 db/io.c                   |   35 +++++++++++++++-
 db/io.h                   |    3 +
 include/libxfs.h          |    1 
 libfrog/Makefile          |    1 
 libfrog/div64.h           |   96 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/defer_item.c       |    7 +++
 libxfs/libxfs_priv.h      |   77 ------------------------------------
 man/man8/xfs_mdrestore.8  |    6 ++-
 man/man8/xfs_metadump.8   |    7 ++-
 mdrestore/xfs_mdrestore.c |   46 +++++++++++++---------
 12 files changed, 198 insertions(+), 105 deletions(-)
 create mode 100644 libfrog/div64.h

