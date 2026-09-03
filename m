Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EF21E1DF0;
	Thu,  3 Sep 2026 05:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414729; cv=none; b=mWXMWkKBdpWmRFXAAnMF+xk++3DwAOBgKH+ow6CxslTStDA/rdkSq8SXyMoRSdIGkN6fCrSGsZSzWjThYcrg4Xn5qt4VbpY06mScCh54oQ/7q3m+oEdXw8dJ3ipu7XsUFSsFPxjX4Mk5+PmWnDlGatxtwY5OO28suEcGCBLPxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414729; c=relaxed/simple;
	bh=1vyF+4vm3zah/64nHPUQYr2c8yBGN7MK9LRp9Z1z9Ik=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BD4RjxAq08P98cTKtNs1vumS05gBtnTUPdN5O6uiKm4dedrauSKfz5Srhl4chMeQaGNigYgp9C7aFWAMT6K5qAGWuqbdemB3pZpHUuq/5bD5/5wtANYIkANLuV8me8tWcPlXzhb6iiR2QR3SJaNj+WGb3mmM3dUdiDuZgNeTb3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDLXW3Pi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDLXW3Pi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1FA5B1F000E9;
	Thu,  3 Sep 2026 05:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414728;
	bh=1u5INRTJ205j2TlBumW0Ol3SHMAs1WdTKihTywLN2GE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LDLXW3Pi47fx2caEj+fpbZxGuZuDn9JJWhEQRvFuF2ZNWZwJHNNSsmfd0z7FdIDm7
	 2GX6noiHTz6Qv6zq76KS0cCRp9hKuEDwPUayhexVffrqTpjYdLJIGclLa/qxtuif6z
	 bltobcmdzr7f2EfmgVbIlIn2sCD1PhZhNeqjZCiGmtNAHlCEt/SG1yG5Nae1x8f4x6
	 JU/UuPNE3mgtxKq+IH/Ih9wRlNylXxLRBFQpCdekOsJzqJurrOJ7cwkVblkfT48AJm
	 FEYxq941b1nyvP6wNANw7KOu0QLS4jSTIdKr37Rz9OMbti7j53FiTA8EtM7RQaD1fO
	 Q2zZO00RYTSuA==
Date: Wed, 02 Sep 2026 22:52:07 -0700
Subject: [PATCH 5/6] xfs: make the rtsummary repair fix the file size too
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178840969935.484660.8039849140582704928.stgit@frogsfrogsfrogs>
In-Reply-To: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the rtsummary repair code will create a new rtsummary
with the correct file size, but it won't force the new file size to be
set on the existing rtsummary file, leaving the rtsummary corrupt.  Fix
this by setting up the tempfile mapping-exchange to run to the end of
both files, which is the magic offset needed to reset the file size.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: abf039e2e4afde ("xfs: online repair of realtime summaries")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtsummary_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index f065c3e51ce2e4..ed763290aec1e5 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -164,9 +164,10 @@ xrep_rtsummary(
 	/*
 	 * Now exchange the contents.  Nothing in repair uses the temporary
 	 * buffer, so we can reuse it for the tempfile exchrange information.
+	 * Use XFS_MAX_FILEOFF here so that we correct the rtsummary file size.
 	 */
 	error = xrep_tempexch_trans_reserve(sc, XFS_DATA_FORK, 0,
-			rts->rsumblocks, &rts->tempexch);
+			XFS_MAX_FILEOFF, &rts->tempexch);
 	if (error)
 		return error;
 

