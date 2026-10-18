Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C35D367F5E
	for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792343466; cv=none; b=mKIbcOc45wjvi/ifH5ckHpeGV8JknR735GeIJzdZGF4ya9e/BfX9O0OHw2I/Ee/h3CARvlTzO4fbg2a4OiQyKdxQb5/mbbFRin9tFOFRn/Y3wvPJ7UAWxQAYyflt2T3O9P5Dtd8l+0kI8shjYFqwbI+obs6J+8Ju6F/UPivhNlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792343466; c=relaxed/simple;
	bh=RngPiRoKRo1SDWTQaUoVzqDNzzjh+lwILzwjsOjipso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VUqKd7ModrRKSYMnoYmwcYOXc2HAdZvnbe+dlWh5H+E54PIzpIAuCUiJvo7iSHCtQg/1a5ILEz5txSb7ckQxlhuCydNz9qACYGEC5DHWq320fRXMGm0uUR+zM7bV2t8bPcj6QYYCY67DgjIgvO5ifF47kGfb/EZP41drJx7qPbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nDfOE8vG; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nDfOE8vG"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5ba35c0df4fso1398249e87.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2026 10:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792343461; x=1792948261; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gJdJrirRvF3k3Jt5AvgoO9jwhCR5BlxhBGLKGtRhtBw=;
        b=nDfOE8vG7D+x9qVwgY680MWFj1/vNe67kKtun81Zst27hIGnRV1f+7jcHHcxKxGxy/
         rf4v2/gmlYgbeCaR1W94xVQJjrw8CFFbrrj8OnGVfn2AY2963hkH0FS1NNdP0Bt7kMBp
         uy0s1SO0XziEfv3AFAMziBH8Walj9d5Bi90q3sY7jIIdcXS8z7b672IplVYRx9Sqt6hL
         euI9P1H0WowQqtpaO9GtpnoIpJb1O+wRfbbPruclYGOEVmEQmMN9AqikQZPnnMleW/5T
         CQhIhIsD+WCGwg4Y5AZsoz2a+AIobXbzzCfcLJwLoUdav4CLeECIbC4uTErfbAQ+0hgF
         iGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792343461; x=1792948261;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gJdJrirRvF3k3Jt5AvgoO9jwhCR5BlxhBGLKGtRhtBw=;
        b=rV2ZZohIb3ldfiSiSK9XDsiMp7JMrlQwasi36e9USKyFkOumCj3MKQTI6Gsbcnl1sC
         kIkYWu/4Ytf6U1nAbdYRmS51UHbxl6zFDS1owz4VVJfL+GsaI3Ybm9kSNSbUUem/43ZE
         RLa2boipBG9D5HcNPAjKi7Bmh/J4BIPS24MJ5zJR/hZqXVYHKhkSRUVo/q9jaIkwPwXB
         ea7hV3F9HZHqRhiV5cRCcA7+uEnzo6tL+htzBsqjcaxN6b9NgINRJ0WOdI9MFWaPPCqX
         1Pj8GBwaqQIw9/J5dz0NektJh/x32DpMGQJTS4l/24JLPTo7gemGCqC5KX5UTRq5490s
         Do1w==
X-Forwarded-Encrypted: i=1; AKwUvBxzP0fNMwOY+Q/ZAP2Y/rmIhMeny/GUfFIiUkRudEPlRCno2MYfEzLmBVyudxXZWxmaVKzgyE1hiD0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLlj9ml1mJKFYaLdvJdsSWdm0+yyCufKmsXYcy+PELSc8pvKCu3
	V3dSNhv2cmgiEgJiS9xHaYfDbCsplApkOmHHz0FPKVExxZ0qRxv6rE2j
