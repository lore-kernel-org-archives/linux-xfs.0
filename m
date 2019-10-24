Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159D0C47E49
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 14:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFB4B22478
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 14:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gglRlUzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393907AbfJXOU7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:20:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37609 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391402AbfJXOU7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 10:20:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so15253289pfo.4;
        Thu, 24 Oct 2019 07:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=LIyf2nUXNiC3edMCFCsEIIUrI7e0z/yUb6FaKRHRTYQ=;
        b=gglRlUzg6r7yWeniH37+Cu3ogRhGyF1J8MQh5ax+G1T6ntdbnbEhEOP3ar5wmxt6JU
         Zv/DYHSTMdGpbzR2ymbpEPYSbqKmbE02bfZ/Q6ouBu/TtWfC9pYaAjfyuwgzsIbL8SxZ
         D0OyuNvbS93+d+x0xK5DrlpIAGx9hJT2uHOo/+JBzsKk9roia8WlDIFdF76bLG3Hg2aS
         sn1U4EUF2FSvV34VPRmgNogt3dzWdnHexWvdpUsICDKrfhEJsEWO9wmx8bD6w9ye5RfG
         v4G6Ks5cO1v8Xl1+1SNdX9EgQvO1YeVvLG5Xho+Ks8tghTYyH5V7p5hCXWHavS9si9t1
         ov0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=LIyf2nUXNiC3edMCFCsEIIUrI7e0z/yUb6FaKRHRTYQ=;
        b=T+JO+eiTVrGTyhTTbIuoW+ysqwogba/lwuyEtE0Knr2J9Ca/s0xI19xWHdnqo4GmB/
         gKu8Id303iUdChy9EdPB+zVhRy5vR0kFSm97tpekDN0D+jyBlWDKCnGXjd7kG3BointG
         aOpstsd4uw84yjd5kpdtpSVmfaFVQOoWsxXq/fAW+fy/df6U83D6qf/MYO+zbyED3qVX
         lQD6nw7U3jvY9v9iBPmn4E9uKNVGyxNQkWG7IN2hUo4p54rcuFmXpJrqCxI57/sHZ6XB
         VrElQKG396sxRnO6Xtr8Kd45fQfoRGyPXpq2TzcKG5lS0rgPckYZgE4IGsWMdQ2boDyN
         hkyg==
X-Gm-Message-State: APjAAAUzqTktow8+umioBJu+w6XsSRbb9ytupBzQSlX+7aiNFp0kOAfH
        rRFbw6D5ySEehUE2pqTKyo73Z2raxV6I
X-Google-Smtp-Source: APXvYqybfz3Y9ourzS5Bn6HxGRpXB5jA0wHRVFdu3XosX+vDn4FFtKmc3SZcvySMCJ3XfKb92ihF9Q==
X-Received: by 2002:a63:e156:: with SMTP id h22mr16594484pgk.266.1571926858016;
        Thu, 24 Oct 2019 07:20:58 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id i11sm24368284pgd.7.2019.10.24.07.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 07:20:57 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH 1/4] fsstress: show the real file id and parid in rename_f()
Date:   Thu, 24 Oct 2019 22:20:48 +0800
Message-Id: <d68b2f32b3dbe57427e6bacaeb6e4a32d8576b0c.1571926790.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1571926790.git.kaixuxia@tencent.com>
References: <cover.1571926790.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1571926790.git.kaixuxia@tencent.com>
References: <cover.1571926790.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The source file id and parentid are overwritten by del_from_flist()
call, and should show the actually values.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
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

