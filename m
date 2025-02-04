Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE0C166F32;
	Tue,  4 Feb 2025 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695082; cv=none; b=HDhIov482Wfe6cokdx/CKRefvhISQwn9Cj54G7C6ovd0Na5kHUOcnJBXhnPVwyhpd6x2kEuLIMT3o97zm4v3et/Gii/4g8ykmOxYc3gKI6LrCZKutUi+Jhsx2g8PIFJjzuW4qQHRcPLrXSPgz59ZCEYKt/zer1KWlmwRQKCZ2no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695082; c=relaxed/simple;
	bh=hyR0EhSruuSRq1Cir/Qs5wUtelxx3H+TAjU03aQ8hjs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ou6sMNi3CQa6boj5CYGjsys2sguDXiscRihZJJiL3Uvhrxwpn+NsovunAwS77zlmnZQZYunpPpUQFNBcPy4DLbFbGsDH9kqRMFchAcHnAcL2V7oTB2n6hoGS9+rC5h1Fsf/lcYfiqQ65nlkD6kTWuFbxG/JFs255PDFooOmhh6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drRRZ+FZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drRRZ+FZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CAFC4CEDF;
	Tue,  4 Feb 2025 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695081;
	bh=hyR0EhSruuSRq1Cir/Qs5wUtelxx3H+TAjU03aQ8hjs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=drRRZ+FZe62b+3pO24WJD4GTCZYzV1GY+b9sFq9Vbf1kj+EsdJm5rcluED1akVh7R
	 7UwbBx19pBTM9NPlD7o9lw95rGz1Eh4M0HAwcY+T8I8CV3Y0/GZxE0mSOwqyJQMYy0
	 7pH6JnwP1p1CwHwfP/fSCJDVZgkZr2lFcaNkMoahBuNbEgxA8hbGXAXf68Lk9pmfnN
	 Lt9CZhbBtnpNMBqZI5xM84R7M+VdQKOvx/BOm5J24D1KSoA0kPbrZ25Dcbn8Dvikv+
	 3Q0mqdcSSsncFDlYp0zix9i/BJ4DCsf/dxf37v/kAtmKefCmfUqr27mZVA89m+W6de
	 CK0h0lS70M6Bw==
Date: Tue, 04 Feb 2025 10:51:21 -0800
Subject: [PATCH 01/10] xfs: avoid nested calls to __xfs_trans_commit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: hch@lst.de, stable@vger.kernel.org
Message-ID: <173869499359.410229.16535171441757027813.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit e96c1e2f262e0993859e266e751977bfad3ca98a upstream

Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which calls
__xfs_trans_commit again on the same transaction.  In other words,
there's function recursion that has caused minor amounts of confusion in
the past.  There's no reason to keep this around, since there's only one
place where we actually want the xfs_defer_finish_noroll, and that is in
the top level xfs_trans_commit call.

Fixes: 98719051e75ccf ("xfs: refactor internal dfops initialization")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 30e03342287a94..001d9bec4ed571 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -834,18 +834,6 @@ __xfs_trans_commit(
 
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
@@ -924,6 +912,20 @@ int
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
 

