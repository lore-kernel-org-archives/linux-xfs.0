Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54550C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 23:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237837AbhLHXSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 18:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhLHXSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 18:18:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCA6C061746
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 15:15:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 785ABCE2417
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 23:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C83C00446;
        Wed,  8 Dec 2021 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639005305;
        bh=E5KpBSKMF3XGef+jsfwQqMvET0MFCQ9yvrwgi2Xn+WA=;
        h=Subject:From:To:Cc:Date:From;
        b=ssiX4nrascc5EHSgZqfpGI+ZuyuuZkrqX0NAkhZyFWmb0rZWe4gLxa2uZqrTDNP+r
         5fOvhJXm3aHuGj0LKSQ7W8VDvqgwHz06P2qmxdNmTnr/2v6KFa3wviAUpXO2SpOzv3
         MHImfwlcMB+AhfoUcyAGP29LMG7aUjptcuN0cJHX2aJ/7wix5lpVfgSZlZR5RRUx3F
         dhd8up/CcwPY9wTc0wBuMtQ4wXqF0odDkBP0WZwWpFxVvzD65BGOaX4Xdrw5n8GxPa
         KxqxexagGmZWuJB09+zRl34fMg+QjjTF6wlCTncZ0uQu7H39wb8OQPQ2EEi4D2FtUa
         /CbIJkoKAuXDA==
Subject: [PATCHSET V2 for-5.16 0/2] xfs: fix data corruption when cycling
 ro/rw mounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, wen.gang.wang@oracle.com
Date:   Wed, 08 Dec 2021 15:15:04 -0800
Message-ID: <163900530491.374528.3847809977076817523.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As part of a large customer escalation, I've been combing through the
XFS copy on write code to try to find sources of (mostly) silent data
corruption.  I found a nasty problem in the remount code, wherein a ro
remount can race with file reader threads and fail to clean out cached
inode COW forks.  A subsequent rw remount calls the COW staging extent
recovery code, which frees the space but does not update the records in
the cached inode COW forks.  This leads to massive fs corruption.

The first patch in this series is the critical fix for the race
condition.  The second patch is defensive in that it moves the COW
staging extent recovery so that it always happens at mount time to
protect us against future screwups.

v2: rework comments, move xfs_reflink_recover_cow to xfs_log_mount_finish

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=remount-fixes-5.16
---
 fs/xfs/xfs_log.c     |   23 ++++++++++++++++++++++-
 fs/xfs/xfs_mount.c   |   10 ----------
 fs/xfs/xfs_reflink.c |    5 ++++-
 fs/xfs/xfs_super.c   |   23 +++++++++++------------
 4 files changed, 37 insertions(+), 24 deletions(-)

