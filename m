Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E496FC3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883252; cv=none; b=QK2Wju5JHUdKsKzj/CN6ryQhQKV5fSIfGNzNKgMuO1C0dSqKewVK5B+wyh30M+62SNip4joFiJa9JX/Uq87t9DrVoaRHERQXA/lvDQv4nXF3SmuLb0kpaWNM+XSzz8FseNNE6kno5QC/lOFEgOVzRrekWWFaNWY82GKw+6HZIgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883252; c=relaxed/simple;
	bh=+3JbXZjUWLTyJ58HHQKXIpRhgli05+2XX93BzM5jlIE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3o15dgg8HaEvgTiRj1B+zN/PHuBCfUsSJLfgerzIefv6atI3SUHo4aZYq/crYdKGK/cGLkimlmnrwdt8qK0lOQPQwii8yZHqkHAUrcJg65lVXBIwnynDUY16Zj6AeZ7JETZy/NWuS2RAdJbPa0NCsBD2fYbuUZVmreOTj+Gt9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHqD/2NZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHqD/2NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F569C116B1;
	Tue,  2 Jul 2024 01:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883252;
	bh=+3JbXZjUWLTyJ58HHQKXIpRhgli05+2XX93BzM5jlIE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HHqD/2NZoLpEfCmMmdpSR9Zy0+qspqefTWvChTlnjUTNG0j0Q2iokL8L3TaxQmsB2
	 E8Bg2RJGFOcHWVMFfV2gL93dlMpptNr4xv+98CWKrVpT1j49ylU7Efgkd04L8/aBtr
	 XXszUBM9bffldd2ww4799gT0wN/CwBtHAhxv/x547bXapkJs/kT9MPU8i0URg2+7yI
	 5+U6krOHJIfLf9pnmd2Dh4gsJRlKOuBo5fxTa3PWNePciyxYULLhEoRB9Yq5dRcQNx
	 8aMm8ncRd6al7YwKd7wNqFPVNmcEVGZCVaQjOBLJrmYbudFDSKtlawL/2kZ0ybmPbq
	 5tl/D0WfEsqng==
Date: Mon, 01 Jul 2024 18:20:51 -0700
Subject: [PATCH 1/5] libfrog: add directory tree structure scrubber to scrub
 library
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988122711.2012320.2904107384951874903.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
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

Make it so that scrub clients can detect corruptions within the
directory tree structure itself.  Update the documentation for the scrub
ioctl to mention this new functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 man/man2/ioctl_xfs_scrub_metadata.2 |   14 ++++++++++++++
 2 files changed, 19 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index baaa4b4d9402..a2146e228f5b 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -149,6 +149,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "retained health records",
 		.group	= XFROG_SCRUB_GROUP_NONE,
 	},
+	[XFS_SCRUB_TYPE_DIRTREE] = {
+		.name	= "dirtree",
+		.descr	= "directory tree structure",
+		.group	= XFROG_SCRUB_GROUP_INODE,
+	},
 };
 #undef DEP
 
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 75ae52bb5847..44aa139b297a 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -148,6 +148,20 @@ that points back to the subdirectory.
 The inode to examine can be specified in the same manner as
 .BR XFS_SCRUB_TYPE_INODE "."
 
+.TP
+.B XFS_SCRUB_TYPE_DIRTREE
+This scrubber looks for problems in the directory tree structure such as loops
+and directories accessible through more than one path.
+Problems are detected by walking parent pointers upwards towards the root.
+Loops are detected by comparing the parent directory at each step against the
+directories already examined.
+Directories with multiple paths are detected by counting the parent pointers
+attached to a directory.
+Non-directories do not have links pointing away from the directory tree root
+and can be skipped.
+The directory to examine can be specified in the same manner as
+.BR XFS_SCRUB_TYPE_INODE "."
+
 .TP
 .B XFS_SCRUB_TYPE_SYMLINK
 Examine the target of a symbolic link for obvious pathname problems.

