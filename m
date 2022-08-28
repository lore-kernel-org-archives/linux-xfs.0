Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3001C0502A
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiH1Mqe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiH1Mqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:32 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897A339BAC;
        Sun, 28 Aug 2022 05:46:31 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso6814498wmc.0;
        Sun, 28 Aug 2022 05:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=prmlFxfLiXr1FB/8uvb3m0FSiNPc2aaLRgWUmmtRPXQ=;
        b=qrn5DWQlWKUkjPR+v7gJnjT4Fl4dn8p8f52MsYH29O43k6rHx6s/ReWkRgxAB0uvdn
         2yt7vx2ThyPnwvdWX6/AnKqGFOA5QPAcKPxHspc9HdlWWmDSRi1fFMVPJxx7toqP8B3a
         x2Ro++JclaED4xFkNVW6XM3Z5mp2M2IsC0IVoHS80lvzQTiCGOSNgjvBp3V6WxJ2TQ/8
         8qRE0SM19C3b6BkdbXQYpTenv+WUVT84VOH+LQ3XAwu98XCivvjABoEgeSEkldZXGBW5
         ySFPnLb7QJSioUiXkBziZxeU6Y0cjbCOs5bH85lq5jjZ6RYv6thMkQax+dyKH9eD8tVM
         Slwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=prmlFxfLiXr1FB/8uvb3m0FSiNPc2aaLRgWUmmtRPXQ=;
        b=tPMN/63NNEfItcwhLfENieQhwzFkuWSxgvWPwSgaXny5TBqi4mrO3FwouucQSCh7/b
         cqPSr96dRU03//Ht27GySEBxm7pkNJQM0pFa3uxAFA+QR26UxA8Oq1zuHDfcPFhGjfHU
         JNhqqfUOPE7/vFVAPBXT3VdpNchIphlpYAqqz/CQRWJIj1Efu1HVKbyOBV4De2ytldwm
         c47y5SSzT96J2Od7EKaEzkKem65AEr6sVn/AMNHba52D8iSd0PDE4DQg7QNvVYXVHZHs
         3ypGtE5WL/fGTE2QaV4OvoskQ8mwTJcdN07rc5m5CO67102EA9KrBvVWEek9wmUTqYjO
         STzQ==
X-Gm-Message-State: ACgBeo2aMdWDmGuXZTo4RiTFl5dMz1YQqkjPuHhYclqS7Go0GyM3kAOl
        BRWyjJea+SnUgzQKMj2E/ZikSB5PsAU=
X-Google-Smtp-Source: AA6agR6pPSv0dTSgGb+PHhSJC9DcbwwrMScI+rpRkGcH2fprkhXyqstnb8uHun94UMattdvvOqFeBQ==
X-Received: by 2002:a05:600c:1d9b:b0:3a5:d66e:6370 with SMTP id p27-20020a05600c1d9b00b003a5d66e6370mr4390887wms.73.1661690790101;
        Sun, 28 Aug 2022 05:46:30 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:29 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 2/7] xfs: always succeed at setting the reserve pool size
Date:   Sun, 28 Aug 2022 15:46:09 +0300
Message-Id: <20220828124614.2190592-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 0baa2657dc4d79202148be79a3dc36c35f425060 upstream.

Nowadays, xfs_mod_fdblocks will always choose to fill the reserve pool
with freed blocks before adding to fdblocks.  Therefore, we can change
the behavior of xfs_reserve_blocks slightly -- setting the target size
of the pool should always succeed, since a deficiency will eventually
be made up as blocks get freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_fsops.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6d4f4271e7be..dacead0d0934 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -380,11 +380,14 @@ xfs_reserve_blocks(
 	 * The code below estimates how many blocks it can request from
 	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
 	 * race since fdblocks updates are not always coordinated via
-	 * m_sb_lock.
+	 * m_sb_lock.  Set the reserve size even if there's not enough free
+	 * space to fill it because mod_fdblocks will refill an undersized
+	 * reserve when it can.
 	 */
 	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
 	delta = request - mp->m_resblks;
+	mp->m_resblks = request;
 	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
@@ -401,10 +404,8 @@ xfs_reserve_blocks(
 		 * Update the reserve counters if blocks have been successfully
 		 * allocated.
 		 */
-		if (!error) {
-			mp->m_resblks += fdblks_delta;
+		if (!error)
 			mp->m_resblks_avail += fdblks_delta;
-		}
 	}
 out:
 	if (outval) {
-- 
2.25.1

