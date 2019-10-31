Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EBECA9ECB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 06:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59FB5208E3
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 06:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qr0JneEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfJaGl4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Oct 2019 02:41:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36323 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfJaGl4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 02:41:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id j22so3336706pgh.3;
        Wed, 30 Oct 2019 23:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ZpVYoZ/JyrHVvhweeOK3ctog2JQiFN7vWiPCLmx8Ock=;
        b=qr0JneEwnTT1aN9VK75Ma8A1WQe1yVBVDTsBiEO9FU3IGOFN5dE90Fx3X5WRWiNHHA
         FeiN7cWme8G+UAQavg1I5omgNY8IYqnYtkcbANUWLc5pLhOGBmlVmimM9PtxKR/tvPQw
         R8yBgaXlHA7S3Tr6i4e4N6oZprVkIuK0WmBGQRsbOTEk5PaUozGwNVtgx5yBmUFqdrhA
         MMOTX9lSO7lAE0H8aYJcN0FK/WG0eYmq78X0eMo3P+U85S+qfm/+goHLM26uQy88g02X
         njCxipcH1nytIZYB3/vWEwCSVgawggVU6bfNrOKuP9BvMeu3CbR+g4CZEcttOYx45s+2
         PPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ZpVYoZ/JyrHVvhweeOK3ctog2JQiFN7vWiPCLmx8Ock=;
        b=YYAt/kIxdhpUPVgcSAmnXNgQfAetDbrFiHrDB1pOqBA/GPMjJTOIwiFuhGHrQ58L5K
         e+Dfax0pmkMizNwY0IAnzpGFvZJudle/Qh/idEDTrxEbO26WXRX4362hHG2+0w3jIxEm
         6mVTZn5Lg2hB6WcA20c/5vAR5Bdpi11YL0pzabj3zM5D/8KSaMCBO5yF7oMjv3yu/JxM
         nRu+NS1UmJjOU0T1lUmaRz3JzvQg2oU6UVikmPeSvLwvJU314Q7GusYdATtuzOXhDIy3
         VNWtd9cNlTI61VTGbrXYqc2QZrTiVl9FrPcHvK+PZXfbjRDIxlUbh8wqWAG4S73gaVDB
         QOlA==
X-Gm-Message-State: APjAAAWsOh/2SONoVP9sLglNy9vBr4trqJ4s5P5q8MczQqrOwcojsZFy
        cM2Rt4Y532k+fn2WEOFmCNU6BqRJkA==
X-Google-Smtp-Source: APXvYqwDm8Vq5cKiMNs3/wPjVQUzTIMXTUS6M/yFxU4M6s9zu1HKoQAXYin0kM3t3HdNgCDDwWzR7w==
X-Received: by 2002:aa7:8dd4:: with SMTP id j20mr1506858pfr.36.1572504115879;
        Wed, 30 Oct 2019 23:41:55 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x7sm2218815pff.0.2019.10.30.23.41.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 23:41:55 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v3 1/4] fsstress: show the real file id and parid in rename_f()
Date:   Thu, 31 Oct 2019 14:41:46 +0800
Message-Id: <9af5eec16126c179cc3520da262afabbc743a354.1572503039.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1572503039.git.kaixuxia@tencent.com>
References: <cover.1572503039.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1572503039.git.kaixuxia@tencent.com>
References: <cover.1572503039.git.kaixuxia@tencent.com>
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

