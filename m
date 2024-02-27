Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD411BF2A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000687; cv=none; b=anV03g73hRAVsJtiszQSO1PzGg/aySGHJv1Jg/tGOyr83JMcOkBCi44Mw5UC96meSsPWHxjJK6zMXqQTf8hCrL8TWa9PD0Iw4sRn2yzFBjpXZcV8zxpCcus5XA0bCom/pqb58YmwnW0UPRTYHv9+df/UGrk5iTNlYeKZCpxu5mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000687; c=relaxed/simple;
	bh=JHzyb1F/dLoLvbfZVwWpWbSRSQ4Hw3QpGir02FOv1vo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1cB5RTgctVURZ2eBjglC6VoH8E/HBRnC5M45iK8ID8V2SStZ8AWeA8acOaZ1H+3Kbf8hlD60W3wmZUBwEspeOSXOar23kEhxB/XFnIxfyMlwINMsmofBd8knrZzXFHGlt8Hr8R8XnF2xA+RJq6e5o1gliVVfq3pg+B35f8OQmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lt0w//fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lt0w//fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1FBC433F1;
	Tue, 27 Feb 2024 02:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000687;
	bh=JHzyb1F/dLoLvbfZVwWpWbSRSQ4Hw3QpGir02FOv1vo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lt0w//fc69kaZ8EOclObzb8p6cXqe/0SpGoN31S3LPpff0OxhMjKSSZ4si9y2zHq0
	 DE+RZCQD2sYJmR3CXiI20I5uDD4yMC8d8z/hIPy3hB4i4X+GG17iNXT8XEKkWHLtFc
	 455BqgBw0Hxjx0Wd8BGdf3hXfQVWBlt+R5W/z1cxChgVRofiBi8widio7VHKhLm9ni
	 A9GxFmnACngfVq6SzvYjcHvOlDxzEXQL0QzMYnyLptMSdXYwXVlPfOcKGMVVtRj20g
	 yf529KEP9Lyqj0TYDk4j7fiypt8i8F9WPJFaZgse3ABfpMwt+kFfqBzd0ox8TtYzoR
	 x2CR2TWL0C01w==
Date: Mon, 26 Feb 2024 18:24:46 -0800
Subject: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900012232.938660.16382530364290848736.stgit@frogsfrogsfrogs>
In-Reply-To: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
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

We're about to start adding functionality that uses internal inodes that
are private to XFS.  What this means is that userspace should never be
able to access any information about these files, and should not be able
to open these files by handle.  Callers are not allowed to link these
files into the directory tree, which should suffice to make these
private inodes actually private.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_export.c |    2 +-
 fs/xfs/xfs_itable.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 7cd09c3a82cb5..4b03221351c0f 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -160,7 +160,7 @@ xfs_nfs_get_inode(
 		}
 	}
 
-	if (VFS_I(ip)->i_generation != generation) {
+	if (VFS_I(ip)->i_generation != generation || IS_PRIVATE(VFS_I(ip))) {
 		xfs_irele(ip);
 		return ERR_PTR(-ESTALE);
 	}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 14462614fcc8d..4610660f267e6 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -97,6 +97,14 @@ xfs_bulkstat_one_int(
 	vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid = i_gid_into_vfsgid(idmap, inode);
 
+	/* If this is a private inode, don't leak its details to userspace. */
+	if (IS_PRIVATE(inode)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		xfs_irele(ip);
+		error = -EINVAL;
+		goto out_advance;
+	}
+
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */

