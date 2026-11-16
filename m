Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871035;
	b=qifT5lf1WjK53BUunNbkCMCSspsow7VLk91s04b5mnWv5NRQ3qp7FFojytp9uj6OnOEP
	 pTt0Ls7ha6JPdDIreIiFA7YW8Twjae+Yin4VOp1CewJAF2Q2S9P0Ua2kIbtF7dxzUIwLZ
	 bFIarlE8GV2MdleD81oRyZihIUfjxaAXfyLqV0/o8BLsg/42GQi8blJD11L/QS8mnlzs/
	 QGsEfvRjKBnUgQsh4jSIC4d24FUZLzThpoCMOTT2yxlqFNOLPmV6MUeFGMlZa9YXV4WNw
	 i8S5551N5Ll+insbwOGtbN5jc4F3NoFn6NzlVh8OFC/Uwgormk8hqj+5VsKpZNfA9Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ggq+NIlJ11ouVICCn+Z8RYg+IPNPn0JrAipHGAb4jMU=;
	b=1rSQ82RFlRWVdSbIroGs6WTzeBwb8Pv5AbtG0Q9gWkTAPXrTzJJKi1FXbuuexymkzr9x
	 gNVDKbcchafiiRm0Pge0FShvPnzLfIEy5JxwMSkLwMt1H+UQOk7C1Eltug6StNMuRHc2b
	 aCyG5FPeo15fts3isF7IU7lG/sxxhm3SISuf5hlSeTtlHNJ8saaXp+zhBTZryzj5poqXD
	 i6f500XozhfpmvkHJwyrDpbh1iJdseAJ8zbYG+aUHRwW+xW705PMhPgwi7zuEGFQ/6CF7
	 1U0L2KAkZI+E8boPw8tMuC9XgToVATFHfpKo035KQTC4Estlz+hp53xPKUNX4XuNolw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="chf/UGQR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D039B606A32C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=chf/UGQR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6A61F000C5;
	Mon, 16 Nov 2026 23:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871035;
	bh=Ggq+NIlJ11ouVICCn+Z8RYg+IPNPn0JrAipHGAb4jMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chf/UGQR7p2S4NbxvFB4TmxqAw/P/B5HfGB7magptL69b1AVtEVdkxIootPxr46FB
	 2OGcX2/yiagRGJVKBOg+A1Hk/GEZfRAOzUKp5bOYydHlOFOPXIJnBh7Ah+A55jZzrq
	 ibCp1PRBWGEtoV/xaeb/GmsVVSv47vrCuJxlM67JPfhGx3cfcn8vy17jhH3EVB5AhX
	 PVVSS9iGPMP4pEb8s5DFVuodyYnDQdiDit9CU89Ks5T8QVsYVp93lMnlNPnyCA1FM3
	 gqSF2DpBp/rpqhD2cXlFqwi+YjK2bLOEB5D/VN/e8HK122xm5wKswVKVJE3xmVs0kQ
	 2eoQPugdSFiGw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 01/59] xfs: set the unmount record operation header length
Date: Tue, 17 Nov 2026 10:14:18 +1100
Message-ID: <20261116231707.3625263-2-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
index 74b324f915a1..ab7ee848562c 100644
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
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
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

