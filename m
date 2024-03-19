Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC6B64CFF
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 02:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814555; cv=none; b=on3FQxWTdK+P26+xLAeNpDrM0U5cb03amLSOisV4fcOnWA5E+agRG9EGAodplbY7qqHJJv1RamEU/EhVpd+s026oRJoNaB22rCkj6yE6Ac4y/XAxR51wP+g4GZrpeXbuZWiy9C8ty+M59D33/DVFOCYmng8t2SGZslxMJCuxCZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814555; c=relaxed/simple;
	bh=Yr0FGW5Z3DrFhZlJCPhDM7MgtCq5WuvbafqZwMSlFrs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OA3dN226J+hoLmVtTjqA/3ZBEBkK9gjgU6Cx5NXlnEgrxefHeK1jM5pRQ+YYh64IxOIoYlDOiX1P6T6L+MMFYCigrWY69H4ZoZZNa6QapaWHFKvG6Lh24iybHJ2LAFKQxTua6ULLe402W2oPPAwB3lUZClDDYEeOlnH3ASiWmc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YMXGjOpY; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YMXGjOpY"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dee5daa236so33374995ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 19:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710814553; x=1711419353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=06ZP5ST3YQK59Bq6d67aot0UFYtio5PSff3ziC1LiBg=;
        b=YMXGjOpYEmRDIpklwENKOj3lWVks0aqjOW9YUh+m2gRgCs3N7V1pTiV4NG8f0c4bOp
         UyAFyWZ2bxDQFHHF098DD0Xn5ORdG4ocyQNMc6Zlo6DavADkwFYZBhIaet0hBWiCKE1Z
         TDGb7T5KfJJ5wXvWjj7TagiremJvdK+vVghSmBC7qccR1kbrrJBS/VPmfzxxZXwuQKAH
         /FVsARDrs/uruPLow7I/3i2XMKGaxRZESUgnpdvLh1hZYtWeH+95mn3G+adEXQy/xmMX
         G6fPY47DPBbR2Is/OXOfC7C+vgCFCctG/3Jr6GiXl/ls01GLpwITxAzqVr8sscgbj5vo
         r7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710814553; x=1711419353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06ZP5ST3YQK59Bq6d67aot0UFYtio5PSff3ziC1LiBg=;
        b=KYyZXPgE5LxlH9zi7Z9VG0pqj6ngIP9fZy3gtshxRifdtQh0wRIdT8soFE/t217aCE
         wKlrTry2yT8x2Kve27PYkRELwRSC+Tid9/cgR/lzIeNh0Rx+1hm7ZHlM19Czm7pJneK0
         hD6Sq9qjGq/zmUnLtBZDDZ/z4fu2KlGbG5J3LqT4qW5hbbsPnnkBUvOagSUgh4MTYUAr
         qktimx0W/j1uZzm6FQpT2eW8vLUSuYD0FOHAInh5HDQLaOLZT4K9VSro00pQ5/C2U94N
         hPYzXWuKj6Wtbdi1WMkZcgPRmD3QxxMi9uIESZO08i83XBN/8l7uM5i1foA4mY9oKJ07
         IHUQ==
X-Gm-Message-State: AOJu0YxUGQVKQd1nkGmYqKl97P+8Txt38nTIvPG7v3Hiy1qqZH4H1tin
	H4XleKnqeKGxdcpspXdpZoi/qqmxY3cUskec9+Sfyie14NphhMlQir5Ar3PwjT1DmFSMcE39/hQ
	i
