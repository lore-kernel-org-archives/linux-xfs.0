Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55998C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiEXFg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiEXFgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7547010FF5
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C769B81763
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEE9C34116;
        Tue, 24 May 2022 05:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370580;
        bh=+IO4QV2sfhUTmnMorZAdCkzwu8ZRtRhvbot0kRJYm0E=;
        h=Subject:From:To:Cc:Date:From;
        b=rcRVepdGpxrzK6FcuQsK9LF8ocwwjhQ+nMq/yuCc6x9rWHwLkTpnrqGJHA0d4XvKe
         ssFw7AI2ErUR0kI1+8pNfLq5Dm2eq8tvhmoFnPHhu1yY6oMz8cPnGQv08RC2/XEEWM
         f4+J4Q/IbZhLPJD47aG4Mi1eOf8mCP34gc4noUeqa1I5NQ8xCch+UyOFzV2ISLTKxR
         aiYooqsFFZ9Q+CS5k3LD8EuzVgcPbTLElVRrsQrVq5mnH4gwLYdmn0FF2PskvuDTRU
         otClPaDWmPF5uZ4pDMB6hYRfsJ76rQJ6i2oBtwcTtnch5Pw03vJ1fVv+SrGhMgRHZC
         7kpmMOB6/lNsA==
Subject: [PATCHSET v2 0/5] xfs: last pile of LARP cleanups for 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:20 -0700
Message-ID: <165337058023.994444.12794741176651030531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This final series contains a two key cleanups for the new LARP code.
Most of it is refactoring and tweaking the code that creates kernel log
messages about enabling and disabling features -- we should be warning
about LARP being turned on once per day, instead of once per insmod
cycle; we shouldn't be spamming the logs so aggressively about turning
*off* log incompat features.

The second part of the series refactors the LARP code responsible for
getting (and releasing) permission to use xattr log items.  The
implementation code doesn't belong in xfs_log.c, and calls to logging
functions don't belong in libxfs -- they really should be done by the
VFS implementation functions before they start calling into libraries.

v2: use OPSTATE flags so that we warn about scrub/larp/shrink on a
    per-mount basis, and reorganize the log assist rework based on
    feedback

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=larp-cleanups-5.19
---
 fs/xfs/libxfs/xfs_attr.c |   14 +-------
 fs/xfs/scrub/scrub.c     |   17 +---------
 fs/xfs/xfs_acl.c         |    3 +-
 fs/xfs/xfs_fsops.c       |    7 +---
 fs/xfs/xfs_ioctl.c       |    3 +-
 fs/xfs/xfs_iops.c        |    3 +-
 fs/xfs/xfs_log.c         |   41 ------------------------
 fs/xfs/xfs_message.h     |    6 +++
 fs/xfs/xfs_mount.c       |    1 -
 fs/xfs/xfs_mount.h       |   18 ++++++++++
 fs/xfs/xfs_super.c       |    1 +
 fs/xfs/xfs_super.h       |    1 -
 fs/xfs/xfs_xattr.c       |   79 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_xattr.h       |   13 ++++++++
 14 files changed, 126 insertions(+), 81 deletions(-)
 create mode 100644 fs/xfs/xfs_xattr.h

