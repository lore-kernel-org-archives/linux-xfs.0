Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B4E32B109;
	Tue, 25 Aug 2026 05:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636128; cv=none; b=syN42tqPpUnGXumnogAY7YyCWUSRRZ2X5EWVjXmAReVSsDmxjfjv8qGc35xEomMRIe0sbNOWbbO7/pq8KjueWIdskMfwzi2+z7uHj6JY/+7P8mqGCZuOmdWSCYFonykVd9PwRUHrRCNqf7hyTsdr8mpicfwZAWooKqasBPgCiLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636128; c=relaxed/simple;
	bh=ubfqzGpFWY4MY3wSMowP13vUJmtAxmmNdWTd3mhLcIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WRacOiKnZxliGcUfgjSZHWJqBFfJpr3C2qJkSWLdZB53J7+xeJZfURAY0rMq6LkM08i7DZwvEiFH434jknWW7npubAexMibr0+cDwvMVBM0PybhXwBjBGxzSD/cyjdu8jEN04TaEveCAN7O/eICaHIIVJasDgZChEWNffPgLr7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIU0JIZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIU0JIZd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B7581F000E9;
	Tue, 25 Aug 2026 05:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636126;
	bh=qwyBGzhb6RiU4SFIYasX87DfEjTK2tIXYD5Uqnf5AIA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=nIU0JIZd9baSFD/sg9LfA+4jThjIeJgQ0tWRy8vSB6ihoC3BW6YoJrLXAOPns01iN
	 AboZYxxGK1w69K2yr8zknXUE0s+qx62jzBvDl0sJV19YJZgo2o936VbfuKfpkZjnBU
	 Zf7iUrLaf2jto9cZM4OCFHZBC1ZOVASzae/3fWWmTGFHD8i/5z48n5b+1wHbNVG6Wm
	 fiPD6tqKLf8yvEeKuUKMPag5fmvPIk96HOn8aRLLWweISGVBME3bLAxzBzb0V89N0N
	 gYmGdc1wdMAn9g3EySBPyqXqlPmuCd9owYrnxiSZEIeFvypkvKUe/FfpYTAFIenVOo
	 IVEt9mt5Rov1A==
Date: Mon, 24 Aug 2026 22:35:26 -0700
Subject: [PATCH 4/6] xfs: fix parent rec lookup initialization in
 xrep_metapath_unlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760940763.944084.16089302387459334065.stgit@frogsfrogsfrogs>
In-Reply-To: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that xrep_metapath_unlink looks for a parent pointer in
the child metafile that it's removing, but initializes the parent handle
using the child.  This is obviously incorrect, so fix that.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 0d2c636e489c11 ("xfs: repair metadata directory file path connectivity")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/metapath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index ff1ff762b3003c..9f44c82910eaef 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -397,7 +397,7 @@ xrep_metapath_unlink(
 
 	/* Figure out if we're removing a parent pointer too. */
 	if (xfs_has_parent(mp)) {
-		xfs_inode_to_parent_rec(&rec, ip);
+		xfs_inode_to_parent_rec(&rec, mpath->dp);
 		error = xfs_parent_lookup(sc->tp, ip, &mpath->xname, &rec,
 				&mpath->pptr_args);
 		switch (error) {