X-Google-Smtp-Source: AGHT+IH8/6wBaNnHN9W0hjHgufHh0bMxCeXrlR4jgd3RhU2w+8sW1unbHnbrOnefW7Nz/bJ3OiJGuw==
X-Received: by 2002:a17:902:d504:b0:1dd:2e6:b951 with SMTP id b4-20020a170902d50400b001dd02e6b951mr18443104plg.12.1710814552741;
        Mon, 18 Mar 2024 19:15:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id c17-20020a170902d49100b001def0324a64sm7785116plg.135.2024.03.18.19.15.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 19:15:52 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmP13-003s54-2B
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmP13-0000000Ec6s-0jeQ
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: recover dquot buffers unconditionally
Date: Tue, 19 Mar 2024 13:15:22 +1100
Message-ID: <20240319021547.3483050-4-david@fromorbit.com>
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

Dquot buffers are only logged when the dquot cluster is allocated.
Recovery of them is always done and not conditional on an LSN found
in the buffer because there aren't dquots stamped in the buffer when
the initialisation is replayed after allocation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_log_format.h |   6 ++
 fs/xfs/xfs_buf_item_recover.c  | 129 +++++++++++++++++----------------
 2 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 16872972e1e9..5ac0c3066930 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -508,6 +508,9 @@ struct xfs_log_dinode {
 #define XFS_BLF_PDQUOT_BUF	(1<<3)
 #define	XFS_BLF_GDQUOT_BUF	(1<<4)
 
+#define XFS_BLF_DQUOT_BUF	\
+	(XFS_BLF_UDQUOT_BUF | XFS_BLF_PDQUOT_BUF | XFS_BLF_GDQUOT_BUF)
+
 /*
  * This is the structure used to lay out a buf log item in the log.  The data
  * map describes which 128 byte chunks of the buffer have been logged.
@@ -571,6 +574,9 @@ enum xfs_blft {
 	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
 };
 
+#define XFS_BLFT_DQUOT_BUF	\
+	(XFS_BLFT_UDQUOT_BUF | XFS_BLFT_PDQUOT_BUF | XFS_BLFT_GDQUOT_BUF)
+
 static inline void
 xfs_blft_to_flags(struct xfs_buf_log_format *blf, enum xfs_blft type)
 {
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index f994a303ad0a..90740fcf2fbe 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -450,8 +450,6 @@ xlog_recover_do_reg_buffer(
 	int			i;
 	int			bit;
 	int			nbits;
-	xfs_failaddr_t		fa;
-	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -481,39 +479,10 @@ xlog_recover_do_reg_buffer(
 		if (item->ri_buf[i].i_len < (nbits << XFS_BLF_SHIFT))
 			nbits = item->ri_buf[i].i_len >> XFS_BLF_SHIFT;
 
-		/*
-		 * Do a sanity check if this is a dquot buffer. Just checking
-		 * the first dquot in the buffer should do. XXXThis is
-		 * probably a good thing to do for other buf types also.
-		 */
-		fa = NULL;
-		if (buf_f->blf_flags &
-		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-			if (item->ri_buf[i].i_addr == NULL) {
-				xfs_alert(mp,
-					"XFS: NULL dquot in %s.", __func__);
-				goto next;
-			}
-			if (item->ri_buf[i].i_len < size_disk_dquot) {
-				xfs_alert(mp,
-					"XFS: dquot too small (%d) in %s.",
-					item->ri_buf[i].i_len, __func__);
-				goto next;
-			}
-			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
-			if (fa) {
-				xfs_alert(mp,
-	"dquot corrupt at %pS trying to replay into block 0x%llx",
-					fa, xfs_buf_daddr(bp));
-				goto next;
-			}
-		}
-
 		memcpy(xfs_buf_offset(bp,
 			(uint)bit << XFS_BLF_SHIFT),	/* dest */
 			item->ri_buf[i].i_addr,		/* source */
 			nbits<<XFS_BLF_SHIFT);		/* length */
- next:
 		i++;
 		bit += nbits;
 	}
@@ -566,6 +535,56 @@ xlog_recover_this_dquot_buffer(
 	return true;
 }
 
