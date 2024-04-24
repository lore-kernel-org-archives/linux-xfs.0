Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C924029429
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928433; cv=none; b=iX8lWvOkyPv/iuSy7WVc23G2Qjxt4DOuolPsW7YG245cWQ/ghNn1Yp+vSKpuuoB03Va9h73mESFNErx2pDH+CMMcipIFuj0E2XCw99RGevMRNudVkJP0S9yBqkrHMWDaQp8YvTjJbVaFKZs8G3sGIRu0XnjW33FiQwp1of8a8Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928433; c=relaxed/simple;
	bh=xmkbxnNUVFzeE0w03KXWA9iBTL87LrurEb0Yi8h9Vzs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdSgygRwV13QP3Bmwoo/bhP/wGfin+3Lc6BACUKfXW3Mx39WNxxlzLtNcZNqOGUNRZXTwKNbFsVlfkGkllNWatlXJLs1bGsJxMYU9p33QRa0Er2mNDh9Wb7lHE1avFNJdxcHh8Gihb7kNa6fihJ6ZvK8qVl5/6cpubH2HGCT4Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=djRvpyRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djRvpyRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF22C116B1;
	Wed, 24 Apr 2024 03:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928433;
	bh=xmkbxnNUVFzeE0w03KXWA9iBTL87LrurEb0Yi8h9Vzs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=djRvpyRdPJhRVz5/vnc3aO84/Ww8zdQ9yFCKEqzt2bxInlXZR3y9jczMnpj3dS39F
	 I+xcZqB7q80O9CXH+ryBrSwsNqZ0l5M51VtfusDul2kGbietO7fTWDuz2bVEAePGqM
	 QezSnAsNvtm+Y1yHW2qvcmyqZ9tIIoB54RsWzz9luAW7C0EMPzbXzMsShuaxU1wnFt
	 WysVBfLReHrN6PeMd93bbekn51j0T9lEslNKppySIaoKgb4M5+rUu0q17d185G9iYG
	 z4Ku82QX/+pdDjHhTLufL3E8vQ5AT3NgLURXz9k4lnopQhO+/UlNpnN6iIF6NDW9Yg
	 CX52kE+uSBEuw==
Date: Tue, 23 Apr 2024 20:13:53 -0700
Subject: [PATCH 05/30] xfs: add parent pointer support to attribute code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783349.1905110.7631654098198574743.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h  |    9 +++++++--
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/xfs_trace.h             |    3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ecd0616f5776..0c80f7ab9475 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -714,13 +714,17 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | \
+					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT)
 
 #define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
 				 XFS_ATTR_LOCAL | \
@@ -729,7 +733,8 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_NAMESPACE_STR \
 	{ XFS_ATTR_LOCAL,	"local" }, \
 	{ XFS_ATTR_ROOT,	"root" }, \
-	{ XFS_ATTR_SECURE,	"secure" }
+	{ XFS_ATTR_SECURE,	"secure" }, \
+	{ XFS_ATTR_PARENT,	"parent" }
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index accba2acd623..020aebd10143 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1034,6 +1034,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 57f225ba7e8a..5621db48e763 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -91,7 +91,8 @@ struct xfs_exchrange;
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
 	{ XFS_ATTR_SECURE,	"SECURE" }, \
-	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }
+	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }, \
+	{ XFS_ATTR_PARENT,	"PARENT" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),

