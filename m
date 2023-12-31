Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E972AC12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJU8/vNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CA4C433C7;
	Sun, 31 Dec 2023 22:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060826;
	bh=HQjiU+DWMlr07/AfWIEssAsUxbQvNDtvO1MAcNaVjUs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jJU8/vNaSKiJEVCJMwg0zXdWezZYUPe/BxJ+XFqcY6ClY+US7dD1lJAhbAtbLmJ4k
	 weUuwRIJa8UXen9Rs62fbFgTKBvyr8VHt72xb1ZTc5cBPgWvjvaVpC0Qh2brhP7al8
	 IiM85YNFm5kg5/kuxxtOKwkc0Ir3WJzpS4FSaS2fvMoTF4pN4SbXzHeORhnToi6PN3
	 mZVjSgqpC7KhXlu/6OkMdUJsYzKytDfiXADe2+Ylv93CKAN94lnR5/J2imb/g0udcU
	 x9XWcMIT4UOfVzVdjcgZH6f4+7MFoW5ClKithNjzY9RDKogADJjkLleFkaTUbdrjP6
	 wzpKNe3GsuUFw==
Date: Sun, 31 Dec 2023 14:13:46 -0800
Subject: [PATCH 1/4] xfs: add secondary and indirect classes to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992415.1794340.12861672134188820182.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992400.1794340.13951488488074140755.stgit@frogsfrogsfrogs>
References: <170404992400.1794340.13951488488074140755.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_health.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index a5b346b377c..26a2661571b 100644
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

