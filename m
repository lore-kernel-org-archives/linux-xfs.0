Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA993CA9EBE
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B103321D7F
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUHSrLmj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfJZLSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:18:49 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36838 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfJZLSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Oct 2019 07:18:48 -0400
Received: by mail-pf1-f196.google.com with SMTP id v19so3466939pfm.3;
        Sat, 26 Oct 2019 04:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ZpVYoZ/JyrHVvhweeOK3ctog2JQiFN7vWiPCLmx8Ock=;
        b=CUHSrLmjI1Avz9z5tMvuTJQwCBL1hnrcv/DkizIaytcXui7T297303QF+XfURkxJWj
         n8b8EZIzzuC6wJmyIaHRGN2glgz51FRy76RzTUoo6SXQgYUFbzZJXYASYROV9Jn20VSv
         1Ju1+dq7AehAyotOj1LxGCmORlBUAw+NfMcEhZ3VILyow/EP43wrEll4RgO+tPKaRW9w
         vGgGF3jVtltFzsJZwSItcJFZ1yIm30iEA3mCeTeDKZ+qT82cdxccBQh5dUdi+Srnn8Xz
         JDo7f4YgUaFmyc6iR/Z3L9fgMedm74uANM7EDgq6Snu6pXyIkbvq/RFXE9SA/rdKAtGE
         Egbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ZpVYoZ/JyrHVvhweeOK3ctog2JQiFN7vWiPCLmx8Ock=;
        b=XOEUnlPeVuzW6qkg496yZ6WJXLLdRSD7XF2JdLg/Nz0WjDfwAHDukaX2On4egPaGvt
         8YnSui3hFVkc/NUCQf7uiXcSpfMa03L6mgWOLnCUrQ9P4j8/pGX4iokcfKpw/j7snzpY
         Dp2uD9Vdo1YfZH+CodZdNvO6Yl8VeoJOqkSXeOMe4XWVprIep8bZvkhMrTioN2YyB0E0
         yslNM63YQfkPAEkqRlAYfO0Xgf+ZE/ORoNBACUj5yR65CDGH5nowSthFB+g82LKIw0Mi
         qAqSBZkT+FMuDGgpbkmO7xjsbUiSPd4lq36GLelox3h1z8sDDEY9pmz/nkbNkTnJsBRY
         sAhw==
X-Gm-Message-State: APjAAAXoG/J9Da3hdkUbfkjTfMb2AsFOugQCh6qmfP2E1PH7xOE6A8RQ
        64bcFEHKqsFEwi2FMMSzuMvncvQ=
X-Google-Smtp-Source: APXvYqwUqxj3GKleIGnDWXO8qIoJKtD4TD28GTlVd6zxCEWEpKr1I0PxFk5EvHQhq7b4BWDzJ66Kfg==
X-Received: by 2002:a17:90a:a005:: with SMTP id q5mr10241046pjp.104.1572088727906;
        Sat, 26 Oct 2019 04:18:47 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y2sm6104534pfe.126.2019.10.26.04.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 04:18:47 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v2 1/4] fsstress: show the real file id and parid in rename_f()
Date:   Sat, 26 Oct 2019 19:18:35 +0800
Message-Id: <02ad456bedf5a9c8e2c4c969953a1e19fed5670e.1572057903.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The source file id and parentid are overwritten by del_from_flist()
call, and should show the actually values.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 ltp/fsstress.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 51976f5..95285f1 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -4227,6 +4227,7 @@ rename_f(int opno, long r)
 	pathname_t	newf;
 	int		oldid;
 	int		parid;
+	int		oldparid;
 	int		v;
 	int		v1;
 
@@ -4265,10 +4266,12 @@ rename_f(int opno, long r)
 	if (e == 0) {
 		int xattr_counter = fep->xattr_counter;
 
-		if (flp - flist == FT_DIR) {
-			oldid = fep->id;
+		oldid = fep->id;
+		oldparid = fep->parent;
+
+		if (flp - flist == FT_DIR)
 			fix_parent(oldid, id);
-		}
+
 		del_from_flist(flp - flist, fep - flp->fents);
 		add_to_flist(flp - flist, id, parid, xattr_counter);
 	}
@@ -4277,7 +4280,7 @@ rename_f(int opno, long r)
 			newf.path, e);
 		if (e == 0) {
 			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
-				procid, opno, fep->id, fep->parent);
+				procid, opno, oldid, oldparid);
 			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
 				procid, opno, id, parid);
 		}
-- 
1.8.3.1

