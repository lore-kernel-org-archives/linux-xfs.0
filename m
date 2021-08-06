Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB302C4320E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB5660EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbhHFVXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239926AbhHFVXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5JmAK8RMhKNzbrNJ28is0kF+GcJou77diUltXqS3GI=;
        b=ZZxHxu4LhEtFRGjptdlw/x8fCQx609a75Q1LwKqhF18y+ZmEI+lg4gk/aZkpDDVgHXQM3e
        LnWqZ0Zrq8aVO+w8riBYDTR9IGqrnjiVn61S5IPHQFfcVZasCl+ZOWeGRSiZggO7tUlLWw
        ePoVYVxhUmhv6D5SxsSTrUTlOA8Q02A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-Q-3NAPL4ODyEncFDqEu_wg-1; Fri, 06 Aug 2021 17:23:33 -0400
X-MC-Unique: Q-3NAPL4ODyEncFDqEu_wg-1
Received: by mail-ed1-f71.google.com with SMTP id eg53-20020a05640228b5b02903bd6e6f620cso5595529edb.23
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L5JmAK8RMhKNzbrNJ28is0kF+GcJou77diUltXqS3GI=;
        b=J3eVbu47LKhvL2ST90PQ9EdUrVHaDzz5n4JRhnlbmMbrNzvnJpmlpIwIasFMCg0wOF
         +hj7kfQj6fRpZr6Sm6hSU0x6l82lmvTH85WqnhyJ0h4r+pd4Yh7HZGz9GFRPlKsD77o9
         nFLXCSsdAtBJXT7DV6FbWNwGCqyh1uoI6mDJegDMzNcssq0i2t2osEMyg4xbWFLkIz/b
         ts1J6FsRQwaSqiBX8I1ez/TgO8Phdbi3e5pEt3sATkRNzoMC0I3lXUGdzp9qZ3XY6T6o
         yg3kRuXHTHPOwnsaCI4VjzmeOYEFcBVM20x826jF0jZT2faMuQMDe1bhQWqnhRLtQVqk
         j0sg==
X-Gm-Message-State: AOAM533hNFgr7MKOHk2B6mr2IvvbE6tj5lK0XuffzqFwZ6hQZUg8ALjz
        e3LPcaWd+N1KxV8FnneUfYikKN04kXUJTPrL993w8DE0aFV9Na729+KnRdaCjAJZ2JQX8kW2Zvw
        CTmpG+eq5060YAakQ9HlszlIKgs+NE3uc0yRnIki5JUS/I3opOIgQV2lamNX5N+18dT2kMdY=
X-Received: by 2002:aa7:cdcf:: with SMTP id h15mr15531490edw.45.1628285011670;
        Fri, 06 Aug 2021 14:23:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqe065/+kLq10Zfddn09608rZv0hW2EF0UkhKq6HOQfzEmxALHO9sxGJ+jGiSoMCr9fau0DQ==
X-Received: by 2002:aa7:cdcf:: with SMTP id h15mr15531467edw.45.1628285011410;
        Fri, 06 Aug 2021 14:23:31 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:30 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 08/29] xfsprogs: Stop using platform_uuid_unparse()
Date:   Fri,  6 Aug 2021 23:22:57 +0200
Message-Id: <20210806212318.440144-9-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 db/fprint.c         | 2 +-
 db/sb.c             | 6 +++---
 libxlog/util.c      | 4 ++--
 logprint/log_misc.c | 2 +-
 repair/agheader.c   | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/db/fprint.c b/db/fprint.c
index 65accfda..f2f42c28 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -273,7 +273,7 @@ fp_uuid(
 	     i++, p++) {
 		if (array)
 			dbprintf("%d:", i + base);
-		platform_uuid_unparse(p, bp);
+		uuid_unparse(*p, bp);
 		dbprintf("%s", bp);
 		if (i < count - 1)
 			dbprintf(" ");
diff --git a/db/sb.c b/db/sb.c
index b668fc68..4e4b1f57 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -396,7 +396,7 @@ uuid_f(
 				return 0;
 			}
 			memcpy(&uu, uup, sizeof(uuid_t));
-			platform_uuid_unparse(&uu, bp);
+			uuid_unparse(uu, bp);
 			dbprintf(_("old UUID = %s\n"), bp);
 		} else if (!strcasecmp(argv[1], "restore")) {
 			xfs_sb_t	tsb;
@@ -427,7 +427,7 @@ uuid_f(
 				break;
 			}
 
-		platform_uuid_unparse(&uu, bp);
+		uuid_unparse(uu, bp);
 		dbprintf(_("new UUID = %s\n"), bp);
 		return 0;
 
@@ -460,7 +460,7 @@ uuid_f(
 				 "for FS with an external log\n"));
 		}
 
-		platform_uuid_unparse(&uu, bp);
+		uuid_unparse(uu, bp);
 		dbprintf(_("UUID = %s\n"), bp);
 	}
 
diff --git a/libxlog/util.c b/libxlog/util.c
index b4dfeca0..7c10474b 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -79,8 +79,8 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
     if (!uuid_compare(mp->m_sb.sb_uuid, head->h_fs_uuid))
 		return 0;
 
-    platform_uuid_unparse(&mp->m_sb.sb_uuid, uu_sb);
-    platform_uuid_unparse(&head->h_fs_uuid, uu_log);
+    uuid_unparse(mp->m_sb.sb_uuid, uu_sb);
+    uuid_unparse(head->h_fs_uuid, uu_log);
 
     printf(_("* ERROR: mismatched uuid in log\n"
 	     "*            SB : %s\n*            log: %s\n"),
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index afcd2cee..c593c828 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1082,7 +1082,7 @@ xlog_print_rec_head(xlog_rec_header_t *head, int *len, int bad_hdr_warn)
 	printf("\n");
     }
 
-    platform_uuid_unparse(&head->h_fs_uuid, uub);
+    uuid_unparse(head->h_fs_uuid, uub);
     printf(_("uuid: %s   format: "), uub);
     switch (be32_to_cpu(head->h_fmt)) {
 	case XLOG_FMT_UNKNOWN:
diff --git a/repair/agheader.c b/repair/agheader.c
index b13b7323..7e596a66 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -104,7 +104,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 		char uu[64];
 
 		retval = XR_AG_AGF;
-		platform_uuid_unparse(&agf->agf_uuid, uu);
+		uuid_unparse(agf->agf_uuid, uu);
 		do_warn(_("bad uuid %s for agf %d\n"), uu, i);
 
 		if (!no_modify)
@@ -183,7 +183,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 		char uu[64];
 
 		retval = XR_AG_AGI;
-		platform_uuid_unparse(&agi->agi_uuid, uu);
+		uuid_unparse(agi->agi_uuid, uu);
 		do_warn(_("bad uuid %s for agi %d\n"), uu, agno);
 
 		if (!no_modify)
-- 
2.31.1

