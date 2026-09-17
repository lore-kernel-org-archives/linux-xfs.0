Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142774B95D4
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 10:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641410; cv=none; b=L2WcOtUR1Y3jedl0iM/qQCubtWFUfZDzmnJejnG6Br/fYmrcP/bRiulqBc60xQu9igs3FZTyVaVsW4Qs59v8bGDHCYudXIT/RsHY9bZr+V25LeWSebuI09F7qMSb5LEoLDsGRPuTmweptNLl6pBVVSjigZqV8rg/fIacWtWq5M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641410; c=relaxed/simple;
	bh=WZ2uytSpAMSG6cvdzphtTRWyigy4SqHxXROXrtoOwcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hufDys0wcV/oYXOQm6GtTh44mselbT6Dbqz3QzlbjHN/dO4e23WS8aocdLyzirWLUUlr668+9r+JmFjjI9UdkzgeMIbRib2vXMXlBczEaEakJjz872rZKo7TMMlROtLQzce+y78IFmWxDYSlf9BAwQclZ6rwXCDE1P+eCIOjKTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/i8gyUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/i8gyUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E47D1F00899;
	Thu, 17 Sep 2026 10:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789641405;
	bh=H0+IB18JXScb2yICODoIZ8tewcgYs+kJqtoE98ws1S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/i8gyUnU+KZAnL/O2+FoXpmRCUhmIMYSos7OpwoqUU/jihrUtle7Kcrof6wCHgbL
	 x8pVUQpYyLpIMmA+MFHywKNuJZisHfIlvsIhRxpB7E+22SFIo4iVcqGhbEbveYLoJf
	 WwgBF1+DSDItvlmkASJtyVATx+c0cx5bUbySMsHAzxMSbZIfwloOkipn5Dap7TOTqN
	 l6y7c9IVmuZIiUiq+RoB/0Eiu1DcuWsdP+WmbSmtgAb51RXlxkkTrErdu+2V8g5tVX
	 JizgtvtBtAgRjuKCHyNqVKoLHGqRyVYb3oLvHCdB0WWd+FIGwExHncBABgKaEQ5jm8
	 VfDLnwF0tLzDw==
From: cem@kernel.org
To: cem@kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/3] xfs: enable xfs_trans_cancel() to report and error code
Date: Thu, 17 Sep 2026 12:35:47 +0200
Message-ID: <20260917103633.14703-3-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917103633.14703-1-cem@kernel.org>
References: <20260917103633.14703-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Once in a while it's useful to know exactly what kind of error caused a
transaction to be cancelled.
Enable xfs_trans_cancel() to receive an error code to be reported.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
V3:
	- Kill typedef from __xfs_trans_cancel
	- Remove uneeded wrap of parameter 0
V2:
	- Parenthesize macro parameters

 fs/xfs/xfs_trans.c | 8 +++++---
 fs/xfs/xfs_trans.h | 6 +++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 5c522790e5be..395c896673fe 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -943,8 +943,9 @@ xfs_trans_commit(
  * xfs_trans_commit().
  */
 void
-xfs_trans_cancel(
-	struct xfs_trans	*tp)
+__xfs_trans_cancel(
+	struct xfs_trans	*tp,
+	int			error)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xlog		*log = mp->m_log;
@@ -971,7 +972,8 @@ xfs_trans_cancel(
 	 * here.
 	 */
 	if (dirty && !xfs_is_shutdown(mp)) {
-		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, 0, mp);
+		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW,
+				 error, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index eb83c5dac032..36a49622b870 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -213,6 +213,11 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
+void __xfs_trans_cancel(struct xfs_trans *, int);
+
+#define xfs_trans_cancel(tp) __xfs_trans_cancel((tp), 0)
+#define xfs_trans_cancel_error(tp, error) __xfs_trans_cancel((tp), (error))
+
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
 
@@ -237,7 +242,6 @@ void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
-void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
 
-- 
2.55.0

