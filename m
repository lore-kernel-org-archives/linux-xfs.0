Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4117C5B55F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344517AbjKPC2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344494AbjKPC2r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:47 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DC5127;
        Wed, 15 Nov 2023 18:28:44 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6bd32d1a040so306877b3a.3;
        Wed, 15 Nov 2023 18:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101724; x=1700706524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gneLp7tGBL9JUwyGqm1AtuCd9W6+c6LaPbDq92+7K7U=;
        b=fTUo8oVvrhbcsMb98iuf7Q64etxb5EPVDrh/NVz2Txg69dub/x8Vx3n0K3O9c+zW0N
         DDlwoonIHvgRJUJtrlKOA1f9x7iL6Q9R+6mfPoHiuAiEfsmnvwNDmjK0F4Tf/ifwRjfm
         P9X1up6hhbZlWLo0q/vktYT9HPpTxsnjLzWHDjdiBuBy4tzdXcGe1GKFD+fNKVT/PubQ
         dIsHEsM9ycMuf5H0Tg38PN5+qFdeB42AaMvHCPf5oHoN+aI9zSvDabJsgXk637gF7uHs
         qyJq6gCp2RWyyiIlGpnYnHeDBT54rOBPuK+slfUmUmTGlW9Ge5RcDFXUk735yRrWOecL
         xb5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101724; x=1700706524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gneLp7tGBL9JUwyGqm1AtuCd9W6+c6LaPbDq92+7K7U=;
        b=mJrQNU0cmRnpJfxOj5DxsxC1XoViH+YiQkx8llcan/bfKpUaJZtXfivO8Y5W3tWiuu
         N1Qsbk0OH+Y1pY4VMuIIW2UvtdsUgNPS7nECbzB2GVbAWaSwQc67dAGGnLCq7cKOYasg
         VEdxfzeseV+QngypsJE5ymV5nvg4Lw26EguT11QSzF4cHiPq9GOIG7Qqi3w+MbZB4P3X
         7AL/uQrQbi5BKwTPn6cBUkgNHKVtpPbuhkjnh7NIQksKMDE0fxKjvii+whKMWvwl8CAH
         AZNbQ1sdAdWGtJ7qlppIoOiWTkJ1HGGg57t0RtaIxt3S44HlaWpqzBIXGtcOx9xTZPyA
         JF3A==
X-Gm-Message-State: AOJu0YwYuizbcnYuk4okPc5SMznfa25J6QQ3OqHlmCIHsKBKQlZLvC1H
        mXIyDA+JoUCFBqaFVX/i5Lob6sc7zBGRDg==
X-Google-Smtp-Source: AGHT+IG7NieW+DaGBaPQsmm3J1708q9rVskrKVR3h4SerB6hqUq14I2DbW/KH5nPZhY2YR5NQqDMJg==
X-Received: by 2002:a05:6a20:3d1b:b0:187:5a4d:7061 with SMTP id y27-20020a056a203d1b00b001875a4d7061mr4839474pzi.44.1700101723853;
        Wed, 15 Nov 2023 18:28:43 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:43 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        Zhang Yi <yi.zhang@huawei.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 06/17] xfs: flush inode gc workqueue before clearing agi bucket
Date:   Wed, 15 Nov 2023 18:28:22 -0800
Message-ID: <20231116022833.121551-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 04a98a036cf8b810dda172a9dcfcbd783bf63655 ]

In the procedure of recover AGI unlinked lists, if something bad
happenes on one of the unlinked inode in the bucket list, we would call
xlog_recover_clear_agi_bucket() to clear the whole unlinked bucket list,
not the unlinked inodes after the bad one. If we have already added some
inodes to the gc workqueue before the bad inode in the list, we could
get below error when freeing those inodes, and finaly fail to complete
the log recover procedure.

 XFS (ram0): Internal error xfs_iunlink_remove at line 2456 of file
 fs/xfs/xfs_inode.c.  Caller xfs_ifree+0xb0/0x360 [xfs]

The problem is xlog_recover_clear_agi_bucket() clear the bucket list, so
the gc worker fail to check the agino in xfs_verify_agino(). Fix this by
flush workqueue before clearing the bucket.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index aeb01d4c0423..04961ebf16ea 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2739,6 +2739,7 @@ xlog_recover_process_one_iunlink(
 	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
 	 * clear the inode pointer in the bucket.
 	 */
+	xfs_inodegc_flush(mp);
 	xlog_recover_clear_agi_bucket(mp, agno, bucket);
 	return NULLAGINO;
 }
-- 
2.43.0.rc0.421.g78406f8d94-goog

