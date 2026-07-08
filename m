Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7094C6F04
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783532703; cv=none; b=IUXPSARgZnvLkZuftaxbYRUTlWyiRI3p8V+Sw/LrKpN0QYOGCondxy5M1AyouWfRCT41jwDojLdxGvGHHwOlYGRwCcoKwmtkeEs840vhKTwGNUrPS4eWVjTwEFqJ5zZgSddBpWmHDT6cQLvup//NoXAt77eBXh2ugQJgtoX1REc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783532703; c=relaxed/simple;
	bh=0/WAoO3EVGRoBh6aWbxUDXHoSVwAwyew5RFoBbIad0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tG1Dn+fzGNQ1YcpiP4uSgo+pfHiuDreRYT2qA7zRTkPj8lbovvE87e6QILGkDDBhTYUjzZmd6cihTbvIFyAxQJ1d6W8b3IuziRsbzUhQWrjOlWMEiG8cfno0pmER/YkAFMGXGcUZ87bAKCm/62IKvqeKQB2rUmJqGkSgKTMUfwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRAA+lB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRAA+lB+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 380041F000E9;
	Wed,  8 Jul 2026 17:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783532701;
	bh=SwKpdQg+TPoFl0kEnbfxWAKb8dF4h7VBO+whPvmQ6lI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TRAA+lB+svlscf8gwO+x1pQQ2gjHRj4Hd3hwYTVLEMKKqmBayu1Oe1VxTjiGZRdZn
	 Os/1XilmMW/Wd36+wVDF0GwtxueGNI2ugr47WF11MZewXeWM+BiNJJgk5KWDvHFMAa
	 0b2VU35obGrLS9T34qXu0ofRCKjJ8Ww02jlg/m63MUnEycooozqDEUe0qyDyURT6LJ
	 GsRTIx8uJQa2X5FK2Ex0fZMCar9S0fT0wCbWvclvFQGNV7rulBoBBKa+bA84stP/og
	 QEfME43gCX9+5nwctooyj0dHK5sjmEULJQROJpzlIc9ci9bnUDRlS+S1xttKDEx0AW
	 hIB4k6gu8nSzA==
Date: Wed, 8 Jul 2026 10:45:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 18/18] xfs: move XFS_LSN_CMP to xfs_log_format.h
Message-ID: <20260708174500.GH9392@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
 <178302226639.845537.7466057755976951539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178302226639.845537.7466057755976951539.stgit@frogsfrogsfrogs>

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
v1.1: remove old code from xfs_trans.h per review comment
---
 include/xfs_trans.h     |   18 ------------------
 libxfs/xfs_log_format.h |   13 +++++++++++++
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d4b546a0e3d026..9102bc6f5b27f3 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -164,22 +164,4 @@ libxfs_trans_read_buf(
 #define xfs_ail_get_push_target(ail)    \
 		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
 
-/* from xfs_log.h */
-/*
- * By comparing each component, we don't have to worry about extra
- * endian issues in treating two 32 bit numbers as one 64 bit number
- */
-static inline xfs_lsn_t _lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
-{
-	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
-		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
-
-	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
-		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
-
-	return 0;
-}
-
-#define XFS_LSN_CMP(a, b)			_lsn_cmp(a, b)
-
 #endif	/* __XFS_TRANS_H__ */
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
 
