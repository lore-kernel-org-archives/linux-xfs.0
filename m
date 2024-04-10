Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4BE1FB4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710176; cv=none; b=ARfREjZVo4Mq867JP9+fqVkUPwJ/yIsNQyeGTp7PAbSA+gxA2uUN1AHppCNi6TL5HQwltwXA4pdQ+2k2jUOAThd8Rp0QCW8Tuqonpd+CQbqn3xvnr+eYFFkdcaRLATXb8RPMemmxv6na7NBqdmtamauQGDuoNqT5U7f4pWIcI/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710176; c=relaxed/simple;
	bh=onCqnZW7YJ/1vl2RoPqZTWGDg6/UOOS8OCRn3Y7Yq30=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kyvSAQPZFbBsL4DlgInhy39FEIk/gmoDjn8iCilWzZuYP3Q3cNsXm6+qK+9OT9vHybRsIEq/XZnSDoKVHywrzWWXxguzrU4GBd51Yrl97NW1fL1zO662ARmu1GXSdmvDyHYv5X20qK7ExksLfewu4erdtCeoCY6cUQlTJOVqLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0qwhO/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0qwhO/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8622EC433C7;
	Wed, 10 Apr 2024 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710176;
	bh=onCqnZW7YJ/1vl2RoPqZTWGDg6/UOOS8OCRn3Y7Yq30=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l0qwhO/VugHqz+WaTh481mF4i3oUiVmNlQX+p5OYKfnB+y+5W2U8elLkrBU/yzb6c
	 jz9glQBlMWT98rVePBSEV0k43i32dJRaeruMbLG+EEJt8a7SZ8dpkSARRRoZ0QAs9E
	 5ftxhQmjBSjMYZOeA6uJloF8V12E3E2r9PDPW8zCQYDvHG3DREUlgm5KOnuIyMQiXl
	 CQgAx/XH1lYKoLZY0HCpkiaERY5u+jMM7a9Kvv06/w9v9qH/L/NJr6bgxr5MFhdjjk
	 KFhwZci6kdtvUweVJKmEGTOoWmyFZbhrE/7JpwwzDIB7Wm571RfKBI24rYTrjC9CLN
	 RAzMzC+9rxuLw==
Date: Tue, 09 Apr 2024 17:49:36 -0700
Subject: [PATCH 1/4] xfs: remove XFS_DA_OP_REMOVE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968401.3631393.447688102804909615.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
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

Nobody checks this flag, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h     |    1 -
 fs/xfs/libxfs/xfs_da_btree.h |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e4f55008552b4..670ab2a613fc6 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -590,7 +590,6 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 static inline enum xfs_delattr_state
 xfs_attr_init_remove_state(struct xfs_da_args *args)
 {
-	args->op_flags |= XFS_DA_OP_REMOVE;
 	if (xfs_attr_is_shortform(args->dp))
 		return XFS_DAS_SF_REMOVE;
 	if (xfs_attr_is_leaf(args->dp))
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 7a004786ee0a2..76e764080d994 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -91,9 +91,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
 #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
-#define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -102,7 +101,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
-	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 

