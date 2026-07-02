Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A338E12A
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022703; cv=none; b=MN0z0YB14MDRRN45IQBfP4e3Jjw3QjJ/E9VtzsIH2eCV8ryG95TPrbCn/BkzZYcg3xfolntA8h6WLELR64c4+hyvI5o9QA5Gf2zj6Efh2OxpMDlAbtx83NtvHoxJ6pZwfjTg6hgOpxwvNqL2Vu+G5ujtWNksv9n+ihmSBJQBwNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022703; c=relaxed/simple;
	bh=kf+UkZyVRlZ7KFHRmwyXB8C8IqNqQz0ky4e9fev+snE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjV9B6B46BXdqYLenOEiaW0yVKddHtTNZshK7PSaKnpK1sGmTVFm7R0kqyEy6GpSv1gCTfPWiiYlD9M2eIyhTekK60u7SSgjDtTQPP9jmdUxFetVI2iyIQnDi2Pm+Six5Yo29KU4O0NxL4763D+4eD00nmlxizKd/ol+5d7TjsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yp3bvUcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yp3bvUcD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 42F601F000E9;
	Thu,  2 Jul 2026 20:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022701;
	bh=VUSzMnIJkHwpZs+T+SL/470fT/3Fp7p4Rsqj1BYQZ3s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Yp3bvUcDA7ZX8PP2DQxVZJSnXDh5Rb2XGwaOT2x7zL3EwRYyR0wq/M+4jDb6BG5us
	 aGCUky0ev1RnQbgPG054sK21EBUgLikD4JAA9f1LMzOjTCCb6u32ZV6iKdtOmr21GE
	 yTIKXhqudKyDV5r/NLVTHi77dJSoIxYGstchrP6lfcnkgzwXIL52Pf01VtE3uooKUd
	 scWrl3Oy/T80actZYa39HLMBgkn0lz/OSc2BSgk6ungQEg86iG55f2n/v+H8Kc2Z/g
	 63LaKWQT2q4DZQ0t0t0uqiPZzFoPjWwMHZmAvSB8KEfj+/D+rjh7O4nDRW4xgAmZhp
	 epvyVAfP+/4GQ==
Date: Thu, 02 Jul 2026 13:05:00 -0700
Subject: [PATCH 18/18] xfs: move XFS_LSN_CMP to xfs_log_format.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226639.845537.7466057755976951539.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 202ff980a464198616e53e85e5276e68c00a1031

Because CYCLE_LSN/BLOCK_LSN are defined in xfs_log_format.h, XFS_LSN_CMP
forces a xfs_log_format.h dependency in xfs_log.h.  Move XFS_LSN_CMP
to xfs_log_format.h and drop the macro/inline indirection to clean up
our header mess a little bit.

This also helps xfsprogs, which doesn't have xfs_log.h, but needs
XFS_LSN_CMP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_log_format.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 3f5a24dda90701..a4e1b3eb425cda 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -52,6 +52,19 @@ typedef uint32_t xlog_tid_t;
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
 
+/*
+ * By comparing each component, we don't have to worry about extra endian issues
+ * in treating two 32 bit numbers as one 64 bit number
+ */
+static inline xfs_lsn_t XFS_LSN_CMP(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
+{
+	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
+		return CYCLE_LSN(lsn1) < CYCLE_LSN(lsn2) ? -999 : 999;
+	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
+		return BLOCK_LSN(lsn1) < BLOCK_LSN(lsn2) ? -999 : 999;
+	return 0;
+}
+
 /* this is used in a spot where we might otherwise double-endian-flip */
 #define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
 

