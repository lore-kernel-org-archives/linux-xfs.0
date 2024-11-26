Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A075C2C6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584518; cv=none; b=YzijCO5smnA/Do80RASTV20LSODKEK07KLzIxXZ/vllNVk4g2iuv3n+Wkgb+uB7/OPfMayCu6uRKffxN6h481PJxiul5HUhB323IvCl8NbQk8bTlqtKYflVMNtiihpFL6n1iV9yG2tTCDX3BAtTD6mqADylFkrKM0bDyQ7YL66c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584518; c=relaxed/simple;
	bh=ckZ3RAz3S7mV5m/xGTWZGQ1tVjF9sdvxF+ZdCjAr4Z4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FQnyVE8rbLC8TW3dRyKdWTm519tRoHvIIWF+7w/27o6axyNEzCGSFuQveDgaJVshp2GNzR0FROSk4dZd3lsbiL7La9X0befAK0wdOxUm5kxkX10eF3QsdZKmmb1iMc4WP93KsGtoUEnHuiIHFJ740KlgWzbqqFecbyII/2U/DEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlnpnwqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlnpnwqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E7EC4CECE;
	Tue, 26 Nov 2024 01:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584517;
	bh=ckZ3RAz3S7mV5m/xGTWZGQ1tVjF9sdvxF+ZdCjAr4Z4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hlnpnwqF2YmaCF51JCzHXjPmslDk4Imi9mkICMSfqlz2ICzmb6fD39I09ehCj7UsH
	 t9WLeUi53UFYdqDr0jcP3xjYJ3LR3ykGVCG0J9Y+NwZYl9pBro0bcD/DrDC7p0A8Jl
	 KKxIgr+TgA/LV/LmJrajSZXr1o7NlA2igEwDUHL7RkRY6ULuifaKXDUR4Fh9NGK5LU
	 nNdc4hkkYGQ/iRPm+oTJaqt4h1Xn5IBJlrc/YoiZ2oC61rEPWm3X15SQMlPJM6vAFy
	 +sjhTWMMCSlruEjlcMMuTWpZwJWsdxoPeAJhS+9WDUZRugwm//NHMW+qx9rk63O7uE
	 goNsoKoj6dRkg==
Date: Mon, 25 Nov 2024 17:28:37 -0800
Subject: [PATCH 15/21] xfs: remove recursion in __xfs_trans_commit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173258398059.4032920.3998675004204277948.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which calls
__xfs_trans_commit again on the same transaction.  In other words,
there's function recursion that has caused minor amounts of confusion in
the past.  There's no reason to keep this around, since there's only one
place where we actually want the xfs_defer_finish_noroll, and that is in
the top level xfs_trans_commit call.

Fixes: 98719051e75ccf ("xfs: refactor internal dfops initialization")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4a517250efc911..26bb2343082af4 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -860,18 +860,6 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
-	/*
-	 * Finish deferred items on final commit. Only permanent transactions
-	 * should ever have deferred ops.
-	 */
-	WARN_ON_ONCE(!list_empty(&tp->t_dfops) &&
-		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
-	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
-		error = xfs_defer_finish_noroll(&tp);
-		if (error)
-			goto out_unreserve;
-	}
-
 	error = xfs_trans_run_precommits(tp);
 	if (error)
 		goto out_unreserve;
@@ -950,6 +938,20 @@ int
 xfs_trans_commit(
 	struct xfs_trans	*tp)
 {
+	/*
+	 * Finish deferred items on final commit. Only permanent transactions
+	 * should ever have deferred ops.
+	 */
+	WARN_ON_ONCE(!list_empty(&tp->t_dfops) &&
+		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
+	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES) {
+		int error = xfs_defer_finish_noroll(&tp);
+		if (error) {
+			xfs_trans_cancel(tp);
+			return error;
+		}
+	}
+
 	return __xfs_trans_commit(tp, false);
 }
 

