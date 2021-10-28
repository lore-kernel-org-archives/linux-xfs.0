Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A498C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Oct 2021 11:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E58BF610F8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Oct 2021 11:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhJ1LbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 07:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhJ1LbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Oct 2021 07:31:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890A6C061570;
        Thu, 28 Oct 2021 04:28:43 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 187so5634459pfc.10;
        Thu, 28 Oct 2021 04:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gQFplOd7AdgUe+nOj1VdUU7Afy07VLeiglFcD1nsIqc=;
        b=jEcrCaWtuRq6M+hdzOY2U1QMbYuX9kMvsGIB2I+LqoggKm1DOQ8sg1b1NK9NHAOq6r
         25Wa2YQHz4Zg+SJDoPKY7tV/Xb7xTboQv9NxIyxrSO3Btag85Bc7fFnCaTxSvo5vwHsl
         C0G8SlOztDGrEFYBN4z9hLCVHXv//Aqh5tLpGLfq+IdAnSptd8hML50VefpDoY3Lu6G2
         3gKtPc9DcZPeduOGzHSUe1pHnXZICVnBCB71DIQgKEBAbQILM7FVxBrAm9gv5PImiX/h
         j+Ng9YPofTaf5lh/+W4QLDM7RIr+VpclV439SsBpoRFDvc2ZvTuOVXZu2BsshgB0U0Rx
         DvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gQFplOd7AdgUe+nOj1VdUU7Afy07VLeiglFcD1nsIqc=;
        b=nbKh9Q9DjEuixxKqNycZuA3u1bkVW1caMkzXXk2j4vXldSzj+WXgxagEAejaONAC4U
         cxefufAON9+k3wjJH9lXCFkvd8x3XNasqQv+PGqhwpAeQCtZW/Ky/tr83PAtpwCWsVns
         oppu9aXiPJWGzd4+VjF+7bTPSu9cEk5SH8imMlHQVLWckeQY+NkPMH1pE3yq272hcxMH
         WIaavjD52NfvuucuCZa+pEBBdK/ojgn/qS1zqarHWHE5e+MislBbS+M88A+TTQqjbFCU
         YFihGVQQqCKMbffonIkJdCFdZvGvz5HAFraJkXvqzPEj/qgQ36Ztfcgur1BYMJebojV+
         U6/Q==
X-Gm-Message-State: AOAM530FsKq1kOWiNZbQwQBTxvXVkQ8X3LvYlOld0tVHQjM46N+Glk6C
        p0XtvxCOd13i19vLKdsQgmp+U/PudSo=
X-Google-Smtp-Source: ABdhPJytVmeIm+P2sxi8A1p98b2+YklwfMLmjys9pQn1QpUuaHmsvLWWU4Wuj23aMJ68a6lw6jcYpA==
X-Received: by 2002:a62:f20e:0:b0:47b:f629:6b52 with SMTP id m14-20020a62f20e000000b0047bf6296b52mr3618569pfh.53.1635420523156;
        Thu, 28 Oct 2021 04:28:43 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f4sm2501316pgn.93.2021.10.28.04.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 04:28:42 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] xfs: use swap() to make code cleaner
Date:   Thu, 28 Oct 2021 11:28:30 +0000
Message-Id: <20211028112830.16381-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use swap() in order to make code cleaner. Issue found by coccinelle.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 fs/xfs/xfs_inode.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a4f6f034fb81..518c82bfc80d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -564,8 +564,6 @@ xfs_lock_two_inodes(
 	struct xfs_inode	*ip1,
 	uint			ip1_mode)
 {
-	struct xfs_inode	*temp;
-	uint			mode_temp;
 	int			attempts = 0;
 	struct xfs_log_item	*lp;
 
@@ -578,12 +576,8 @@ xfs_lock_two_inodes(
 	ASSERT(ip0->i_ino != ip1->i_ino);
 
 	if (ip0->i_ino > ip1->i_ino) {
-		temp = ip0;
-		ip0 = ip1;
-		ip1 = temp;
-		mode_temp = ip0_mode;
-		ip0_mode = ip1_mode;
-		ip1_mode = mode_temp;
+		swap(ip0, ip1);
+		swap(ip0_mode, ip1_mode);
 	}
 
  again:
-- 
2.25.1

