Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E43A234994;
	Mon, 21 Sep 2026 06:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971378; cv=none; b=GRSDleieV1iu+z7XUl+PnJrBhwEkIW/s+I9vHjsQNBcePaOqdPO25HwZiyDYibDujGmw+/WNC5IWjLnIQXpcS7IHX6Mm52f3gDzA1PMbajHDIwJRLeI4k87y/qY6gKe7HadDpiElmH+k9iVQtddza7P/enH2R5R+MpPaV0nTgu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971378; c=relaxed/simple;
	bh=chKTPhNKC5GTZqHlFrSZdHiFGL37y8E669PyY7f47EQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hx7D/xwYGzmRLr1YRw9zJuMm//wqbpPu11reL72K51bhe9PoQ1SKiwf+aqaCwAXudzq62tWq8KP/ISxtOi2YMHOerbWNqa+bYzTaT+5rXoNglyImd9LbzlW2N8IcwTKl9Q2uCe1kufNTkC2T2xcWnCY3eRJGiJT3H4GIOtkbmxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VfEPl+Ou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfEPl+Ou"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 65E641F000FF;
	Mon, 21 Sep 2026 06:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971377;
	bh=APGdcctzhEZeBLA1z90JxBZE46TXwOJOr80TaCAxAM8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VfEPl+OueHJSkaMlb0rYJ7uPO2x2ZpvWv8QFrWa4+X3MZuTQDPVO6S0JPKEPdh4JS
	 B9bg3Ozb2Wy7pCSBT6i2+qQxaEW7yojUIIstDbpWHEp5M/V0TE/t/ojOi/JpHGcdkx
	 fG3V/XanV+KY7b7NWLRbspmbfKnCw86lsTuOaoJ4B7CxpG5LzQ8duwRKynRva6NhKz
	 /5cjsr8NpR1bXCxsy9ujM00E3LNNIQ/YYiU6IlYPIVppBiHzqRavgJXav3Lxa3otq4
	 /oTxGV425QtAeYpgcXHZ1x3k4JbeHODnWA9OhtSLwsrCHm1mkYOrFxVl3tsDa5+zMd
	 04xwtyEJu0+GQ==
Date: Sun, 20 Sep 2026 23:16:17 -0700
Subject: [PATCH 05/14] xfs: pass xfs_trans_resv object to reservation
 calculation helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120658.181988.9146739765881528995.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs_calc_namespace_reservations computes the directory tree related
transaction reservations for a given xfs_trans_resv object.  The helpers
it relies on, however, read the live one from the xfs_mount even if
we're doing this for minlogsize calculations.  In practice this
shouldn't be a big deal since the minlogsize and live reservation
objects don't differ in a meaningful way, but LOLLM complained about the
inconsistency so let's fix it anyway.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 7dba4a5fe1c5cd ("xfs: extend transaction reservations for parent attributes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/libxfs/xfs_trans_resv.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 3151e97ca8ff6d..1c20a7c27aa1bf 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -606,10 +606,10 @@ static inline unsigned int xfs_calc_pptr_replace_overhead(void)
  */
 STATIC uint
 xfs_calc_rename_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
 {
 	unsigned int		overhead = XFS_DQUOT_LOGRES;
-	struct xfs_trans_resv	*resp = M_RES(mp);
 	unsigned int		t1, t2, t3 = 0;
 
 	t1 = xfs_calc_inode_res(mp, 5) +
@@ -715,10 +715,10 @@ xfs_link_log_count(
  */
 STATIC uint
 xfs_calc_link_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
 {
 	unsigned int		overhead = XFS_DQUOT_LOGRES;
-	struct xfs_trans_resv	*resp = M_RES(mp);
 	unsigned int		t1, t2, t3 = 0;
 
 	overhead += xfs_calc_iunlink_remove_reservation(mp);
@@ -777,10 +777,10 @@ xfs_remove_log_count(
  */
 STATIC uint
 xfs_calc_remove_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
 {
 	unsigned int            overhead = XFS_DQUOT_LOGRES;
-	struct xfs_trans_resv   *resp = M_RES(mp);
 	unsigned int            t1, t2, t3 = 0;
 
 	overhead += xfs_calc_iunlink_add_reservation(mp);
@@ -862,9 +862,9 @@ xfs_icreate_log_count(
 
 STATIC uint
 xfs_calc_icreate_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
 {
-	struct xfs_trans_resv	*resp = M_RES(mp);
 	unsigned int		overhead = XFS_DQUOT_LOGRES;
 	unsigned int		t1, t2, t3 = 0;
 
@@ -911,9 +911,10 @@ xfs_mkdir_log_count(
  */
 STATIC uint
 xfs_calc_mkdir_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
 {
-	return xfs_calc_icreate_reservation(mp);
+	return xfs_calc_icreate_reservation(mp, resp);
 }
 
 static inline unsigned int
@@ -940,9 +941,10 @@ xfs_symlink_log_count(
  */
 STATIC uint
 xfs_calc_symlink_reservation(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
 {
-	return xfs_calc_icreate_reservation(mp) +
+	return xfs_calc_icreate_reservation(mp, resp) +
 	       xfs_calc_buf_res(1, XFS_SYMLINK_MAXLEN);
 }
 
@@ -1265,27 +1267,27 @@ xfs_calc_namespace_reservations(
 {
 	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
-	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
+	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp, resp);
 	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
 	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
+	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp, resp);
 	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
 	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
+	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp, resp);
 	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
 	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
+	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp, resp);
 	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
 	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
+	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp, resp);
 	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp, resp);
 	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
 	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 }

