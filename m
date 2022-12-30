Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948F6C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbiL3XMs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiL3XMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:12:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CD11D0C0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:12:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82DB5B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3748BC433D2;
        Fri, 30 Dec 2022 23:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441964;
        bh=prGCuuXKr9PY1/sFwss/lYDOIDFz6OBcpcosGnFsxe0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ckvSzRfM8ozu5PzTbGY5THyMHH9QVRRleLWaMSLXIp8rdXg0coBe7pIknui+IzU3M
         hxuXnIX0jI3IUL7+xnH09YEJpGoldsKCQ0ylea6p3TT0IzKPDuE68LRl+zOOAcBsI7
         wh3abqY6PoCxXirH7JNgLu/L/8R9RuRaglRO/KUFv+oIUftZtynyB1OATQLYVA18FD
         xCwqBCVqPdSQ9kjNeYS4zn5sdN5LUn+AZcFO/Ftq+5bPQtsf8qH+HDNt3LocXeJVxA
         hUHe14aRe3tqelB3F/1nvRjxAWM2DI8BZ/IkpOG17XZ5DWcphQWey09XxRdohKPZ9c
         L7f7quXTIeNWA==
Subject: [PATCHSET v24.0 0/1] xfs: cache xfile pages for better performance
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:07 -0800
Message-ID: <167243868750.714598.6299645052246352439.stgit@magnolia>
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
 libxfs/xfs_btree_mem.h  |    6 ++++++
 libxfs/xfs_rmap_btree.c |    1 +
 2 files changed, 7 insertions(+)

