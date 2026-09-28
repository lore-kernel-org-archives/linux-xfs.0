Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFCF3A48CE
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 06:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576167; cv=none; b=BMShc9mRp3kp0Q0TyLcb3cc7tZT1sigjqtTYbCsHLMu400Kjdv73OALd2P6MzBaka4JqoDOSAucKVf/DuGFYxW3mL9SmbxYEOlkR83r3rE7C8LJB+hvf9NgxzFDgbB8OMyvO0URmdfb5iV9w+5HHnIe5wVNQrg9fBjkZp9sGkO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576167; c=relaxed/simple;
	bh=mlOZvaisM6+UXD1B0ZdCf/+/4bi5PieEeEInkVuejr4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=leYlEty3xVtXhc6oJm1/7Hyjg68YowTswkqdUjOO3W9GpKtgKfj6boZC0VjLUsaqqAOaJOyGqJPMA3Nl+RejYMGxoy4DtnNPBDgY2Yqnhnut8ZkF7b0zQns1q15vjLAkgFFw5nIvukA/1eo12atGMUoSMWDNkCGn5bZE203TUmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wt2PI9GU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wt2PI9GU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 557671F000FF;
	Mon, 28 Sep 2026 06:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576165;
	bh=P6qwlWCKqV6li8FJsoXoh0/nBMILA1ltlIeAELoEJuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Wt2PI9GU/RiX3pcEXTShMKjsug0TJ17h2/DlNb8i0Mcrv2KNxkr+WptpNG31noHke
	 aZT99kiZXxpBA9y1topLJ51CgHHlE04LVi8M8RFXOKjDPLV8342dlJaU4zycV88GBV
	 /rpz11yW2J5jWaADnGga3tMS7mRt+0gjoR2bDuL41U7Yv7jBiKRXH3qA02pl6TBFI+
	 nmGxfksOi0m3VMG1huWbCvSNeVAvEfhxBMNXnlwfe+bS43Vt2RpvGiIdaqd9ivJqk0
	 jk5KHPDsn0u1XYGhMNwQoau1OAuI/wsUNce4QfijKjGwxi9htgx5Xb4ZRRCoAxsK5b
	 CECvdpD9JB+hA==
Date: Sun, 27 Sep 2026 23:16:04 -0700
Subject: [PATCH 01/12] xfs: be extra careful about replacement directory
 construction
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179057612618.479634.3835896628058983547.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the directory repair code, we have some debug calls that check that
we never add a duplicate name to (or remove the wrong entry from) the
new directory structure.  LOLLM thinks that we should actually be
careful about that all users, not just the developer's system, so let's
do that.  We already had ASSERTs in the bailout cases to make problems
more obvious to the developers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir_repair.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 2cfcf1c35679ea..0164335cb5c1be 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -751,9 +751,7 @@ xrep_dir_replay_update(
 	const struct xrep_dirent	*dirent)
 {
 	struct xfs_mount		*mp = rd->sc->mp;
-#ifdef DEBUG
 	xfs_ino_t			ino;
-#endif
 	uint				resblks;
 	int				error;
 
@@ -774,13 +772,12 @@ xrep_dir_replay_update(
 		 * There shouldn't be any in the temporary dir, but we'll
 		 * verify this in debug mode.
 		 */
-#ifdef DEBUG
 		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, xname, &ino);
 		if (error != -ENOENT) {
 			ASSERT(error != -ENOENT);
+			error = -EIO;
 			goto out_cancel;
 		}
-#endif
 
 		error = xrep_dir_replay_createname(rd, xname, dirent->ino,
 				resblks);
@@ -798,10 +795,10 @@ xrep_dir_replay_update(
 		 * entry.  There should be a perfect match in the temporary
 		 * dir, but we'll verify this in debug mode.
 		 */
-#ifdef DEBUG
 		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, xname, &ino);
 		if (error) {
 			ASSERT(error != 0);
+			error = -EIO;
 			goto out_cancel;
 		}
 		if (ino != dirent->ino) {
@@ -809,7 +806,6 @@ xrep_dir_replay_update(
 			error = -EIO;
 			goto out_cancel;
 		}
-#endif
 
 		error = xrep_dir_replay_removename(rd, xname, resblks);
 		if (error)

