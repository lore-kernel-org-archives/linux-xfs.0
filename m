Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13154C83F18
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbjH2XEj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240454AbjH2XEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7446BE9
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 065296395F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B0AC433C8;
        Tue, 29 Aug 2023 23:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350251;
        bh=jyD+0FGZ5G0zw0ed6mpPMui3D5tP3jqfxgZYiLroWgg=;
        h=Subject:From:To:Cc:Date:From;
        b=G+qa0nc9LTncQP4bGyaKKGdTUxt9oVwCrNgngRywXzHUcZJqWC1hBuLxw9WXhZ0FG
         knJIJqLkwaCOUvUyWg1Cko6YTcGfK8xvGiJ7AAdBuamfDvREvZsw87YtlcN2L/QEm9
         wpoO8LO7Awaj/MG8p4enF2fSLeLamz3vfnK299v0s3d6YKbGafK4Q6ClWyimIVmNjl
         TP0ym5byOSJ1FKTqX6vMZnausOGcHn2OiaoPT8tT1s/8u50+gRff0hotyT5Q0FwY5t
         xlVrlavyzuS8f4m4R2keIuYLL1X6xJbw8UBiY8rYx3qpOHOpoq8dbzgr9Ln6ThBHw9
         SX1AjYZwNy+Bw==
Subject: [PATCHSET v2 0/1] xfs: fix fsmap cursor handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Date:   Tue, 29 Aug 2023 16:04:10 -0700
Message-ID: <169335025080.3518128.2053884391855690989.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset addresses an integer overflow bug that Dave Chinner found
in how fsmap handles figuring out where in the record set we left off
when userspace calls back after the first call filled up all the
designated record space.

v2: add RVB tags

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-fsmap-6.6
---
 fs/xfs/xfs_fsmap.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

