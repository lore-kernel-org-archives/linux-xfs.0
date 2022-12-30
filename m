Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1D7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbiL3XIV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiL3XIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:08:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994201D0EC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:08:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F166B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E918C433EF;
        Fri, 30 Dec 2022 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441696;
        bh=i2Tzi2UNVdqJ3fBxTroTkIwPH1ezRTNIa4uBqBSj5sM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ABxhxLT4ZD+YvTXz5Luewy3zVsTTd4Bi3M8URRW/AijTGfj/KtXfaxlhIini/Eiem
         ChRiYwKPPbJ0Bs/Ez+xdC0nzMX7Axc1RVQUPB8nCelbcF2jjbvmuK0BccZObcc1bkz
         q15VorhliFNx5zSRjLRE0kksX/gSO/+PUSeGH4pbm/XF2AZsv9TEpW5qT+s/FLgyfN
         WhUFYUrt4AePLwr5koBhD+PmmPmmH91abgV2bQQaNRlI4l4ufHB27X3QKq8aLhS39V
         PLBym/+7oiYBPlXO65AeaejV0OezkQZpOxpQERlbqOypXL9yzPZcoo3va1UfyaFsdR
         +z4BnEtoRaSxQ==
Subject: [PATCHSET v24.0 0/1] xfs: online repair of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:26 -0800
Message-ID: <167243846597.700977.16776611507583639102.stgit@magnolia>
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

This is the jumping-off point for rebuilding parent pointer information
and reconstructing directories with parent pointers.  The parent pointer
feature hasn't been merged yet, so this branch contains only a single
patch that refactors the xattr walking code in preparation for that.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-parent-pointers
---
 fs/xfs/Makefile          |    1 
 fs/xfs/scrub/attr.c      |  114 ++++++-----------
 fs/xfs/scrub/listxattr.c |  306 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/listxattr.h |   16 ++
 4 files changed, 364 insertions(+), 73 deletions(-)
 create mode 100644 fs/xfs/scrub/listxattr.c
 create mode 100644 fs/xfs/scrub/listxattr.h

