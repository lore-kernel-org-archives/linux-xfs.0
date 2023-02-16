Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67B6C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBPU0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBPU0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:26:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFBC3B0ED
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80DC060C0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA29C433D2;
        Thu, 16 Feb 2023 20:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579200;
        bh=YPWtzd88dtO2h8kYEDX6CWB2bWHd4cA5bv4sPIBvb/g=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lAPamJjgLjQxNaGK4sw79Y+bgb8RsKgHMF3gENby4kEbwaN++3OavGgquNQkAUq9u
         hPMz7HXKgX75NW+s4BflIDbOmks/3tg0vAmQPSTI79RBvKkRcQqXklCaHEI8z0Rjye
         eeCCSGccFCbk1ib62SouqAHzoOcrH/NuD+SDf7x6FpxdQ3+vn6tMgGkoMmHBtsCwcL
         UC3IHgO0G3pQyTi2EariSD5mye74wqdqez52BfASMhduqggUZLq5uEpnIYBIbmYWfH
         F/c/rDFYfcIcrxVsMz3vbxxXrB1+9iWaqnrmgAW+09nJDvwM+hB6v4xyRcsW+1zZ0I
         SlUFBTlFO3TCw==
Date:   Thu, 16 Feb 2023 12:26:40 -0800
Subject: [PATCHSET v9r2d1 0/3] xfs: bug fixes for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873091.3474076.6801004934386808232.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains the accumulated bug fixes from Darrick to make
fstests pass and online repair work.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-bugfixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-bugfixes
---
 fs/xfs/libxfs/xfs_attr.c       |   61 +++++++++-------------------------------
 fs/xfs/libxfs/xfs_attr.h       |    2 +
 fs/xfs/libxfs/xfs_attr_leaf.c  |    6 +++-
 fs/xfs/libxfs/xfs_dir2_block.c |    2 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  |    2 +
 fs/xfs/libxfs/xfs_dir2_node.c  |    2 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |    4 +++
 fs/xfs/libxfs/xfs_parent.c     |   44 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h     |    7 +++++
 9 files changed, 79 insertions(+), 51 deletions(-)

