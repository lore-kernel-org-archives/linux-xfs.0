Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB03CEDE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881734; cv=none; b=VgMS2AK8RoLWaRDN/1yOsSdT2xcALmXfwvXYGZrQoh/rCiG/uHj4A9ZMAmZZCET+7zDQps+v6zU/zUiLSAez7UhGlJWIWZQHcmgqjljLeSpzjACobodd0YqzPObfHT1+wJrQscNW6/inPKljZSF3/WaNKXxdtkxu78Yrlg3XWIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881734; c=relaxed/simple;
	bh=jJseJ5sV9RLVL+Ozw8qF/CtwyDTYN+sHuQObOmVizwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JS5MOvoLlm3bp88kpUz49qRiyPCAiMMbkydx+mWNoGHcFUJvw4ul+sFCh3VLYiVqHssExCe/NfC65TCxGcjFwwBwEtsm2+sOO2LCyAfFtJg5Yr6BX4YkXN3a4YsnSzO28vTV3agf+Kh1PHtlJLxpJk/iK1P4JSsGMNv/TLrjqZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ab1BABdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ab1BABdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A10C116B1;
	Tue,  2 Jul 2024 00:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881734;
	bh=jJseJ5sV9RLVL+Ozw8qF/CtwyDTYN+sHuQObOmVizwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ab1BABdxRQV2/QpqySTycAD8wSf+0YQCoc5YvOWKXtQKCNkgqhJZ+BQeZ6RLmlQIz
	 om1Pn+kcrSvKeFmFw14zlAFWfZGZUsaexuZ6TuOBa+tYnPIP3bpxFZAHMk7Qt/tSzn
	 be1aji695Gh1CW/VHskXftf4ZWrEI0RjlnTXndjzX/uQ5KdkQxTxODk/bL7CpiiRUO
	 L/XZUfHa7vjqOO5r4lwk8os68iTmuYHE3Jyt/NbMNBrr24Ds0IW9QQEHv5ga59Oh6G
	 LB2IULbs+o7r5zuFf380FWltA5wmYH/we2uEpekCY6zV4kdEnXfj/2oPEnEeAjUuJv
	 OfPDdkQUT87ng==
Date: Mon, 01 Jul 2024 17:55:34 -0700
Subject: [PATCH 08/12] xfs_fsr: skip the xattr/forkoff levering with the newer
 swapext implementations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116831.2006519.7545128226159019978.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The newer swapext implementations in the kernel run at a high enough
level (above the bmap layer) that it's no longer required to manipulate
bs_forkoff by creating garbage xattrs to get the extent tree that we
want.  If we detect the newer algorithms, skip this error prone step.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fsr/xfs_fsr.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 2989e4c989bf..7d0639868258 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -999,6 +999,20 @@ fsr_setup_attr_fork(
 	if (!(bstatp->bs_xflags & FS_XFLAG_HASATTR))
 		return 0;
 
+	/*
+	 * If the filesystem has the ability to perform atomic file mapping
+	 * exchanges, the file extent swap implementation uses a higher level
+	 * algorithm that calls into the bmap code instead of playing games
+	 * with swapping the extent forks.
+	 *
+	 * This new functionality does not require specific values of
+	 * bs_forkoff, unlike the old fork swap code.  Leave the extended
+	 * attributes alone if we know we're not using the old fork swap
+	 * strategy.  This eliminates a major source of runtime errors in fsr.
+	 */
+	if (fsgeom.flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE)
+		return 0;
+
 	/*
 	 * use the old method if we have attr1 or the kernel does not yet
 	 * support passing the fork offset in the bulkstat data.

