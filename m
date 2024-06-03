Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D24113A3F4
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441115; cv=none; b=SsMgxFfk5ts3mvGfDGN2Wep6Uhhdyq/0xXVRen+2u4rPznFF4lAjXXLnpBYmhO2bfEhSTk0vUFaSTMxLV/vU59u/9dmKY9cJp3LJ1PTooH+xrf2H5AbNy02Is+Szsk9VhOKsGZCvxCOeC7AEcHbzUyBu36+c0ex5FqSXLDkxo+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441115; c=relaxed/simple;
	bh=g98dOEVOmZDc7hGHyhvjPQCgmbeXHqarV+d1nqle1kM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tqwADRVSo8vc7L/4kZ4/09ijt4yOXaYsVrhtQo+ppqgK8rLGGhlVMxPfuMTDi/mYvimHYlAYOt1ghjgsGENMGOhSLBx8sMily9f3QiOJACMQvdxmH1nqe4J10uw/FIDPxHRVLdwinc10PCLsm/CiKX8JjGsqEnt6XGMb81rZxQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTyhYTRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTyhYTRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6114C2BD10;
	Mon,  3 Jun 2024 18:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441114;
	bh=g98dOEVOmZDc7hGHyhvjPQCgmbeXHqarV+d1nqle1kM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uTyhYTRSz+RuKMuroxHMChbJFzBV3zfKXfWm+BimjyGXjUPU7n/cC5PDgDxLRCqh2
	 dOlmFy1/TYZbM7jDagZ62GNwi5f8S+L3ElLhekz2teaxaP9BA+Ezy+d4y29ZaKdFDR
	 7Co64XJEnyMwGVbVH//STVxFjsJ9d11M9XYegrwtYAU8y5DWNAiiR17276zNmJ/HQI
	 uEITmn+0Okll1mK5debDz3oWAnvOesoiNZc/fw4Wic9TVb/M793CuO2z6hjs+bf+dj
	 2qVFmmOv21NmairZX5UrMABKvoP9aBnf9QF5s7f+r8lwMqYmhukYhgvBuv1xXWkuK+
	 cCMMLPkG5wyNQ==
Date: Mon, 03 Jun 2024 11:58:34 -0700
Subject: [PATCH 025/111] xfs: add secondary and indirect classes to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039746.1443973.16242440150376829614.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4e587917ee1cc28ac3a04cd55937419b9e65d81d

Establish two more classes of health tracking bits:

* Indirect problems, which suggest problems in other health domains
that we weren't able to preserve.

* Secondary problems, which track state that's related to primary
evidence of health problems; and

The first class we'll use in an upcoming patch to record in the AG
health status the fact that we ran out of memory and had to inactivate
an inode with defective metadata.  The second class we use to indicate
that repair knows that an inode is bad and we need to fix it later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_health.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index ff98c0321..032d45fcb 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -31,6 +31,19 @@
  *  - !checked && sick  => errors have been observed during normal operation,
  *                         but the metadata has not been checked thoroughly
  *  - !checked && !sick => has not been examined since mount
+ *
+ * Evidence of health problems can be sorted into three basic categories:
+ *
+ * a) Primary evidence, which signals that something is defective within the
+ *    general grouping of metadata.
+ *
+ * b) Secondary evidence, which are side effects of primary problem but are
+ *    not themselves problems.  These can be forgotten when the primary
+ *    health problems are addressed.
+ *
+ * c) Indirect evidence, which points to something being wrong in another
+ *    group, but we had to release resources and this is all that's left of
+ *    that state.
  */
 
 struct xfs_mount;
@@ -115,6 +128,36 @@ struct xfs_da_args;
 				 XFS_SICK_INO_DIR_ZAPPED | \
 				 XFS_SICK_INO_SYMLINK_ZAPPED)
 
+/* Secondary state related to (but not primary evidence of) health problems. */
+#define XFS_SICK_FS_SECONDARY	(0)
+#define XFS_SICK_RT_SECONDARY	(0)
+#define XFS_SICK_AG_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(0)
+
+/* Evidence of health problems elsewhere. */
+#define XFS_SICK_FS_INDIRECT	(0)
+#define XFS_SICK_RT_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_INO_INDIRECT	(0)
+
+/* All health masks. */
+#define XFS_SICK_FS_ALL	(XFS_SICK_FS_PRIMARY | \
+				 XFS_SICK_FS_SECONDARY | \
+				 XFS_SICK_FS_INDIRECT)
+
+#define XFS_SICK_RT_ALL	(XFS_SICK_RT_PRIMARY | \
+				 XFS_SICK_RT_SECONDARY | \
+				 XFS_SICK_RT_INDIRECT)
+
+#define XFS_SICK_AG_ALL	(XFS_SICK_AG_PRIMARY | \
+				 XFS_SICK_AG_SECONDARY | \
+				 XFS_SICK_AG_INDIRECT)
+
+#define XFS_SICK_INO_ALL	(XFS_SICK_INO_PRIMARY | \
+				 XFS_SICK_INO_SECONDARY | \
+				 XFS_SICK_INO_INDIRECT | \
+				 XFS_SICK_INO_ZAPPED)
+
 /*
  * These functions must be provided by the xfs implementation.  Function
  * behavior with respect to the first argument should be as follows:

