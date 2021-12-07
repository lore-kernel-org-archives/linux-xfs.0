Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11563C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 18:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbhLGSjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 13:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbhLGSjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 13:39:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59B2C061574
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 10:35:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D326B81DAD
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 18:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5891EC341C1;
        Tue,  7 Dec 2021 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638902140;
        bh=TlIOLPLVfVPu2YJb1yMjlfOW2CryGvwA3q3JPKnOvG0=;
        h=Subject:From:To:Cc:Date:From;
        b=EQwEBtD3aCG3524I6ylcs0Bm+1/PNTcCh3SvdMNDWKp/t/aaqbnvCC2/r1zUBSXey
         QFsgDRKs2E+VXDMpMTVd45LrQ5PGRWWXSWXsKOOxZd3Dakm5R/DlLvKS6JU/RbTWT2
         wcY2N/RoW9daCxrGSx/EnTJTw5jC7XfiQc1p0d8+JCp66uneHrKTpExxvz9tepNX0e
         nRyePkGfc1xOabsJDyPPssavZAQavBuDVA5AIynD7c8d1EiPhDkbzeIcpqGq4BHQDZ
         I9cmbh84rA5m/E8Nf496JJppXuwWyYCgK6zrDCdZT3hhXq5N4tHtJIr2GfMs31Wfh8
         yDpT4tR3pKzrQ==
Subject: [PATCHSET 5.16-rcX 0/2] xfs: fix data corruption when cycling ro/rw
 mounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        wen.gang.wang@oracle.com
Date:   Tue, 07 Dec 2021 10:35:39 -0800
Message-ID: <163890213974.3375879.451653865403812137.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=remount-fixes-5.16
---
 fs/xfs/xfs_mount.c   |   37 ++++++++++++++++++++++++++++---------
 fs/xfs/xfs_reflink.c |    4 +++-
 fs/xfs/xfs_super.c   |   23 +++++++++++------------
 3 files changed, 42 insertions(+), 22 deletions(-)

