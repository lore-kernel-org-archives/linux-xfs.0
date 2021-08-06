Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCE7C4320A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6104960E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhHFVXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239689AbhHFVXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GrSKFhdhNfcWWR+6qo9Dyv+AZX5XL7h1JGUiG8mbJe4=;
        b=XWx6+feLJmDWEEmH5Y9KlePIUJmgpvwmcLRIP7EqIw2lK7HRTsC486hfcQm1J+qZj47I+C
        VaU07BRGMuOuBYAJXl8oUQcLPESMqHmwgs8LlZ1HvZ5lDYa1He63m/A+g28IlBM+yedx5x
        W/fkyeYH/b5pXRlqICrBpmWpj0Lep7U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-CBtgNbrEPZWn6YkdOD3x_Q-1; Fri, 06 Aug 2021 17:23:23 -0400
X-MC-Unique: CBtgNbrEPZWn6YkdOD3x_Q-1
Received: by mail-ed1-f69.google.com with SMTP id dn10-20020a05640222eab02903bd023ea9f6so5554850edb.14
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GrSKFhdhNfcWWR+6qo9Dyv+AZX5XL7h1JGUiG8mbJe4=;
        b=iy8CJXnASWPL+x2iR1H0KUnKt955xwTx5+XOUWYgvp5+ALrFhfVkgSZxmAHxZi5o0x
         daD1EOipnnOlyLmkolVCsnIDcOucUfeF6ZHdN4lpZnC/LKCZC9Wyi7jt6NheKvDCX9fD
         ilc+RjGo1+1oBU7al6PvaQg5VMJOtPC9dAtnGlssnJhuPHeivhSEoOlxynmqz7PbxVw9
         nomUVfRgxxOzfgMCCLxa1y6qbecPhQZAbn6n5cOPgDq1nriVOTpCmKLYBRQenwMDfQM4
         96OTpX2/aF4Bwh6yGl7odpWb4jrtkoS0/h6dl5LbRBYmQZLmtiWKSZ6haWDMieYlkr6j
         Al3w==
X-Gm-Message-State: AOAM5311upsyLysMiA6q9FJx3oTk4nJfmLkQoJB7qltQsQqa6MHhqn4x
        pcg+yed1kWLHZJIbbHPaU+8EB7Q+i27nqp1RIywchGXYWOJXZkN0Jfh98fa1QkHiMKnV39ZOAe3
        42/AP6ouTbaUSFva7Jum7wQf/ZOWYWQGb166i6mvkUE+TDUj6+FDX3+O3PjFPz0SMO3jmkMM=
X-Received: by 2002:a05:6402:1202:: with SMTP id c2mr15314625edw.216.1628285002556;
        Fri, 06 Aug 2021 14:23:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCZUW6VM8IKaCrjkjNR/55M9jBSPs2iMKPruNsZkPN23ZSTNGIzq8eEhhmjoGbH5hFMaB24w==
X-Received: by 2002:a05:6402:1202:: with SMTP id c2mr15314616edw.216.1628285002379;
        Fri, 06 Aug 2021 14:23:22 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.21
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:21 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 01/29] xfsprogs: Stop using platform_uuid_compare()
Date:   Fri,  6 Aug 2021 23:22:50 +0200
Message-Id: <20210806212318.440144-2-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

platform_uuid_compare() only calls uuid_compare() thus in should be
replaced by uuid_compare() deprecated and removed in the future.
---
 copy/xfs_copy.c      | 2 +-
 db/sb.c              | 2 +-
 libxfs/libxfs_priv.h | 2 +-
 libxlog/util.c       | 2 +-
 repair/agheader.c    | 4 ++--
 repair/attr_repair.c | 2 +-
 repair/dinode.c      | 6 +++---
 repair/phase6.c      | 2 +-
 repair/scan.c        | 4 ++--
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fc7d225f..841ab7e4 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -15,7 +15,7 @@
 #include "libfrog/platform.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
-#define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
+#define uuid_equal(s,d) (uuid_compare((*s),(*d)) == 0)
 
 extern int	platform_check_ismounted(char *, char *, struct stat *, int);
 
diff --git a/db/sb.c b/db/sb.c
index cec7dce9..7017e1e5 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -17,7 +17,7 @@
 #include "output.h"
 #include "init.h"
 
