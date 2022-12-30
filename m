Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75B0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiL3XCx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3XCv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:02:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9CD15FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:02:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E44D1CE1924
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4BFC433EF;
        Fri, 30 Dec 2022 23:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441367;
        bh=IIHiSK9oG8mUny5nCWq3cir1NcqCTsjjCK3sEiyuKCE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=anO96mvnEsHhSzRSMCTHuSPp1reDAPTBFblWsRszsb8JqmR81eY1gZX/Fmw/0bf22
         WBPVJDe03iE6Dv/g8u6E04Ju7YFQ5EaLoT/clqxlsE2jyJn/yqiu3avT0jl555AU1n
         ZyV16Ov3IShTiXt53GvCxNg3QWUe0l2Nl9HTOym+io0MyxxIcPOZj558MB7Tov6cI1
         H51oTRc0J3W60cC/l+mrDNcDn7LjXaho9PePPiFDXf6mC7TXLvUUClHsfuzqhA6XkN
         DcFUYxKykyPcS8M6WKe6gohs8JqM3SUxsXIo+CTmf+mWCvB081ZmI7t4aokU+88hPo
         u/8s1q2eIofDw==
Subject: [PATCHSET v24.0 0/5] xfs: online repair of quota counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:06 -0800
Message-ID: <167243838686.695667.4884256571173103690.stgit@magnolia>
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

This series uses the inode scanner and live update hook functionality
introduced in the last patchset to implement quotacheck on a live
filesystem.  The quotacheck scrubber builds an incore copy of the
dquot resource usage counters and compares it to the live dquots to
report discrepancies.

If the user chooses to repair the quota counters, the repair function
visits each incore dquot to update the counts from the live information.
The live update hooks are key to keeping the incore copy up to date.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quotacheck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quotacheck
---
 fs/xfs/Makefile                  |    2 
 fs/xfs/libxfs/xfs_fs.h           |    4 
 fs/xfs/libxfs/xfs_health.h       |    4 
 fs/xfs/scrub/common.c            |   47 ++
 fs/xfs/scrub/common.h            |   11 
 fs/xfs/scrub/health.c            |    1 
 fs/xfs/scrub/quotacheck.c        |  840 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quotacheck.h        |   76 +++
 fs/xfs/scrub/quotacheck_repair.c |  254 +++++++++++
 fs/xfs/scrub/repair.c            |   46 ++
 fs/xfs/scrub/repair.h            |    5 
 fs/xfs/scrub/scrub.c             |    9 
 fs/xfs/scrub/scrub.h             |   10 
 fs/xfs/scrub/trace.h             |   32 +
 fs/xfs/scrub/xfarray.h           |   19 +
 fs/xfs/xfs_health.c              |    1 
 fs/xfs/xfs_inode.c               |   21 +
 fs/xfs/xfs_inode.h               |    3 
 fs/xfs/xfs_qm.c                  |   23 +
 fs/xfs/xfs_qm.h                  |   16 +
 fs/xfs/xfs_qm_bhv.c              |    1 
 fs/xfs/xfs_quota.h               |   45 ++
 fs/xfs/xfs_trans_dquot.c         |  158 +++++++
 23 files changed, 1604 insertions(+), 24 deletions(-)
 create mode 100644 fs/xfs/scrub/quotacheck.c
 create mode 100644 fs/xfs/scrub/quotacheck.h
 create mode 100644 fs/xfs/scrub/quotacheck_repair.c

