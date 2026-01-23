Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3555434B42B;
	Fri, 23 Jan 2026 07:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151834; cv=none; b=rVQXd0jtyEc78Qfm2UIsWogHLaSDa6dxkZhPxHaEC/zUeiwNZunm2fwzsfBdij40Ow9m6HNf5eYrc0bLouAkLVBx0s+qi15mfYI/+kJRpYZwZ21MYLnbH5IlCKTMktq+XFZyGiXVPcCmVd/lB3RnMBbEwLOjj3c/FvZo/irBv70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151834; c=relaxed/simple;
	bh=jyHVYNgljEdHCU7jt1JplfjHRVSBEiptHi076Qw9nv4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtE1tWDDSfxOl2lERe+rQW9T2O+KTbSUaCLwr09Pdn27IAR5N7W2hxsKzmDjldQcl1NVNh1FOIw6VPROOtFqnJ1p2z77soWQ4h3Y59iUxHfOGrypyYEI2YfL3bDpJ3omxM1hh4s5C0ZT1FyAly8hillxs75k1Hu1c6Fu3AEOH+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsR50MIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsR50MIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC9FC4CEF1;
	Fri, 23 Jan 2026 07:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151833;
	bh=jyHVYNgljEdHCU7jt1JplfjHRVSBEiptHi076Qw9nv4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XsR50MIEdIUnL1mDO1ljzgTRgVCvk4Vt0rYBV8FJ0v559DfG1yAzRkqq1Qx1tJn5I
	 QOvQodcTLPZwmKhcos8mf2t/alExOoWpWPNGWZCc1d3rgjVifGUV9mYFfvm1+2QpG5
	 aelRR+Ws+R7nEtmPNFoRPDSFZI9d7WUdEIz/0kvIxRj4bSoxxhXktw5USR/Ou6DjXU
	 54huZann8w9OViWV2Hyjjht5LdAzA4UCosDenkCmiYWCivJX5PhJSKiK2v9LYgOrJp
	 8YGewuR/ASND6oFTcTTi0Ts1uBFL0kjzIMELH86bve/euSzOGSKZJOS2XDC8fSJXDZ
	 W3s71q5eQtq+g==
Date: Thu, 22 Jan 2026 23:03:53 -0800
Subject: [PATCH 3/5] xfs: check return value of xchk_scrub_create_subord
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, r772577952@gmail.com, stable@vger.kernel.org,
 linux-xfs@vger.kernel.org, r772577952@gmail.com, hch@lst.de
Message-ID: <176915153761.1677852.10364914654449283291.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix this function to return NULL instead of a mangled ENOMEM, then fix
the callers to actually check for a null pointer and return ENOMEM.
Most of the corrections here are for code merged between 6.2 and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: 1a5f6e08d4e379 ("xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |    3 +++
 fs/xfs/scrub/repair.c |    3 +++
 fs/xfs/scrub/scrub.c  |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5f9be4151d722e..ebabf3b620a2cf 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1399,6 +1399,9 @@ xchk_metadata_inode_subtype(
 	int			error;
 
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	xchk_scrub_free_subord(sub);
 	return error;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index efd5a7ccdf624a..4d45d39e67f11e 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1136,6 +1136,9 @@ xrep_metadata_inode_subtype(
 	 * setup/teardown routines.
 	 */
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	if (error)
 		goto out;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3c3b0d25006ff4..c312f0a672e65f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -634,7 +634,7 @@ xchk_scrub_create_subord(
 
 	sub = kzalloc(sizeof(*sub), XCHK_GFP_FLAGS);
 	if (!sub)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	sub->old_smtype = sc->sm->sm_type;
 	sub->old_smflags = sc->sm->sm_flags;

