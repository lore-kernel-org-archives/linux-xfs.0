Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8183C0A1A
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871332; cv=none; b=O06H+afJ6Yg8oJ/s/IHJEgwh2pXwaimr9aJAXtqoNMDAUwaV0EenaJjpbf7UVkP55Gko63jSBOzJQOivhS07Cx0K4OFdzGArUUiqv6RSdRBuoz/r7SiQ7LgJ5r0zIh/Cstz2HwDMSqCLLfgJ35pKX76JBL69BbGrKy2AUGy9Xt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871332; c=relaxed/simple;
	bh=5WsHisxSTWlHppam8+JNTPLTQZ2c+s7cLTJFJiG3SAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+2aKqdUI82virY51+C0L+zugT2W8Fte3UaNV8wQvIKPfhWP8gSXFnZd3a1b81UuRZL3byzPRyBQTZBUnFr8bvbf7uImwWvWkOd25P3sPw/Pn9/gRFFpYuihzn6kF53JrDB4yoEXn+0zAl8mVVbBZrST1W/Pkq9Kax4n71Tqpn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnD38fxX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnD38fxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EDA1F00893;
	Tue, 13 Oct 2026 06:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871330;
	bh=223ZXCNXgmU5x8etrL5TjLxBj33VueG4z4VY0Cu58rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnD38fxXlVWTZDkyEAi3azGKkPI2+Frz9YeLo2Xcr1jVKgrYqnPvVRLyksSRxGA6T
	 II+rsHJXsxEGArSHmyEk3hhCpxnHfKo6CMTpRo6Jb1VGn9q2gfdj3B8XFNz3tfGGUu
	 qn1WrrXJ5E+4309ttVSQurEPf8H8cY2P28PO5mhZ4DGX58CTUL2H7g3Lgq98VPpW4l
	 arg8QbQPZh2+fRtliXeSHqnibA0oKAZ0gZ/wMdqaRvQvKt31K/8XGGjaB02NG3WOas
	 0FSWS+afAMMgDQg4w4LVEJ7nkY0nc4dyvWk85/X0xSE9oE13a1LSuNShUP0TlNo1vZ
	 Vri0VVc2BB5Jg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 01/48] xfs: set the unmount record operation header length
Date: Tue, 13 Oct 2026 17:00:51 +1100
Message-ID: <20261013060204.3138690-2-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The unmount record is written to the log with a hand built operation
header passed directly to xlog_write() through xlog_write_one_vec().
The operation header length was never set, so the unmount record is
written with a zero length header even though it carries an unmount
log format structure. Recovery does not check the unmount record, so
the incorrect length goes unnoticed.

Before commit db357078b0423e ("xfs: introduce xlog_write_full()")
the operation header length was rewritten correctly by xlog_write(),
hence the incorrectly built unmount header went unnoticed. After
that commit, xlog_write() never rewrote operation header lengths for
regions that fit fully into the iclog. This change exposed the
problem with the unmount record header construction.

Set the operation header length when building the unmount record.
xlog_write_one_vec() now validates that the operation header length
is set correctly for the region being written, and shuts down the
filesystem if a malformed record write is detected.

Fixes: db357078b0423e ("xfs: introduce xlog_write_full()")
Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 74b324f915a1..a21241d990e4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -811,6 +811,7 @@ xlog_write_one_vec(
 	struct xfs_log_iovec	*reg,
 	struct xlog_ticket	*ticket)
 {
+	struct xlog_op_header	*ophdr = reg->i_addr;
 	struct xfs_log_vec	lv = {
 		.lv_niovecs	= 1,
 		.lv_iovecp	= reg,
@@ -818,6 +819,20 @@ xlog_write_one_vec(
 	};
 	LIST_HEAD		(lv_chain);
 
+	/*
+	 * The caller builds the operation header itself, and xlog_write() no
+	 * longer rewrites the length when the region is written whole. Make sure
+	 * the length the caller recorded in the header matches the region, so a
+	 * bad header is caught here rather than being written to the log.
+	 */
+	if (reg->i_len != sizeof(*ophdr) + be32_to_cpu(ophdr->oh_len)) {
+		xfs_alert(log->l_mp,
+			"%s: region length %u does not match op header length %u",
+			__func__, reg->i_len, be32_to_cpu(ophdr->oh_len));
+		xlog_force_shutdown(log, SHUTDOWN_CORRUPT_INCORE);
+		return -EFSCORRUPTED;
+	}
+
 	/* account for space used by record data */
 	ticket->t_curr_res -= lv.lv_bytes;
 
@@ -842,6 +857,7 @@ xlog_write_unmount_record(
 		.ophdr = {
 			.oh_clientid = XFS_LOG,
 			.oh_tid = cpu_to_be32(ticket->t_tid),
+			.oh_len = cpu_to_be32(sizeof(struct xfs_unmount_log_format)),
 			.oh_flags = XLOG_UNMOUNT_TRANS,
 		},
 		.ulf = {
-- 
2.55.0

