Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8CAC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiL3XIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbiL3XIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:08:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596CE5FFD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:08:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E896861BA9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D266C433EF;
        Fri, 30 Dec 2022 23:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441727;
        bh=60MiCl++8GPRSBDZG8XBHn1PUgUFzsKtgWxDCN01EQw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kLUUZbBrmN3/4XZCZdmYPvE7DzkIbnlfepNJkrSbegFQNBrfgprnZabmOCClSUmdt
         8ucuImBOq7VylXnGu8+vU3l2FFyXqqFHIeSwnWoOGz6ZO1aewhVzkF1J8HHi59K+2B
         RIcmtZMWkvIZwRHwySIdvXn583tVTgR+47RT5ERNhhDKcjrMuq+kU3fxzb7x1kjO9G
         H2UyU0QamOXV1sWbCkyrtOACDGZZF6szVKbzvVdZnQWWytoAKzOQRLXlv7yd48FBrd
         LELgnGv4s4+lnUYRZNcS4Dir4GO7vTTHbcZXmLx+qgSSr0GfwD0YThKh8rhfTCDT9r
         WVihUpc0YXFRg==
Subject: [PATCHSET v24.0 0/3] xfs: cache xfile pages for better performance
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:32 -0800
Message-ID: <167243847260.701196.16973261353833975727.stgit@magnolia>
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

Congratulations!  You have made it to the final patchset of the main
online fsck feature!  This last series improves the performance of
xfile-backed btrees by teaching the buffer cache to directly map pages
from the xfile.  It also speeds up xfarray operations substantially by
implementing a small page cache to avoid repeated kmap/kunmap calls.
Collectively, these can reduce the runtime of online repair functions by
twenty percent or so.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfile-page-caching

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfile-page-caching
---
 fs/xfs/libxfs/xfs_btree_mem.h  |    6 +
 fs/xfs/libxfs/xfs_rmap_btree.c |    1 
 fs/xfs/scrub/rcbag_btree.c     |    1 
 fs/xfs/scrub/trace.h           |   44 +++++++
 fs/xfs/scrub/xfbtree.c         |   23 +++-
 fs/xfs/scrub/xfile.c           |  254 +++++++++++++++++++++++-----------------
 fs/xfs/scrub/xfile.h           |   15 ++
 fs/xfs/xfs_buf.c               |  229 +++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_buf.h               |   10 ++
 9 files changed, 467 insertions(+), 116 deletions(-)

