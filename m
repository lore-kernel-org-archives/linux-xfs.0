Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F807C001DE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjHDRMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjHDRMi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:12:38 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5062C1994
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:12:37 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HCR6v019434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169149; bh=C/Ph+/Avetyv8HA/q92MFB1ewIYFyQlOsYNTmTFVCeA=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=L7RfizdoaIxTh7pSa+VYv8flhkBm6sIZM+vrl+LfAyDz2qPAPf/v7H6/x3Ku8qRxi
         /C+9UTu8XBptRX8m5W5IWd+qD4jslYLzYyMZNwPtZ9U1gdXzoxRBbBAsqp/S3hRb6R
         ibViebJn7Z/hqE2irANPVhmJPdWqA5AZO9L7WKQp5HXLjI2UArfgEd7/crume/r0f/
         XVJl8lWNkfYTvKg1YMb4qVGO3y4xVVRQUxHLz3VdCnwJIoMgpAi+y2NplAQvECzXEH
         zEXCG1hnUalbBqvUrmgwL29KnR4FDjKMdPUEh5b2cAhmq2AArTwC0yTYkHlt1cEof6
         276JuI5lWVVQA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0323C15C04F5; Fri,  4 Aug 2023 13:12:27 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com,
        Hironori Shiina <shiina.hironori@gmail.com>,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: [PATCH CANDIDATE v6.1 5/5] xfs: get root inode correctly at bulkstat
Date:   Fri,  4 Aug 2023 13:12:23 -0400
Message-Id: <20230804171223.1393045-5-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171223.1393045-1-tytso@mit.edu>
References: <20230804171223.1393045-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Hironori Shiina <shiina.hironori@gmail.com>

The root inode number should be set to `breq->startino` for getting stat
information of the root when XFS_BULK_IREQ_SPECIAL_ROOT is used.
Otherwise, the inode search is started from 1
(XFS_BULK_IREQ_SPECIAL_ROOT) and the inode with the lowest number in a
filesystem is returned.

Fixes: bf3cb3944792 ("xfs: allow single bulkstat of special inodes")
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit 817644fa4525258992f17fecf4f1d6cdd2e1b731)
---
 fs/xfs/xfs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..85fbb3b71d1c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -754,7 +754,7 @@ xfs_bulkstat_fmt(
 static int
 xfs_bulk_ireq_setup(
 	struct xfs_mount	*mp,
-	struct xfs_bulk_ireq	*hdr,
+	const struct xfs_bulk_ireq *hdr,
 	struct xfs_ibulk	*breq,
 	void __user		*ubuffer)
 {
@@ -780,7 +780,7 @@ xfs_bulk_ireq_setup(
 
 		switch (hdr->ino) {
 		case XFS_BULK_IREQ_SPECIAL_ROOT:
-			hdr->ino = mp->m_sb.sb_rootino;
+			breq->startino = mp->m_sb.sb_rootino;
 			break;
 		default:
 			return -EINVAL;
-- 
2.31.0

