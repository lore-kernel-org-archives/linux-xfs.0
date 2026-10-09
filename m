Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C730369D71
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589758; cv=none; b=Kk2SC0JivXcXwNElufDe6DqusBkY5frn2eMeSQyFEZOzVm5cdUQoGCKRES5gANOjLDRhBN2f+5jM0Fz9Uvcp6c47gaixKjMyljfZk40sFggKbOPL/RqxF4WeUCjqXPxyfxy132cQZ1O2kCWUb+CKPi+65T+up+mEjgh1UAoyh0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589758; c=relaxed/simple;
	bh=LTHJjFGGVVITQ6Igx5e4IbuKwod1mku67rhWA+V3ybU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OtJg6Zqbhs/ALEpdMgGgSNOuhS2K0xCII7/Rho6o7Z3XbHYNvpMHgkkCljxr1tt4dhFgrq3GGhUSziHZNM13I2EHevC+fGRibsf78bp7IO1EgxCuB6K4ed/jzy/oraEsWi1R1307l9qTXpMvYzDaRON/b8USfoxliFJGzXSUmxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVOJmFMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVOJmFMC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 23F101F000FF;
	Fri,  9 Oct 2026 23:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589757;
	bh=aHJOgELyw0qD4uGLfnyBw5p8MW8+zr5hYyuIafNjxXk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gVOJmFMCocy3ljE5E/rSPBpDSt9aBAADYv8yVZg3k52WAwyXIlbndbRC9/vPl4aBN
	 xVRyN58k/5oxKS6uoBx/EbYNNjCOsJ3a/dnGebuWYBE59zMQ+7cSSByIk6ysNai3rp
	 J6qO5TMOc44QHs8di1nAqaP3tUWidzFW0dd+mNDyqCJUIIQ5W65+BnQ19W0nVmWiJq
	 Qqw9+jn1Tg3Mr5nlDrmZtcXetXJJPjV0AE3B/UOKAX1XQCY5eBoMwlRMleyfhD1MpD
	 +7parrwKmBNWuDQOM93babMNNGobSJ3DfAloimMGg1fj0PHRhXhppjGxfGUk93/CXX
	 zA0eNgraJNGzA==
Date: Fri, 09 Oct 2026 16:49:16 -0700
Subject: [PATCH 14/26] xfs: report the error that made deferred work shut down
 the fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, floss@jetm.me, linux-xfs@vger.kernel.org
Message-ID: <179158947623.3719791.6698077877293765794.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Javier Tia <javier@peridio.com>

Source kernel commit: d058f24b163a8d63866ac6bbe5f06b41aabe97d7

When a deferred operation fails and shuts the filesystem down,
xfs_defer_finish_noroll() reports neither the errno nor which operation
originated it, so the log cannot tell a transient -ENOSPC from real
corruption.  Report the operation type, errno and remaining reservation.

trace_xfs_defer_finish_error() runs after xfs_force_shutdown(), which
BUGs under fs.xfs.panic_mask and so never fires for the first failure;
move it ahead of the shutdown and mirror it to xfs_alert() for systems
without tracing armed.  Capture the op name while the item is live (dfp
is freed once its work list drains) and suppress the alert once the fs is
already down.

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 3f53cd41235229..5cdb3e2ceafcb0 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -649,6 +649,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp = NULL;
+	const char			*what = "chain";
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 	LIST_HEAD(dop_paused);
@@ -698,9 +699,17 @@ xfs_defer_finish_noroll(
 				struct xfs_defer_pending, dfp_list);
 		if (!dfp)
 			break;
+		what = dfp->dfp_ops->name;
 		error = xfs_defer_finish_one(*tp, dfp);
 		if (error && error != -EAGAIN)
 			goto out_shutdown;
+		/*
+		 * A finished item is no longer a candidate for a later
+		 * failure.  An -EAGAIN one is not finished, so it keeps the
+		 * attribution across the roll that completes it.
+		 */
+		if (!error)
+			what = "chain";
 	}
 
 	/* Requeue the paused items in the outgoing transaction. */
@@ -712,8 +721,12 @@ xfs_defer_finish_noroll(
 out_shutdown:
 	list_splice_tail_init(&dop_paused, &dop_pending);
 	xfs_defer_trans_abort(*tp, &dop_pending);
-	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
+	if (!xfs_is_shutdown((*tp)->t_mountp))
+		xfs_alert((*tp)->t_mountp,
+			  "deferred %s work failed, error %d, %u blocks reserved",
+			  what, error, (*tp)->t_blk_res);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
 	xfs_defer_cancel(*tp);
 	return error;

