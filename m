Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B94E368D7B
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 04:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309510; cv=none; b=Nq72Ysii9YcgwlEqVp/VRxSjj+zCBRp0jef3Tq0kIemjQ/W2dn6eXjNmZ7ERFdCWfYSdOyWsoWnK+NalEzPsBQnKdxeR1VoODHKVQtxrsNQdafqJDpzQBaEFyRbQiokIpLyGC2dXXGjdPvfy9M4QJ7avsvSJ4zKzp0zAbVASem0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309510; c=relaxed/simple;
	bh=yx2WAjio9XMvbHYTqFTTrb32hLl4fHDPqHVasmySlFk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5/9l7DZKR1hing3pdb8CF3C3ilxA/h3MpQCO/yp4Yd+ltXz+CosHrseAyWqCC6oJ7mIPzQIzeuUXafxKlpC/zGe1tOhbmwhRsZhSi+mZYqTwHEAou+c2nNx8fqqQX/re0hRj4WKD6O0OMorobLuqC/z8pCyVX72g4uGuPyvmtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hX+zCWPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hX+zCWPM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1485F1F000FF;
	Fri, 25 Sep 2026 04:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309509;
	bh=P5znDqmGq/q6cypKWrhKsz6BZ8g3bnJhpSq5+K+mtCU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hX+zCWPM4JtL2/foCpFcakilORJGMoEMCSlFmwLG1tpVJQVp61tFut8s1KiTnci7S
	 gvroMIOqgJqWGxy6m/yAsgLk/bm5G0IKo2QAUvBNVgRqRBPHLQaWKWabtgtkQ/FmPj
	 XJWgpNdg6s8JvkKxOgGtDxzMRSIl074dQAfu6zxwWbZLAc9mn/5EINTckndgvZz7qW
	 vYsAVMXHre6b1ILyJj3dWyS2CYDiPzBTIR33vcOb2waYS2k5G9fT1fFGp9hl4jXoYP
	 OzHs6Ec5fh50BEFYHEJ3bfuuRMc7/SkO8QwL+P4dFTGE5ymFFSEriYsQkSg/Ydy4l4
	 eWiAP5gYlj0tA==
Date: Thu, 24 Sep 2026 21:11:48 -0700
Subject: [PATCH 05/12] xfs: write the rt super immediately during repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179030932155.3344850.307719005695648802.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xrep_rgsuperblock has an unfortunate flaw -- even if the repair
transaction commits and is persisted to disk, a crash before the log
bwrite()s the buffer to disk means that the filesystem will not mount
after recovery.  The xfs_mount keeps the rtsb buffer live for the
duration of the mount (scrubbers hold a file open on the fs) so let's
write the buffer out immediately to shorten that window.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rgsuper.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 6e2abe5dc27cd5..2db92cb89cc614 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -91,12 +91,28 @@ xrep_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_buf		*sb_bp;
+	struct xfs_buf		*rtsb_bp;
+	int			error;
 
 	ASSERT(rtg_rgno(sc->sr.rtg) == 0);
 
 	sb_bp = xfs_trans_getsb(sc->tp);
 	xfs_log_sb(sc->tp);
-	xfs_log_rtsb(sc->tp, sb_bp);
-	return 0;
+	rtsb_bp = xfs_log_rtsb(sc->tp, sb_bp);
+	if (!rtsb_bp)
+		return 0;
+
+	/* synchronous transaction to flush/release the buffer log item */
+	xfs_trans_set_sync(sc->tp);
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	/* write the rt super out immediately */
+	xfs_buf_lock(rtsb_bp);
+	xfs_buf_hold(rtsb_bp);
+	error = xfs_bwrite(rtsb_bp);
+	xfs_buf_relse(rtsb_bp);
+	return error;
 }
 #endif /* CONFIG_XFS_ONLINE_REPAIR */

