Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B836EC41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 10:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C4F82080A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 10:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q7iXjRq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgJFKBj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 06:01:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:44050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJFKBi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 06:01:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601978497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KDPcZMwJBAEJWwjXvAozHYWm583pWa4rz+STmD4L1yM=;
        b=Q7iXjRq4P1eaaoqEFEZMscsRQT7hWSiDbJZGsthwH3xMzgrBofZRNOYDOrlsEAglEgcV0F
        PdJ871V8Y6ZVq+khieSZ3SAi0oHwqwmz5s3CGbWmQct8EvAj5H2+o/lPHPdmzLq5Mr0pjX
        r9Azaxv0bUpsfrhRT8s8PXY9d1/cGZc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1358EB214;
        Tue,  6 Oct 2020 10:01:37 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_repair: remove obsolete code for handling mountpoint inodes
Date:   Tue,  6 Oct 2020 12:01:49 +0200
Message-Id: <20201006100149.32740-1-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The S_IFMNT file type was never supported in Linux, remove the related
code that was supposed to deal with it, along with the translation file
entries.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 po/de.po        |  5 -----
 po/pl.po        |  5 -----
 repair/dinode.c | 12 ------------
 repair/incore.h |  1 -
 4 files changed, 23 deletions(-)

diff --git a/po/de.po b/po/de.po
index fab26677e258..aa9af769ab89 100644
--- a/po/de.po
+++ b/po/de.po
@@ -11774,11 +11774,6 @@ msgstr ""
 msgid "component of symlink in inode %llu too long\n"
 msgstr "Bestandteil des symbolischen Verweises in Inode %llu zu lang\n"
 
-#: .././repair/dinode.c:1611
-#, c-format
-msgid "inode %llu has bad inode type (IFMNT)\n"
-msgstr "Inode %llu hat falschen Inode-Typ (IFMNT)\n"
-
 #: .././repair/dinode.c:1621
 #, c-format
 msgid "size of character device inode %llu != 0 (%lld bytes)\n"
diff --git a/po/pl.po b/po/pl.po
index 87109f6b41d2..0076e7a75b05 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -11712,11 +11712,6 @@ msgstr ""
 "znaleziono niedozwolony znak null w i-węźle dowiązania symbolicznego "
 "%<PRIu64>\n"
 
-#: .././repair/dinode.c:1452
-#, c-format
-msgid "inode %<PRIu64> has bad inode type (IFMNT)\n"
-msgstr "i-węzeł %<PRIu64> ma błędny typ i-węzła (IFMNT)\n"
-
 #: .././repair/dinode.c:1463
 #, c-format
 msgid "size of character device inode %<PRIu64> != 0 (%<PRId64> bytes)\n"
diff --git a/repair/dinode.c b/repair/dinode.c
index d552db2d5f1a..4abf83ec4173 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1334,17 +1334,6 @@ process_misc_ino_types(xfs_mount_t	*mp,
 			xfs_ino_t	lino,
 			int		type)
 {
-	/*
-	 * disallow mountpoint inodes until such time as the
-	 * kernel actually allows them to be created (will
-	 * probably require a superblock version rev, sigh).
-	 */
-	if (type == XR_INO_MOUNTPOINT)  {
-		do_warn(
-_("inode %" PRIu64 " has bad inode type (IFMNT)\n"), lino);
-		return(1);
-	}
-
 	/*
 	 * must also have a zero size
 	 */
@@ -1630,7 +1619,6 @@ _("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
 	case XR_INO_CHRDEV:	/* fall through to FIFO case ... */
 	case XR_INO_BLKDEV:	/* fall through to FIFO case ... */
 	case XR_INO_SOCK:	/* fall through to FIFO case ... */
-	case XR_INO_MOUNTPOINT:	/* fall through to FIFO case ... */
 	case XR_INO_FIFO:
 		if (process_misc_ino_types(mp, dino, lino, type))
 			return 1;
diff --git a/repair/incore.h b/repair/incore.h
index 5b29d5d1efd8..074ca98a3989 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -214,7 +214,6 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_BLKDEV	8		/* block device */
 #define XR_INO_SOCK	9		/* socket */
 #define XR_INO_FIFO	10		/* fifo */
-#define XR_INO_MOUNTPOINT 11		/* mountpoint */
 #define XR_INO_UQUOTA	12		/* user quota inode */
 #define XR_INO_GQUOTA	13		/* group quota inode */
 #define XR_INO_PQUOTA	14		/* project quota inode */
-- 
2.28.0

