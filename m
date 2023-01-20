Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A094FC27C7C
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Jan 2023 15:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjATPpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Jan 2023 10:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbjATPpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2023 10:45:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA149764
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 07:45:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA8361FC0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 15:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E26C433D2
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674229516;
        bh=PgDkq2CERyF5RQpHNoMVN6+KV1wHhiBe/L2nFE6fFlE=;
        h=Date:From:To:Subject:From;
        b=aHPR2JdZJxOctEISaBHcQU9p3UPmpuIo1VAr1qAwVm26C3AvOQQIb7Pms5LRcxFF+
         SmLpSTaANyQ2PALteuamEtKJQX/vSWW4V5tTk9VKhMW6pDzrR9ATlgOAMCmLx0q7G9
         S7UhjVjSTQMUWU6TBFe0EMHjlVIcSiMZ/FC5NqZdh3YQMG1e0QGPiroqHngJZD3tT1
         4oaSfy4F4VzKA+Os4muvY7+XCCiSKtYukNFINyh37HyENh9oP6snPUa3QAGKwvagLm
         ouyLBiA01HCqGPXgg7jyQ3Uh6Y0rLfzExJc4Po2ETCOuy4J5ZHWKSNOwHgpf7SC96R
         k164UmE9sG/oQ==
Date:   Fri, 20 Jan 2023 16:45:12 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to d8eab7600
Message-ID: <20230120154512.7przrtsqqyavxuw7@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

d8eab7600f470fbd09013eb90cbc7c5e271da4e5

4 new commits:

Catherine Hoang (2):
      [d9151538d] xfs_io: add fsuuid command
      [e7cd89b2d] xfs_admin: get UUID of mounted filesystem

Dave Chinner (2):
      [0f1291c3b] progs: autoconf fails during debian package builds
      [d8eab7600] progs: just use libtoolize

Code Diffstat:

 Makefile          | 16 +--------------
 db/xfs_admin.sh   | 61 ++++++++++++++++++++++++++++++++++++++++++++++---------
 io/Makefile       |  6 +++---
 io/fsuuid.c       | 49 ++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |  1 +
 io/io.h           |  1 +
 man/man8/xfs_io.8 |  3 +++
 7 files changed, 109 insertions(+), 28 deletions(-)
 create mode 100644 io/fsuuid.c

-- 
Carlos Maiolino
