Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC491A2389
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636361; cv=none; b=qFVLmuuCqbSy59AUfmFD7CpR2UkLHRAQRyS6ynoLs/74YFJInPICsa0LO1B0wjVON2kkBGS9L62MSTVi6ipakI6DQn7ZHEHiJUFeKFcoVeIy7trEnGk0LH7CzI4j4UYUCtaM15HrwP71oy+tGVz74EGjPmNpoLSQJAthz7SBeaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636361; c=relaxed/simple;
	bh=an6JcxC2BfLPdTbFdsrJg2oWdHoyIg20skUGbVSfWtM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qq9rAw7l+3LFxtqt5wSK9ZFOF0keKt+ta44qfv4XoJs4YBM+XFRljTHK71fwqWfvoGmc3oRh9N8a9xnzCNHZDF/J18J+CE3INfz9Li64pc44kSaDp4S0xBqaXZy4/0n9rTOe+PojFezZkWZCwrAFTM2bqMfjDSbOW44wdjW0WSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9hEYl61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9hEYl61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F7EC4CECE;
	Thu, 19 Dec 2024 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636360;
	bh=an6JcxC2BfLPdTbFdsrJg2oWdHoyIg20skUGbVSfWtM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l9hEYl61yu+7oAzHzgeoRM0pIi4TQI85gC38qp9/NMQyCHLgW6tUpMLi8Mw+PQ8yA
	 orUwbMJGfHPf8AMzMUMBrGS7dB1++VPIJtYwOYZWUfVx/9sReo/Z5Dp/R7A93/koVC
	 7M/4MGFp7qXYyGz+quGb7n9eYVR+0VLl2NqenIOuzUQhj7sW/SIjTLB4huf8xS6Ddv
	 cwcdHeki/nN0HoMCx1UzmykoAWyBHIZUyWntkTd3w967q+oW+S83e/011T7fh4DQdM
	 SB2USfuUrIbNcqCTO8UNGUkHmiwmOxBR/fFmvkpO+sCm0UEWMVzhDCDAnXl+Kc20nS
	 k1ejjQB1QJ2fw==
Date: Thu, 19 Dec 2024 11:26:00 -0800
Subject: [PATCH 10/37] xfs: pretty print metadata file types in error messages
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579926.1571512.10575211864372125995.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a helper function to turn a metadata file type code into a
printable string, and use this to complain about lockdep problems with
rtgroup inodes.  We'll use this more in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_metafile.c |   18 ++++++++++++++++++
 fs/xfs/libxfs/xfs_metafile.h |    2 ++
 fs/xfs/libxfs/xfs_rtgroup.c  |    3 ++-
 3 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index e151663cc9efd6..2f5f554a36d4c9 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -22,6 +22,24 @@
 #include "xfs_error.h"
 #include "xfs_alloc.h"
 
+static const struct {
+	enum xfs_metafile_type	mtype;
+	const char		*name;
+} xfs_metafile_type_strs[] = { XFS_METAFILE_TYPE_STR };
+
+const char *
+xfs_metafile_type_str(enum xfs_metafile_type metatype)
+{
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(xfs_metafile_type_strs); i++) {
+		if (xfs_metafile_type_strs[i].mtype == metatype)
+			return xfs_metafile_type_strs[i].name;
+	}
+
+	return NULL;
+}
+
 /* Set up an inode to be recognized as a metadata directory inode. */
 void
 xfs_metafile_set_iflag(
diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index 8d8f08a6071c23..95af4b52e5a75f 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_METAFILE_H__
 #define __XFS_METAFILE_H__
 
+const char *xfs_metafile_type_str(enum xfs_metafile_type metatype);
+
 /* All metadata files must have these flags set. */
 #define XFS_METAFILE_DIFLAGS	(XFS_DIFLAG_IMMUTABLE | \
 				 XFS_DIFLAG_SYNC | \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index a79b734e70440d..9e5fdc0dc55cef 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -282,7 +282,8 @@ xfs_rtginode_ilock_print_fn(
 	const struct xfs_inode *ip =
 		container_of(m, struct xfs_inode, i_lock.dep_map);
 
-	printk(KERN_CONT " rgno=%u", ip->i_projid);
+	printk(KERN_CONT " rgno=%u metatype=%s", ip->i_projid,
+			xfs_metafile_type_str(ip->i_metatype));
 }
 
 /*

