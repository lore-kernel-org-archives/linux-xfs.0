Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875D4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiLaDVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:21:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA426383
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD060B81E6E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C2FC433EF;
        Sat, 31 Dec 2022 03:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456868;
        bh=l8WUGkRBo+ZoQL4nG6IpQmVyWo2od4yTSfPxiR3MtPc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sbZYkydaBw9JY1/xkKQdlwEKJuyIk3/6h+V3jC0HUtEnL7wfyIVjdKRM209v9lB3g
         s3GoO3yjikGx9rmOL5ik8u1Yke3HdU7W9uX0P9h8RWMkBUGgSDsbY6w0Rlp/l23CSu
         HyJBABro2Z+ErbO9yV83ntdvPsoi8PawZyOKOzGLxoCY4isR4MF95G/gZmv48YH0q0
         1X6bg8vrQ9e4TLcd1vNQ6ETU33czfoQSLZM6IjJox2xdJ9kT+QyiaaNvrhcW7/u0mc
         ag1KCdz43vlSRuWHyL3J6qHtjPxUxBrfJOyywhg7sevIg19wIKFvILpCQGsjF75/2p
         NlSyqABflMrSw==
Subject: [PATCHSET 00/11] xfs_scrub: vectorize kernel calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884029.739244.16777239536975047510.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
 include/xfs_trans.h   |    4 
 io/scrub.c            |  485 +++++++++++++++++++++++++++++++++++++++++--------
 libfrog/fsgeom.h      |    6 +
 libfrog/scrub.c       |  124 +++++++++++++
 libfrog/scrub.h       |    1 
 libxfs/xfs_defer.c    |   14 +
 libxfs/xfs_fs.h       |   37 ++++
 man/man8/xfs_io.8     |   47 +++++
 scrub/phase1.c        |    2 
 scrub/phase2.c        |  106 +++++++++--
 scrub/phase3.c        |   84 +++++++-
 scrub/repair.c        |  347 ++++++++++++++++++++++-------------
 scrub/scrub.c         |  353 ++++++++++++++++++++++++++----------
 scrub/scrub.h         |   19 ++
 scrub/scrub_private.h |   62 ++++--
 15 files changed, 1344 insertions(+), 347 deletions(-)

