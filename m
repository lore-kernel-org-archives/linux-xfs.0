Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D60C04FDF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 17:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbjHDRLT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbjHDRLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 13:11:00 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D279A4C1F
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 10:10:49 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-112-100.bstnma.fios.verizon.net [173.48.112.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 374HAW18018483
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Aug 2023 13:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1691169034; bh=H03LCI/Mqx0dtR/ofulsXH0jrCyGFENesVehINbkeoE=;
        h=From:Subject:Date:Message-Id:MIME-Version;
        b=GIvIk1sPCwjEMNZqJs3nVfaPwrxMC7RfrDqET8bdY6lStAXw7QEgRQyHo2i560tob
         0ypJlLUWfnjc1aQA7HoJMzNFKKPOfGJEIYrmU0fXk9IX/fvrnJq0H4+uXFFPlZ4aHc
         0XwnFTexjImfuVDYg21qR70UiJxdH62/KhvAd1kziZ0tHJ0UwBIqDbFKKfMekFFMNp
         GR50Z077JK+KiEG6qcjHm3hVKJvkPFTIy3HYyNl12H7kN02pxaQLXP4PiCt8Dzm06f
         dDp4SObnlmqxJWNxEezHMZUuPHJ+wBIdcItA8shy4xKe/BKd3UimsXi6Bxod0EbIm0
         K4ddSgTIEo1fw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0C26F15C04F7; Fri,  4 Aug 2023 13:10:30 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, djwong@kernel.org, chandan.babu@oracle.com,
        leah.rumancik@gmail.com,
        Hironori Shiina <shiina.hironori@gmail.com>,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: [PATCH CANDIDATE v5.15 7/9] xfs: get root inode correctly at bulkstat
Date:   Fri,  4 Aug 2023 13:10:17 -0400
Message-Id: <20230804171019.1392900-7-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230804171019.1392900-1-tytso@mit.edu>
References: <20230802205747.GE358316@mit.edu>
 <20230804171019.1392900-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Hironori Shiina <shiina.hironori@gmail.com>

commit 817644fa4525258992f17fecf4f1d6cdd2e1b731 upstream.

The root inode number should be set to `breq->startino` for getting stat
information of the root when XFS_BULK_IREQ_SPECIAL_ROOT is used.
Otherwise, the inode search is started from 1
(XFS_BULK_IREQ_SPECIAL_ROOT) and the inode with the lowest number in a
filesystem is returned.

Fixes: bf3cb3944792 ("xfs: allow single bulkstat of special inodes")
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bcc3c18c8080..17037c2b2daf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -834,7 +834,7 @@ xfs_bulkstat_fmt(
 static int
 xfs_bulk_ireq_setup(
 	struct xfs_mount	*mp,
-	struct xfs_bulk_ireq	*hdr,
+	const struct xfs_bulk_ireq *hdr,
 	struct xfs_ibulk	*breq,
 	void __user		*ubuffer)
 {
@@ -860,7 +860,7 @@ xfs_bulk_ireq_setup(
 
 		switch (hdr->ino) {
 		case XFS_BULK_IREQ_SPECIAL_ROOT:
-			hdr->ino = mp->m_sb.sb_rootino;
+			breq->startino = mp->m_sb.sb_rootino;
 			break;
 		default:
 			return -EINVAL;
-- 
2.31.0

