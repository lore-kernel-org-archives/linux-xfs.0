Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3A664CF2
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 02:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814554; cv=none; b=B/ZupEHbOynDUZVqZAUXGyWy9mrZNRVjiuqmK8iu5yDhv23+AwqjqeEJb6hm+RZ6Ev+j342GKcsAN6dnCWK/Ut8489XhvcC/oFLjv6s4eSgSEiJ6Gd3AX64aC2hqk30Ke6PnsbBzp7bnFWNKYHMjYHbEm1VJ+6QVu4EXvadaj6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814554; c=relaxed/simple;
	bh=Yf94FY864Fwa7x4u2KYqLTej0wzrVk59PEiLDqIhPHs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJV0IyJJ2vIpSfOup9JRrbtuk2yPqY9L8cB87LsnUS+VkIMzksOV7wxtonIsTiWOA/FT1ApcucAKuZ8hCP/QrUI0acPyaT/Jujtj96VGasS0NgONTHU1w3vFPmKoDP0yK7dXQOsT1Sk7lis3FyPDGWGXW5blGqOHUrk8vBpEu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QSGccO2i; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QSGccO2i"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5a21859a4b8so2290087eaf.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 19:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710814552; x=1711419352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u19OYdpiE5iqRxNzLdEz7cY57m3mFVh4j8humQaHnUA=;
        b=QSGccO2iroOeNHJjnD116c5k++xo2c2pUo1TtvGUst1EUX3i3z8K12c/ZdfKrtPXC0
         KjELquKlslPZ7Bu9eukwlgxuKq2ntRmJMlnlckwqbrltHLunk5LHRPopOnzPoDvi6FfL
         kj9uhb8xsCZP1mXc6TyYDD5B9pTKP7yok9xOfEGTzV4pEKzyqtLNOsDyiOk/bW0aSBRw
         e2FvfzWvXmUmBjyNkWW/eRM7h7sKJSP6o29b+oNoyAZtpPQtzVA2/qJF5bpJqCBkiWIy
         0PwX6+mPdffO4zhiPRMzSoM4VkQE6peHNNLoBqNuF2oCK6ut63jVMTFs3kPO4mkN6kVT
         4QeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710814552; x=1711419352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u19OYdpiE5iqRxNzLdEz7cY57m3mFVh4j8humQaHnUA=;
        b=GFK+vS59jZzHLDAa8uYPpJIWzT/Kfpk9Ta32H0SVCq3HNXAWIJRxj+V9ZAncH9Kyla
         9+iAaHUQ0dK9/2Mi8b0UoywZCgeDZEdVsZcq9thnUAtAlNNBuiRKHh1Ik3IjTUdhjqPK
         h+W7agsYmBfAh0NyvOpnNoid/ov8wp1ehoxTd+xFxd+WbblQ51YdhCmQ6Sho6xB9OKx1
         6wf6rnoCLq1//5FENvE7wmEEk3lusFdOv0RjtcqeFXD9x/rnnnaFCfdn0rD8ZJIA/P+g
         xkGDzUG1YWpYneJc7XK5WDuTbarB/qcuQ+HvJNHBAfvrbwBQp0gDASiSeJnL2iA4HCS6
         XH/A==
X-Gm-Message-State: AOJu0Yxj2wwMXXap0vH4bN2LbqzUSmty7KsffQEC3tlnuT4w+t77Q1O0
	9xoSFfPgm/fF00D+IxANyQ0nfMNsROmqghwjQIK28Z88gsKDyTBZ+9u586PO9LUXuKqPYO/e1oG
	j
X-Google-Smtp-Source: AGHT+IFo26MD8UjzexDgXp2Jr+vMCLYMP7GGG7kL81yV9Tv6MbAKeLoUN2BaGF5dtc4KCyBrZPPYcg==
X-Received: by 2002:a05:6358:2799:b0:17b:f11f:5cc3 with SMTP id l25-20020a056358279900b0017bf11f5cc3mr14741795rwb.18.1710814551881;
        Mon, 18 Mar 2024 19:15:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id i124-20020a62c182000000b006e24991dd5bsm9244033pfg.98.2024.03.18.19.15.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 19:15:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmP13-003s4y-1t
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmP13-0000000Ec6j-0LWf
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: buffer log item type mismatches are corruption
Date: Tue, 19 Mar 2024 13:15:20 +1100
Message-ID: <20240319021547.3483050-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319021547.3483050-1-david@fromorbit.com>
References: <20240319021547.3483050-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

