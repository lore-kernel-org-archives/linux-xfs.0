Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5351C2563
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530696; cv=none; b=DTAvnHsrgfsdih0GJgS7jRvq8j4kwxQJ/8M/hvnbTo0W2SzhlrMisXKxAuWKYtttrlxiJ2rwSkaEWr3aMpXGfz8n3hQT9X91+2FxEzKffDgFm0SyKx0W2evXeJ94tPV1pMzunHpN1lIrAHKOcuOknLTym5fTf2aZIQ/GN4Kn+MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530696; c=relaxed/simple;
	bh=7coKNW/H5VSgE6DB3Kw3Vpuio22A5n8yJOtX8lt5fXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KFSTSu9vtE84atgc6EkXcKh9yMkINgbhVzl2s1UJmooonMFs85KtflB8GTnG3xsHUp6iT82gHt0R40pIsWAwmCua8tdX66TAVuGKi1U2Av0U7kJkW/NDt9bjxBlXcxB4et5TUFm/F0GBY9xA6f3Fi4ZaovHM7zI1nh6EZuujoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UniMToEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UniMToEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F92C4CED1;
	Sat,  7 Dec 2024 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530695;
	bh=7coKNW/H5VSgE6DB3Kw3Vpuio22A5n8yJOtX8lt5fXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UniMToEWLkdvTtBCwj04aQMacdsiVdepH0KVYPKeqMTiH/GNsmRBmGvvpXMttiI6U
	 3fAMOzeEzn/fzzYrOiOrvlANKDZ8ATiZdaNBJJQt4ADXesdWWf607u5sMctWW7ivNp
	 ezdA4hxh2i0NwxtGu0kgIdca3CkSKM33+FweXj0GrE7yfsPJ1rifhX0EOR5ncw5TP9
	 quaVvpc00P8iJ0Y1OevDaX5vAR7cACYm/yRNTNyGZ9uoNeeRWC3CiJD6ycOgcU7phD
	 ZC6DPy7H+YcRnIGBf8n/dmhdimIMnAW0RsHP87dQWQwBCerhMVXmm63V5lMtHL7oSv
	 jqulNjVQ92b+Q==
Date: Fri, 06 Dec 2024 16:18:15 -0800
Subject: [PATCH 1/7] libfrog: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352753248.129683.11231628303317171036.stgit@frogsfrogsfrogs>
In-Reply-To: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support scrubbing quota file metadir paths.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/scrub.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index d40364d35ce0b4..129f592e108ae1 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -187,6 +187,26 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "rtgroup summary",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_METAPATH_QUOTADIR] = {
+		.name	= "quotadir",
+		.descr	= "quota file metadir",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_USRQUOTA] = {
+		.name	= "usrquota",
+		.descr	= "user quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_GRPQUOTA] = {
+		.name	= "grpquota",
+		.descr	= "group quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
+	[XFS_SCRUB_METAPATH_PRJQUOTA] = {
+		.name	= "prjquota",
+		.descr	= "project quota file",
+		.group	= XFROG_SCRUB_GROUP_FS,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */

