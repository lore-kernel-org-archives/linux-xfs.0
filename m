Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C485916D
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798151; cv=none; b=g4j5Zc0NPfTijQ4CJKum26/LNMGZz2GFZ7DXMsXvyaVjmKug321+s1YCvo9siOjbm8zDdS5t24jaVzO6HhO85QT323pZ7xg/pJ9VNTLVOE9bA23nw1t5LVhH/L3nmETp27+7zdVRXaPFuZkdT27YoRYWGCL3AzRPwzxANZZ1rXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798151; c=relaxed/simple;
	bh=IaFN4qzTJV0Vql2gyiHO6mzC34JRePaPQTRaVyptydc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KL/mi7yoFs5d+QiDUhavD9nVlcMId6/ohPjBM3LUPzvnMDUXQlilxmYeZZB/HFnGei1Uofc2WNIl0U6cKpXMBXbvQeGAfpvIXfj3fkbcUSSFR8/4TD1aRPT186PYfAQHanpoBWqAfqN9MOBQdemTnJlIogMgyYnj3Og8bDyAcBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E92EfE1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E92EfE1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7F0C433C7;
	Mon, 18 Mar 2024 21:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798151;
	bh=IaFN4qzTJV0Vql2gyiHO6mzC34JRePaPQTRaVyptydc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E92EfE1udykxgpN2m1Sx9LXcL/zwnYcbjPZwZM1xu506fIv50IKwE8/E1Rdx2t2bE
	 By2rAus4E7A1fBGoa9VA7aAOArnE4rl713pjxFDl8WbFHCH1HHlrvu8M9VmGag9Kru
	 lza6H4Vaw4RcM0p0UiINSDT1+RqGi2r+K0x5jK0MoGcur2KmU9pHrdOZk/4WaU8FvG
	 db49bPF1lSNVRhP2lSKrgAiX3nklfKz1Fmlbas6MJrm11h1bzU7ShV+xhroMtp9q5p
	 P1PAX8go76aVOQHYMNV8T9yGkHMo9MHf7bdrOp0iCQTGEI1riQGiGddK1yk3KDSZXe
	 /R8K+JCE9WXrQ==
Date: Mon, 18 Mar 2024 14:42:31 -0700
Subject: [PATCH 02/23] xfs: add parent pointer support to attribute code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079801904.3806377.5082208903634436068.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    3 ++-
 fs/xfs/libxfs/xfs_da_format.h  |    5 ++++-
 fs/xfs/libxfs/xfs_log_format.h |    1 +
 fs/xfs/scrub/attr.c            |    2 +-
 fs/xfs/xfs_trace.h             |    3 ++-
 5 files changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1ff7b64a73fb3..b34858ef8a764 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -951,7 +951,8 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd = (args->attr_filter & (XFS_ATTR_ROOT |
+							     XFS_ATTR_PARENT));
 	bool			is_remove = args->op_flags & XFS_DA_OP_REMOVE;
 	int			error, local;
 	int			rmt_blks = 0;
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index aac3fe0396140..a1d80fc685237 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -714,12 +714,15 @@ struct xfs_attr3_leafblock {
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
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 #define XFS_ATTR_NAMESPACE_STR \
 	{ XFS_ATTR_LOCAL,	"local" }, \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 0ec1d36a8f9eb..0b6a0dcd69185 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1037,6 +1037,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 8853e4d0eee3d..297c2653b6104 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -513,7 +513,7 @@ xchk_xattr_rec(
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
+			XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT);
 	if ((ent->flags & badflags) != 0)
 		xchk_da_set_corrupt(ds, level);
 	if (ent->flags & XFS_ATTR_LOCAL) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 52dbec3d8f8e9..6f8608c905e0b 100644
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