We detect when a buffer log format type and the magic number in the
buffer do not match. We issue a warning, but do not return an error
nor do we write back the recovered buffer. If no further recover
action is performed on that buffer, then recovery has left the
buffer in an inconsistent (out of date) state on disk. i.e. the
structure is corrupt on disk.

If this mismatch occurs, return a -EFSCORRUPTED error and cause
recovery to abort instead of letting recovery corrupt the filesystem
and continue onwards.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item_recover.c | 51 +++++++++++++++++------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d74bf7bb7794..dba57ee6fa6d 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -207,7 +207,7 @@ xlog_recover_buf_commit_pass1(
  *	the first 32 bits of the buffer (most blocks),
  *	inside a struct xfs_da_blkinfo at the start of the buffer.
  */
-static void
+static int
 xlog_recover_validate_buf_type(
 	struct xfs_mount		*mp,
 	struct xfs_buf			*bp,
@@ -407,11 +407,12 @@ xlog_recover_validate_buf_type(
 	 * skipped.
 	 */
 	if (current_lsn == NULLCOMMITLSN)
-		return;
+		return 0;;
 
 	if (warnmsg) {
 		xfs_warn(mp, warnmsg);
-		ASSERT(0);
+		xfs_buf_corruption_error(bp, __this_address);
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -425,14 +426,11 @@ xlog_recover_validate_buf_type(
 	 * the buffer. Therefore, initialize a bli purely to carry the LSN to
 	 * the verifier.
 	 */
-	if (bp->b_ops) {
-		struct xfs_buf_log_item	*bip;
-
-		bp->b_flags |= _XBF_LOGRECOVERY;
-		xfs_buf_item_init(bp, mp);
-		bip = bp->b_log_item;
-		bip->bli_item.li_lsn = current_lsn;
-	}
+	ASSERT(bp->b_ops);
+	bp->b_flags |= _XBF_LOGRECOVERY;
+	xfs_buf_item_init(bp, mp);
+	bp->b_log_item->bli_item.li_lsn = current_lsn;
+	return 0;
 }
 
 /*
@@ -441,7 +439,7 @@ xlog_recover_validate_buf_type(
  * given buffer.  The bitmap in the buf log format structure indicates
  * where to place the logged data.
  */
-STATIC void
+static int
 xlog_recover_do_reg_buffer(
 	struct xfs_mount		*mp,
 	struct xlog_recover_item	*item,
@@ -523,20 +521,20 @@ xlog_recover_do_reg_buffer(
 	/* Shouldn't be any more regions */
 	ASSERT(i == item->ri_total);
 
-	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
+	return xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
 }
 
 /*
- * Perform a dquot buffer recovery.
+ * Test if this dquot buffer item should be recovered.
  * Simple algorithm: if we have found a QUOTAOFF log item of the same type
  * (ie. USR or GRP), then just toss this buffer away; don't recover it.
  * Else, treat it as a regular buffer and do recovery.
  *
- * Return false if the buffer was tossed and true if we recovered the buffer to
- * indicate to the caller if the buffer needs writing.
+ * Return false if the buffer should be tossed and true if the buffer needs
+ * to be recovered.
  */
-STATIC bool
-xlog_recover_do_dquot_buffer(
+static bool
+xlog_recover_this_dquot_buffer(
 	struct xfs_mount		*mp,
 	struct xlog			*log,
 	struct xlog_recover_item	*item,
@@ -565,8 +563,6 @@ xlog_recover_do_dquot_buffer(
 	 */
 	if (log->l_quotaoffs_flag & type)
 		return false;
-
-	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
 	return true;
 }
 
@@ -952,18 +948,19 @@ xlog_recover_buf_commit_pass2(
 
 	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
 		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
-		if (error)
-			goto out_release;
 	} else if (buf_f->blf_flags &
 		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-		bool	dirty;
-
-		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
-		if (!dirty)
+		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
 			goto out_release;
+
+		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
+				NULLCOMMITLSN);
 	} else {
-		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
+				current_lsn);
 	}
+	if (error)
+		goto out_release;
 
 	/*
 	 * Perform delayed write on the buffer.  Asynchronous writes will be
-- 
2.43.0

