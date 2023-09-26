Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A062E7F14B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 01:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjI0Bwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 21:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjI0Buo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 21:50:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AE31F9CD
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:30:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5B0C433C7;
        Tue, 26 Sep 2023 23:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771052;
        bh=8KZJuwZAjQcxyxT1mVnFjZKmWDZk76/GlINXjXjfors=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=RfPX7hcut9YeTz2RIrPX/vf096+KVoJwhLPifULp6L/ik3GpxkB1ufi51j4eoYd7E
         NexlgQp6zc5o5TX/aRXDsoSv7ME9Ce6gvrn5Rus71IR7HsGlelhoqoqeieCYxHGfo9
         HVTYHm/b7T0Qm52cLH9JYVid9MufktpmvL5uHM3hQZJDrswvHb/E2nwxU1eqYPcLxz
         cEpzGs0fWbkYQIrQindu0Gtp1K6e3wpw2ktuLUyXwUkVeACOaMBU7E0ZspOIJDL7n6
         MORqHjzEUfHTfq7OZSZnbVBSBVidWfAlBZYZzT3iPTymu0LVVIySp9ijhGdTLk/6yA
         9EYNdnwcRvefA==
Date:   Tue, 26 Sep 2023 16:30:51 -0700
Subject: [PATCHSET v27.0 0/5] xfs: online repair of quota and rt metadata
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
In-Reply-To: <20230926231410.GF11439@frogsfrogsfrogs>
References: <20230926231410.GF11439@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

XFS stores quota records and free space bitmap information in files.
Add the necessary infrastructure to enable repairing metadata inodes and
their forks, and then make it so that we can repair the file metadata
for the rtbitmap.  Repairing the bitmap contents (and the summary file)
is left for subsequent patchsets.

We also add the ability to repair file metadata the quota files.  As
part of these repairs, we also reinitialize the ondisk dquot records as
necessary to get the incore dquots working.  We can also correct
obviously bad dquot record attributes, but we leave checking the
resource usage counts for the next patchsets.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quota

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quota

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quota
---
 fs/xfs/Makefile             |    9 +
 fs/xfs/libxfs/xfs_format.h  |    3 
 fs/xfs/scrub/dqiterate.c    |  211 ++++++++++++++++
 fs/xfs/scrub/quota.c        |  107 +++++++-
 fs/xfs/scrub/quota.h        |   36 +++
 fs/xfs/scrub/quota_repair.c |  572 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h       |    7 +
 fs/xfs/scrub/scrub.c        |    6 
 fs/xfs/scrub/trace.c        |    3 
 fs/xfs/scrub/trace.h        |   78 ++++++
 fs/xfs/xfs_dquot.c          |   37 ---
 fs/xfs/xfs_dquot.h          |    8 -
 12 files changed, 1023 insertions(+), 54 deletions(-)
 create mode 100644 fs/xfs/scrub/dqiterate.c
 create mode 100644 fs/xfs/scrub/quota.h
 create mode 100644 fs/xfs/scrub/quota_repair.c

