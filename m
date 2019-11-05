Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8A8CA9ED5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64F96218BA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lfwUTtRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfKECld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:41:33 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46420 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729717AbfKECld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 21:41:33 -0500
Received: by mail-pg1-f195.google.com with SMTP id f19so12909931pgn.13;
        Mon, 04 Nov 2019 18:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f1f0vDscinwQtWcesf13Q2HxOIzoI+V95YhD2P5lQ4k=;
        b=lfwUTtRnMc/ahhwW/SyMKlDB8soPe3v4yDRpYSX6KvSG5krK22826He7VKVVvUDjrJ
         BtqdScNpsyOMYo0RXuhLHkQrA8MY0ufkp47+sMsBCYIC+ljHNnAidFIpicz+hTShxuYB
         yWoxZHVWD5MOCjr3qeWYgciONmKujY2npPdlvlryUgWI7CIfup6UzqqLBn7d56ghzOQ4
         GsUcaDtFtblUZ+WsAfEEDRCq9vPYQGvrH4MHGzvxEhowW1pWW9SZ+3C+hUWDQAUKj+qS
         CNrTQWMmo5G/ZrF6lj7JW7cWjMrHQEqPfOgsm93dAAtpmcr8W97YE0FDkBGWTxuKF9oR
         RXzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f1f0vDscinwQtWcesf13Q2HxOIzoI+V95YhD2P5lQ4k=;
        b=PzvUdPXGexwemXH08gHeYpyFzK1ZLiFmETWvNSpFikXoDClGYRd1nXHWbcUJJB1w/3
         J00V4T9+mzLb7lMxx7H23pEzsM0DhBADcZJ4xt5Y8eIi6+kFoSV8J0tGdGruexjJCivx
         BFLoSOayf0Yn43rLiFj7ft3vnQ0bs/9cLnGqQVGcS3GAPpAQKyZeBmWQ77ZWX5ZumuKE
         cLakl44Eg+mRCJDoOHcdC7MSJC4LVbfRoswpulVPhGFutkLF4iN6ttram9rehvNRIUhR
         AwNcnkQictF/wuBbqVs3RucJLAAFm/D6AvjIM0Joz8kuEB+66yGmjqdXrE9RK+teOPTW
         VKHQ==
X-Gm-Message-State: APjAAAVgM8zDUaBLrClz2qQ/4nsoaYJizzN1cyz2VcMbCRAYL/WJefnu
        q1KOThqMZiC6L8JgUinpR1Rdh3Y=
X-Google-Smtp-Source: APXvYqx7rxZyryLcopEOy4EEbyXfmPrih1cM1zXM2mWlqO7+TWz2jVG63NVigivzxZ0z6bT76wQEgg==
X-Received: by 2002:a62:fb15:: with SMTP id x21mr33281798pfm.79.1572921691203;
        Mon, 04 Nov 2019 18:41:31 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id j25sm16199535pfi.113.2019.11.04.18.41.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 18:41:30 -0800 (PST)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH] fsstress: show the real file id and parid in rmdir() and unlink()
Date:   Tue,  5 Nov 2019 10:41:26 +0800
Message-Id: <1572921686-3441-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The source file id and parentid are overwritten by del_from_flist()
call, so should show the actually values.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 ltp/fsstress.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 0125571..9f5ec1d 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -4499,6 +4499,8 @@ rmdir_f(int opno, long r)
 	int		e;
 	pathname_t	f;
 	fent_t		*fep;
+	int		oldid;
+	int		oldparid;
 	int		v;
 
 	init_pathname(&f);
@@ -4510,13 +4512,16 @@ rmdir_f(int opno, long r)
 	}
 	e = rmdir_path(&f) < 0 ? errno : 0;
 	check_cwd();
-	if (e == 0)
+	if (e == 0) {
+		oldid = fep->id;
+		oldparid = fep->parent;
 		del_from_flist(FT_DIR, fep - flist[FT_DIR].fents);
+	}
 	if (v) {
 		printf("%d/%d: rmdir %s %d\n", procid, opno, f.path, e);
 		if (e == 0)
 			printf("%d/%d: rmdir del entry: id=%d,parent=%d\n",
-				procid, opno, fep->id, fep->parent);
+				procid, opno, oldid, oldparid);
 	}
 	free_pathname(&f);
 }
@@ -4746,6 +4751,8 @@ unlink_f(int opno, long r)
 	pathname_t	f;
 	fent_t		*fep;
 	flist_t		*flp;
+	int		oldid;
+	int		oldparid;
 	int		v;
 
 	init_pathname(&f);
@@ -4757,13 +4764,16 @@ unlink_f(int opno, long r)
 	}
 	e = unlink_path(&f) < 0 ? errno : 0;
 	check_cwd();
-	if (e == 0)
+	if (e == 0) {
+		oldid = fep->id;
+		oldparid = fep->parent;
 		del_from_flist(flp - flist, fep - flp->fents);
+	}
 	if (v) {
 		printf("%d/%d: unlink %s %d\n", procid, opno, f.path, e);
 		if (e == 0)
 			printf("%d/%d: unlink del entry: id=%d,parent=%d\n",
-				procid, opno, fep->id, fep->parent);
+				procid, opno, oldid, oldparid);
 	}
 	free_pathname(&f);
 }
-- 
1.8.3.1

