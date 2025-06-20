Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB40A923
	for <linux-xfs@vger.kernel.org>; Fri, 20 Jun 2025 07:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750403304; cv=none; b=GigKaZnGuXQRMhsMCK1IxDa61y+n7QXC/oafyDumVYPkByd7Q3d9Qypi6w6qK4rHw83w25oxbW/pW2sejOoCHR0mCoustOPoSol6Nfwo/0aCQCjMlql1QOT6koDPvfQXGD0pVtJSodIH4lLS4dYd9HcY1D0IDgzcZJefneyLyBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750403304; c=relaxed/simple;
	bh=9w6LyEEC0nYk4HyYfuH0Sn1vRc0ATt5/MpDSpoTTKoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxjqohRENu4r58UeOpCYN1L05B32Hj+S8NiGoGY+sSX+y1nX6nKb2LCVSFOGV50cUz8442uHdXlGS0qYWuSYwfHmPVFp+/CpApceBL5+Tfg+9YIbFf1Mvz5CsNeJaGKQpRyDMhHZ5LWK5GC1gVK/+P/x6r1BNdMuw48/MSTpf8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8d67KwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8d67KwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84121C4CEE3;
	Fri, 20 Jun 2025 07:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750403304;
	bh=9w6LyEEC0nYk4HyYfuH0Sn1vRc0ATt5/MpDSpoTTKoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8d67KwNupPsLjMFkLkMf9pm6Ac1iux28tZ8A9LTLfO4ij2Ud05mLbTCz8DG7X6JF
	 1RtKlU0Uf2mjS7Dkx/OIhW9dg7W8OPgMdFrCejETvXzgf7igAmu7hmFFNNpjTq8X9r
	 iXXtMxLGIZWDhVfVy4PK6cFCcAcbrNvf2gJZgJi2c/7BNXAzNUtwagDqGdCBPUgxlK
	 cjIKUyCRPlMl6MAFj5mbp2BvSlvV+96+PRRdY3Noaw97+hdJv8QK+Sx0o6Si9CVFXT
	 Rz08CTfoM3xAQawTMagvgW/fYJyKFz9WM489JkX0JbrkU0LoFALCmck/aAbl0ZZVoD
	 n23tl5W5PzgWA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	david@fromorbit.com,
	djwong@kernel.org
Subject: [PATCH 2/2] xfs: kill xlog_in_core_2_t typedef
Date: Fri, 20 Jun 2025 09:08:00 +0200
Message-ID: <20250620070813.919516-3-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620070813.919516-1-cem@kernel.org>
References: <20250620070813.919516-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 fs/xfs/xfs_log.c               | 4 ++--
 fs/xfs/xfs_log_priv.h          | 2 +-
 fs/xfs/xfs_log_recover.c       | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 0d637c276db0..050df089e324 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -188,11 +188,11 @@ typedef struct xlog_rec_ext_header {
 /*
  * Quite misnamed, because this union lays out the actual on-disk log buffer.
  */
-typedef union xlog_in_core2 {
+union xlog_in_core2 {
 	xlog_rec_header_t	hic_header;
 	xlog_rec_ext_header_t	hic_xheader;
 	char			hic_sector[XLOG_HEADER_SIZE];
-} xlog_in_core_2_t;
+};
 
 /* not an on-disk structure, but needed by log recovery in userspace */
 typedef struct xfs_log_iovec {
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dbd8c50d01fd..9e293f943e08 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1530,7 +1530,7 @@ xlog_pack_data(
 	}
 
 	if (xfs_has_logv2(log->l_mp)) {
-		xlog_in_core_2_t *xhdr = iclog->ic_data;
+		union xlog_in_core2	*xhdr = iclog->ic_data;
 
 		for ( ; i < BTOBB(size); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -3310,7 +3310,7 @@ xlog_verify_iclog(
 {
 	xlog_op_header_t	*ophead;
 	struct xlog_in_core	*icptr;
-	xlog_in_core_2_t	*xhdr;
+	union xlog_in_core2	*xhdr;
 	void			*base_ptr, *ptr, *p;
 	ptrdiff_t		field_offset;
 	uint8_t			clientid;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 27912a9b7340..e8f07e9c223b 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -197,7 +197,7 @@ struct xlog_in_core {
 
 	/* reference counts need their own cacheline */
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
-	xlog_in_core_2_t	*ic_data;
+	union xlog_in_core2	*ic_data;
 #define ic_header	ic_data->hic_header
 #ifdef DEBUG
 	bool			ic_fail_crc : 1;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2f76531842f8..51cfc97aad23 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2872,7 +2872,7 @@ xlog_unpack_data(
 	}
 
 	if (xfs_has_logv2(log->l_mp)) {
-		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
+		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
 			k = i % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
-- 
2.49.0