X-Gm-Gg: AYBFou1drdtiJBeSMmUeV2zOkmstOHxDPqQeBW1+38wzsCUVDZaueLQJ0JSF1NKSddZ
	IBxY3k6m5r1He43J2qQ4dgfP2xbL1cyLyefxiydGOjPvQAF5TrzFLvbiZoB3RZCRFgGiZRSJ8gv
	5hs1BnVwxrUCxFgB1lBFYojWqN02NX/JN1p8P8pHmAgzsxt9ghYTREJrhtgpTLnPmFGpa4e+aKc
	HE+8RMa1TnqCfkGIATO5I/JLgp1CVfCmdmb0kIO5ZfW2BR7B+XiYlcBmX9YHvKqQ1luuHQn2KCm
	pG0k/aEAewhWF/0qgRSFkF81fpG0KKgjEW3NJ6wlXHCl4B2YMI+G+4QlG7pauGXQ5hJiQuLCpzx
	Mv0BwK/f5uYNk2udnF8CNn3vMW+QsBENOAuzXDj0VJn2szUY4WT9Tvlnt/96B5DJSFpYkdtUiTd
	dX50t8SqD4ChdxcnO9xy9OJUlkh2hihfPQcA5ihG/QlM0bTWwIGADIxa6yOWRpt4x2pPu5IR0Ln
	6YptyKefZ/09NuzqnXtKBK6MrGtFJL0x5BsjbJbUWSrLor010QJfXfcyfUuIj6ahK9d7X1XovwN
	27KK
X-Received: by 2002:a05:6512:39c6:b0:5b8:e99c:cfa1 with SMTP id 2adb3069b0e04-5be50a595a4mr1746114e87.31.1792343461073;
        Sun, 18 Oct 2026 10:11:01 -0700 (PDT)
Received: from x870steellegend.lan (95-25-165-213.broadband.corbina.ru. [95.25.165.213])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5be4a63dcf0sm1499694e87.76.2026.10.18.10.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:11:00 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>,
	syzbot+c32fff62cf4913d345d0c@syzkaller.appspotmail.com
Subject: [PATCH] xfs: do not release buf log item prematurely in xfs_buf_item_done
Date: Sun, 18 Oct 2026 20:09:13 +0300
Message-ID: <20261018170913.3104-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a buffer with an active log item is written synchronously to disk
via xfs_bwrite() (for example, in xfs_sync_sb_buf() during
FS_IOC_SETFSLABEL), I/O completion invokes xfs_buf_item_done().

Currently, xfs_buf_item_done() unconditionally calls
xfs_buf_item_relse(), which frees the xfs_buf_log_item even if it still
has active references (e.g. bli_refcount > 0 while the item is pinned in
a CIL context and queued on cilpcp->log_items). When xlog_cil_push_work()
subsequently runs on another CPU, xlog_cil_push_pcp_aggregate() accesses
the freed log item while splicing cilpcp->log_items, triggering a
slab-use-after-free:

  BUG: KASAN: slab-use-after-free in xlog_cil_push_pcp_aggregate
  Write of size 8 at addr ffff888036db9c40 by task kworker/u8:7/300
  Call Trace:
   <TASK>
   __list_splice include/linux/list.h:577 [inline]
   list_splice_init include/linux/list.h:619 [inline]
   xlog_cil_push_pcp_aggregate fs/xfs/xfs_log_cil.c:137 [inline]
   xlog_cil_push_work+0x986/0x2a90 fs/xfs/xfs_log_cil.c:1417

Fix this by checking if the buf log item still has active references
in xfs_buf_item_done(). If bli_refcount is elevated, the item is still
owned by an ongoing transaction or the CIL and must not be torn down.

Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
Reported-by: syzbot+c32fff62cf4913d345d0c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c
Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 fs/xfs/xfs_buf_item.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1a4ef34af8d5..6b32061bac53 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1067,6 +1067,14 @@ xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	/*
+	 * If the log item still has active references (e.g. pinned by the CIL
+	 * or held by an ongoing transaction), we cannot tear it down here.
+	 */
+	if (atomic_read(&bip->bli_refcount) > 0)
+		return;
 
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
@@ -1080,8 +1088,8 @@ xfs_buf_item_done(
 	 * Note that log recovery writes might have buffer items that are not on
 	 * the AIL even when the file system is not shut down.
 	 */
-	xfs_trans_ail_delete(&bip->bli_item,
-			     xlog_in_recovery(bip->bli_item.li_log) ?
+	xfs_trans_ail_delete(lip,
+			     xlog_in_recovery(lip->li_log) ?
 			     0 : SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_relse(bip);
 }
-- 
2.47.3

