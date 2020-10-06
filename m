Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6406C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CA39208B8
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:06:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MMH1n4io"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgJFWGv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 18:06:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:49920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJFWGu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 18:06:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602022009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnm/RxjxxLUME/GR8BrjHta9dgC5NNQZGJISf0VuXKA=;
        b=MMH1n4io0O6O4eHFizvdwRUjOgQTi+YsJnmBfQEUouAaN9iKO+UcoPpR13DH4NdGoVexqL
        IwhxoaQHbmZzI5aigXqyQlwsJG4Ts5Z3kFkz35eomuIOs4lnzENZeuroyo/P0VAajTUTR6
        cqQnGKMvilX8flIOyy8bTxDTmIJA4mk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5128FB031;
        Tue,  6 Oct 2020 22:06:49 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfsdump: remove obsolete code for handling xenix named pipes
Date:   Wed,  7 Oct 2020 00:07:04 +0200
Message-Id: <20201006220704.31157-3-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201006220704.31157-1-ailiop@suse.com>
References: <20201006220704.31157-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can safely drop support for XENIX named pipes (S_IFNAM) at this
point, since this was never implemented in Linux.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 doc/files.obj     | 2 +-
 doc/xfsdump.html  | 1 -
 dump/content.c    | 3 ---
 dump/inomap.c     | 3 ---
 restore/content.c | 8 --------
 5 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/doc/files.obj b/doc/files.obj
index 4f4653ac56fc..098620e356da 100644
--- a/doc/files.obj
+++ b/doc/files.obj
@@ -295,7 +295,7 @@ minilines(486,15,0,0,0,0,0,[
 mini_line(486,12,3,0,0,0,[
 str_block(0,486,12,3,0,-4,0,0,0,[
 str_seg('black','Courier',0,80640,486,12,3,0,-4,0,0,0,0,0,
-	"Other File (S_IFCHAR|S_IFBLK|S_IFIFO|S_IFNAM|S_IFSOCK)")])
+	"Other File (S_IFCHAR|S_IFBLK|S_IFIFO|S_IFSOCK)")])
 ])
 ])]).
 text('black',48,244,2,0,1,54,30,379,12,3,0,0,0,0,2,54,30,0,0,"",0,0,0,0,256,'',[
diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index 9d06129a5e1d..958bc8055bef 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -100,7 +100,6 @@ or stdout. The dump includes all the filesystem objects of:
 <li>character special files (S_IFCHR)
 <li>block special files (S_IFBLK)
 <li>named pipes (S_FIFO)
-<li>XENIX named pipes (S_IFNAM) 
 </ul>
 It does not dump files from <i>/var/xfsdump</i> which is where the
 xfsdump inventory is located.
diff --git a/dump/content.c b/dump/content.c
index 7637fe89609e..75b79220daf6 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -3883,9 +3883,6 @@ dump_file(void *arg1,
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFIFO:
-#ifdef S_IFNAM
-	case S_IFNAM:
-#endif
 	case S_IFLNK:
 	case S_IFSOCK:
 		/* only need a filehdr_t; no data
diff --git a/dump/inomap.c b/dump/inomap.c
index 85f76df606a9..85d61c353cf0 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1723,9 +1723,6 @@ estimate_dump_space(struct xfs_bstat *statp)
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFDIR:
-#ifdef S_IFNAM
-	case S_IFNAM:
-#endif
 	case S_IFBLK:
 	case S_IFSOCK:
 	case S_IFLNK:
diff --git a/restore/content.c b/restore/content.c
index 6b22965bd894..97f821322960 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -7313,9 +7313,6 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
 		case S_IFBLK:
 		case S_IFCHR:
 		case S_IFIFO:
-#ifdef S_IFNAM
-		case S_IFNAM:
-#endif
 		case S_IFSOCK:
 			ok = restore_spec(fhdrp, rvp, path1);
 			return ok;
@@ -7797,11 +7794,6 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
 	case S_IFIFO:
 		printstr = _("named pipe");
 		break;
-#ifdef S_IFNAM
-	case S_IFNAM:
-		printstr = _("XENIX named pipe");
-		break;
-#endif
 	case S_IFSOCK:
 		printstr = _("UNIX domain socket");
 		break;
-- 
2.28.0