+/*
+ * Do a sanity check of each region in the item to ensure we are actually
+ * recovering a dquot buffer item.
+ */
+static int
+xlog_recover_verify_dquot_buf_item(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f)
+{
+	xfs_failaddr_t			fa;
+	int				i;
+
+	switch (xfs_blft_from_flags(buf_f)) {
+	case XFS_BLFT_UDQUOT_BUF:
+	case XFS_BLFT_PDQUOT_BUF:
+	case XFS_BLFT_GDQUOT_BUF:
+		break;
+	default:
+		xfs_alert(mp,
+			"XFS: dquot buffer log format type mismatch in %s.",
+			__func__);
+		xfs_buf_corruption_error(bp, __this_address);
+		return -EFSCORRUPTED;
+	}
+
+	for (i = 1; i < item->ri_total; i++) {
+		if (item->ri_buf[i].i_addr == NULL) {
+			xfs_alert(mp,
+				"XFS: NULL dquot in %s.", __func__);
+			return -EFSCORRUPTED;
+		}
+		if (item->ri_buf[i].i_len < sizeof(struct xfs_disk_dquot)) {
+			xfs_alert(mp,
+				"XFS: dquot too small (%d) in %s.",
+				item->ri_buf[i].i_len, __func__);
+			return -EFSCORRUPTED;
+		}
+		fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr, -1);
+		if (fa) {
+			xfs_alert(mp,
+"dquot corrupt at %pS trying to replay into block 0x%llx",
+				fa, xfs_buf_daddr(bp));
+			return -EFSCORRUPTED;
+		}
+	}
+	return 0;
+}
+
 /*
  * Perform recovery for a buffer full of inodes. We don't have inode cluster
  * buffer specific LSNs, so we always recover inode buffers if they contain
@@ -743,7 +762,6 @@ xlog_recover_get_buf_lsn(
 	struct xfs_buf_log_format *buf_f)
 {
 	uint32_t		magic32;
-	uint16_t		magic16;
 	uint16_t		magicda;
 	void			*blk = bp->b_addr;
 	uuid_t			*uuid;
@@ -862,27 +880,7 @@ xlog_recover_get_buf_lsn(
 		return lsn;
 	}
 
-	/*
-	 * We do individual object checks on dquot and inode buffers as they
-	 * have their own individual LSN records. Also, we could have a stale
-	 * buffer here, so we have to at least recognise these buffer types.
-	 *
-	 * A notd complexity here is inode unlinked list processing - it logs
-	 * the inode directly in the buffer, but we don't know which inodes have
-	 * been modified, and there is no global buffer LSN. Hence we need to
-	 * recover all inode buffer types immediately. This problem will be
-	 * fixed by logical logging of the unlinked list modifications.
-	 */
-	magic16 = be16_to_cpu(*(__be16 *)blk);
-	switch (magic16) {
-	case XFS_DQUOT_MAGIC:
-		goto recover_immediately;
-	default:
-		break;
-	}
-
 	/* unknown buffer contents, recover immediately */
-
 recover_immediately:
 	return (xfs_lsn_t)-1;
 
@@ -956,6 +954,21 @@ xlog_recover_buf_commit_pass2(
 		goto out_write;
 	}
 
+	if (buf_f->blf_flags & XFS_BLF_DQUOT_BUF) {
+		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
+			goto out_release;
+
+		error = xlog_recover_verify_dquot_buf_item(mp, item, bp, buf_f);
+		if (error)
+			goto out_release;
+
+		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
+				NULLCOMMITLSN);
+		if (error)
+			goto out_release;
+		goto out_write;
+	}
+
 	/*
 	 * Recover the buffer only if we get an LSN from it and it's less than
 	 * the lsn of the transaction we are replaying.
@@ -992,17 +1005,7 @@ xlog_recover_buf_commit_pass2(
 		goto out_release;
 	}
 
-	if (buf_f->blf_flags &
-		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
-			goto out_release;
-
-		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
-				NULLCOMMITLSN);
-	} else {
-		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
-				current_lsn);
-	}
+	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	if (error)
 		goto out_release;
 
-- 
2.43.0

