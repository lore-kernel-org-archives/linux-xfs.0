Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936045AbeFNWQv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 18:16:51 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D45A4BDD1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jun 2018 22:16:51 +0000 (UTC)
From: Marco Benatto <mbenatto@redhat.com>
Subject: [PATCH] xfs_repair: Fix root inode's parent when it's bogus for sf directory
Date: Thu, 14 Jun 2018 19:16:46 -0300
Message-Id: <20180614221646.20017-1-mbenatto@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: mbenatto@redhat.com, sandeen@redhat.com

Currently when root inode is in short-form and its parent ino
has an invalid value, process_sf_dir2() ends up not fixing it,
because if verify_inum() fails we never get to the next case which
would fix the root inode's parent pointer.

This behavior triggers the following assert on process_dir2():

   ASSERT((ino != mp->m_sb.sb_rootino && ino != *parent) ||
        (ino == mp->m_sb.sb_rootino &&
        (ino == *parent || need_root_dotdot == 1)));

This patch fixes this behavior by making sure we always properly
handle rootino parent pointer in process_sf_dir2()

Signed-off-by: Marco Benatto <mbenatto@redhat.com>
---
 repair/dir2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index e162d2b..225f926 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -495,8 +495,10 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
 
 	/*
 	 * if parent entry is bogus, null it out.  we'll fix it later .
+	 * If the validation fails for the root inode we fix it in
+	 * the next else case.
 	 */
-	if (verify_inum(mp, *parent))  {
+	if (verify_inum(mp, *parent) && ino != mp->m_sb.sb_rootino)  {
 
 		do_warn(
 _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
-- 
2.9.5

