Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977A2C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjEZAhS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjEZAhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:37:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD319194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 706CE64C0C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D601BC433EF;
        Fri, 26 May 2023 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061435;
        bh=2uP8RfdHZSo4bSwasnmzoKo/QChtNPfhoNg7CVzE+t0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lMB2DIr9AxsemUrzvai9OB3Y3Z7KBZoTkj5WuBmNC3brkM64929XCqPZhEBjM1HL5
         wcTu717fYPY/DCAFjsonCZ4si61hDVJNOgbqaKlkGp5/1Wd+vfCjioM5V3fnSJX99g
         h5PA5dP+yCt280K4QlXjlAyfHIkoLgG1UOi3cD98KMgqDoomp7KuL+Ly50aTBGrsoq
         EqKCwjjefwq8xV1dbCSn2YHZz6ozcMWZ57eyxyoVAaIaF7jBcJqLZacUKrRhS8qWqH
         NpIGthB7X8E1FsV8epUnPKKqGZHOXG/81a6ykQWMPYkXjT6+x580BBsjJR0of1Z7LX
         uefewzcTF7q7g==
Date:   Thu, 25 May 2023 17:37:15 -0700
Subject: [PATCHSET v25.0 0/3] xfs: cache xfile pages for better performance
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069009.3738195.8548151008033051712.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset improves the performance of xfile-backed btrees by
teaching the buffer cache to directly map pages from the xfile.  It also
speeds up xfarray operations substantially by implementing a small page
cache to avoid repeated kmap/kunmap calls.  Collectively, these can
reduce the runtime of online repair functions by twenty percent or so.

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
 fs/xfs/scrub/trace.h           |   44 ++++++
 fs/xfs/scrub/xfbtree.c         |   23 +++
 fs/xfs/scrub/xfile.c           |  307 ++++++++++++++++++++++++++--------------
 fs/xfs/scrub/xfile.h           |   23 +++
 fs/xfs/xfs_buf.c               |  116 ++++++++++++---
 fs/xfs/xfs_buf.h               |   16 ++
 fs/xfs/xfs_buf_xfile.c         |  173 +++++++++++++++++++++++
 fs/xfs/xfs_buf_xfile.h         |   11 +
 11 files changed, 584 insertions(+), 137 deletions(-)

