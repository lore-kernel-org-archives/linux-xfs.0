Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFA35227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230841; cv=none; b=V+7ShmIJaiI98B6Y5xD65g5HY2AyAKQtsojosYc2Aa2T9601+tG8MsF5pk/NacbSdJJv9mM4muFy3L3sxwM+QuxILkP5zRWxHORTOqmEKCZJtW0tcHGdsVykshpb8fqM5t08fgg4f5+YAZi1WTk+5du8Kq0Md4i3oxYet2/QxPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230841; c=relaxed/simple;
	bh=TluDRBU01zH/e0NLLOG7tfz8udY65H1TmGBG1AANgj4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXMwihQADfHQHIeRTNmYKiQqCGq3AbS8YldEOyj9OHnxXym8XC/K09p12ksg187anunQpQAboVyoQLfX5MLXwgC8klAEHIYtXucdz/dUIhgXiVt6s4QfBURsG563G37Wcb1Hhn1GOvOh/MJoPiQailu7t8k7ArLhJEdR/NCpmEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHmLXpen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHmLXpen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E347C113CC;
	Tue, 16 Apr 2024 01:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230841;
	bh=TluDRBU01zH/e0NLLOG7tfz8udY65H1TmGBG1AANgj4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rHmLXpen5VXJZvws646rnRCEl+LRfgvNrOuOAhyqdfaz0OkC1wASJOrD/NBQZ32Rj
	 3OT61W2jct7qoR7L6qXeXe/8AXI13/5Zaxmzg0bafPeQdNCPzegJ8b1/Y2S4o0XBfa
	 CHAkCXSef3idsM3Cr1djvc0KHkhOI5/wn/N/ecZQYBuJzIHzWUVL+O19q4KDrE0qIx
	 z7iDJtTStI+69OK7VVN07YWEjI6jAnc9vvHUmsccE5g12ecZGKwty7FMTIc/nkgAI1
	 VbUicISLar5v/p+ciQ5l4Cdhzxq+Vf+fSlszufu1oTHvYK5V8DBTTdFubXU1DvSfGS
	 6DfoNFgKB9UHg==
Date: Mon, 15 Apr 2024 18:27:20 -0700
Subject: [PATCH 05/31] xfs: add parent pointer support to attribute code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027867.251715.5134816014536475063.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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
index ecd0616f5776a..0c80f7ab9475a 100644
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
index accba2acd623d..020aebd101432 100644
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
index 2d394038a5927..fdded7c248143 100644
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

