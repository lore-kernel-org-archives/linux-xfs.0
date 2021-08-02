Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73129C432BE
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BF3F60EBB
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhHBVul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhHBVul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jWlBM/MV78duAhLTT2oScAQJPZ0iboS6PGETExLUw9A=;
        b=g0kStcPZcuCNXccqGmJ7EBKY7OEJC/shzFkOioK5ss6oGsuEcfCyrmVo30Bjh+NZnN09Sf
        Hl4/Nna/hW/ojbbo9yHh/swiVX0h4OuN3HXjEbRx7KEU4OCg/a3Fr85Koq9Zk6fiuN5/3C
        +uUnm+C/2+yVP+15dWGgVZanRlVwJBU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-4wIUQXAmNF2UbWiUT0uQ4A-1; Mon, 02 Aug 2021 17:50:29 -0400
X-MC-Unique: 4wIUQXAmNF2UbWiUT0uQ4A-1
Received: by mail-wm1-f71.google.com with SMTP id 85-20020a1c01580000b02902511869b403so169132wmb.8
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWlBM/MV78duAhLTT2oScAQJPZ0iboS6PGETExLUw9A=;
        b=D2IqJ254snyxahqAgGzHtHDs+ru0+/XhCLL09Cnx7OFxjcZPC/GTBI7KzM8Vb/0hd8
         TWXlYX4irM5weUxV3vlSMatTsC1baLtCvlJM/2z2LTb66ld9iexOLg0g+hqy8rf2jHy1
         TkqUqMARC9dTfMQC39qlIby5ficKz3Oej5dJglWqOpd5qFeoPH8l+gzRpKNKpHo/fjcq
         qYgRvH+LCN3OH6tLCcBmkm09HqA1isOgPmmJSIqj8CLlf8f6VIYrQDB4rc4MAwbeFBZN
         89550FQdVTyfhZCr+d17cXn86wD9Axiga7oIkTmdxmINLmc7FiNb8Y6HtMvPpGASNrGV
         8d5w==
X-Gm-Message-State: AOAM531F8UxzpUiq7msxIUTbpI2l5QiyFld1h9sBBgaSWfRigJiLaD3l
        +IqQZ/dcQ8+8XadPxb0FCyxnKLZFnI8PnDjcuBOze9mVHp+BH9KdJT0DTMjcA4fNCUvyUmpdlUt
        ns009BzpTlJWL9i43EZyXmdxoWFtYtzPHwGd9pbLg1u9BCzWeGyBEHh7QnjKCuaGFYyJv7H4=
X-Received: by 2002:a5d:5147:: with SMTP id u7mr19750097wrt.181.1627941028148;
        Mon, 02 Aug 2021 14:50:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHacHogk+S1/VlAdwZZeGv7FlqkAQH3VFo/CWTjwdbuF8smQ6Ef4OfIwK7vVoglrUStlEE2w==
X-Received: by 2002:a5d:5147:: with SMTP id u7mr19750084wrt.181.1627941027899;
        Mon, 02 Aug 2021 14:50:27 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:27 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfsprogs: remove platform_uuid_compare()
Date:   Mon,  2 Aug 2021 23:50:19 +0200
Message-Id: <20210802215024.949616-4-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c      | 2 +-
 db/sb.c              | 2 +-
 include/linux.h      | 5 -----
 libxfs/libxfs_priv.h | 2 +-
 libxlog/util.c       | 2 +-
 repair/agheader.c    | 4 ++--
 repair/attr_repair.c | 2 +-
 repair/dinode.c      | 6 +++---
 repair/phase6.c      | 2 +-
 repair/scan.c        | 4 ++--
 10 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index c80b42d1..2a17bf38 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -15,7 +15,7 @@
 #include "libfrog/common.h"
 
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
diff --git a/include/linux.h b/include/linux.h
index a22f7812..9c7ea189 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -85,11 +85,6 @@ static __inline__ void platform_getoptreset(void)
 	optind = 0;
 }
 
-static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
-{
-	return uuid_compare(*uu1, *uu2);
-}
-
 static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 {
 	uuid_unparse(*uu, buffer);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2815c79f..22b4f606 100644
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