-#define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
+#define uuid_equal(s,d)		(uuid_compare((*s),(*d)) == 0)
 
 static int	sb_f(int argc, char **argv);
 static void     sb_help(void);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e37d5933..782bb006 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -505,7 +505,7 @@ static inline int retzero(void) { return 0; }
 #define xfs_qm_dqattach(i)			(0)
 
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
-#define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
+#define uuid_equal(s,d)		(uuid_compare((*s),(*d)) == 0)
 
 #define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
diff --git a/libxlog/util.c b/libxlog/util.c
index a85d70c9..b4dfeca0 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -76,7 +76,7 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
 
     if (print_skip_uuid)
 		return 0;
-    if (!platform_uuid_compare(&mp->m_sb.sb_uuid, &head->h_fs_uuid))
+    if (!uuid_compare(mp->m_sb.sb_uuid, head->h_fs_uuid))
 		return 0;
 
     platform_uuid_unparse(&mp->m_sb.sb_uuid, uu_sb);
diff --git a/repair/agheader.c b/repair/agheader.c
index 2af24106..1c4138e4 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -100,7 +100,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return retval;
 
-	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid)) {
+	if (uuid_compare(agf->agf_uuid, mp->m_sb.sb_meta_uuid)) {
 		char uu[64];
 
 		retval = XR_AG_AGF;
@@ -179,7 +179,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return retval;
 
-	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid)) {
+	if (uuid_compare(agi->agi_uuid, mp->m_sb.sb_meta_uuid)) {
 		char uu[64];
 
 		retval = XR_AG_AGI;
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index bc3c2bef..25bdff73 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -947,7 +947,7 @@ _("expected block %" PRIu64 ", got %llu, inode %" PRIu64 "attr block\n"),
 		return 1;
 	}
 	/* verify uuid */
-	if (platform_uuid_compare(&info->uuid, &mp->m_sb.sb_meta_uuid) != 0) {
+	if (uuid_compare(info->uuid, mp->m_sb.sb_meta_uuid) != 0) {
 		do_warn(
 _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
 			ino, bp->b_bn);
diff --git a/repair/dinode.c b/repair/dinode.c
index 291c5807..a6156830 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1098,7 +1098,7 @@ null_check(char *name, int length)
  * This does /not/ do quotacheck, it validates the basic quota
  * inode metadata, checksums, etc.
  */
-#define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
+#define uuid_equal(s,d) (uuid_compare((*s),(*d)) == 0)
 static int
 process_quota_inode(
 	struct xfs_mount	*mp,
@@ -2329,8 +2329,8 @@ _("inode identifier %llu mismatch on inode %" PRIu64 "\n"),
 				return 1;
 			goto clear_bad_out;
 		}
-		if (platform_uuid_compare(&dino->di_uuid,
-					  &mp->m_sb.sb_meta_uuid)) {
+		if (uuid_compare(dino->di_uuid,
+				mp->m_sb.sb_meta_uuid)) {
 			if (!uncertain)
 				do_warn(
 			_("UUID mismatch on inode %" PRIu64 "\n"), lino);
diff --git a/repair/phase6.c b/repair/phase6.c
index 6bddfefa..05e6a321 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1886,7 +1886,7 @@ _("expected block %" PRIu64 ", got %llu, directory inode %" PRIu64 "\n"),
 		return 1;
 	}
 	/* verify uuid */
-	if (platform_uuid_compare(uuid, &mp->m_sb.sb_meta_uuid) != 0) {
+	if (uuid_compare(*uuid, mp->m_sb.sb_meta_uuid) != 0) {
 		do_warn(
 _("wrong FS UUID, directory inode %" PRIu64 " block %" PRIu64 "\n"),
 			ino, bp->b_bn);
diff --git a/repair/scan.c b/repair/scan.c
index 2c25af57..361c3b3c 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -268,8 +268,8 @@ _("expected block %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
 			return 1;
 		}
 		/* verify uuid */
-		if (platform_uuid_compare(&block->bb_u.l.bb_uuid,
-					  &mp->m_sb.sb_meta_uuid) != 0) {
+		if (uuid_compare(block->bb_u.l.bb_uuid,
+			mp->m_sb.sb_meta_uuid) != 0) {
 			do_warn(
 _("wrong FS UUID, bmbt block %" PRIu64 "\n"),
 				bno);
-- 
2.31.1

