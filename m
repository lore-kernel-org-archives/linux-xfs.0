Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F779C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiL3XJX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XJW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:09:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322C72DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4793B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CE8C433EF;
        Fri, 30 Dec 2022 23:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441758;
        bh=vchIlao1xPh6A/IeF7ElsfTz26oDR3UqaS1XKiq656g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i+/2cgYj5+h1TvoCZlHwm9l+DD7d3327D2LJor8PEw9B4yfm+o+XnCCAbkv92d/bC
         ku5yU57upvsX7qt8J7jF1suXi0KEk2sCIxHyfNK2D9FmIR2Q5rJ21h+B/BYtGciSx+
         fNThGIx7NR7iBg30wQ6NvbWBtTRhz71nuRgpU3RWhBygCw+EXtDCMvHtRabytQZQIK
         Pvq+ou1N12WkbbkrSarUTiTBfGkt/cRaPzJaoYFD4TRKIFrqeVk8y2gJUk3HiuloHj
         t7W2x8YgPw8UMi3NsY2ODAtcHHRQv1G61MczEMYPbjqqN9K30s5KSs1B+ONjXrM7J0
         yfPaZtqR4PjuA==
Subject: [PATCHSET v24.0 0/3] libxfs: force rebuilding of metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:22 -0800
Message-ID: <167243864252.707991.14471233385651088983.stgit@magnolia>
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

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
---
 io/scrub.c                          |   22 ++++++++++++-----
 libxfs/xfs_fs.h                     |    6 ++++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    5 ++++
 man/man8/xfs_io.8                   |    3 ++
 scrub/phase1.c                      |   28 ++++++++++++++++++++++
 scrub/scrub.c                       |   45 ++++++++++++++++++-----------------
 scrub/scrub.h                       |    1 +
 scrub/xfs_scrub.c                   |    3 ++
 scrub/xfs_scrub.h                   |    1 +
 9 files changed, 84 insertions(+), 30 deletions(-)

