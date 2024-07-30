Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188596FB0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302739; cv=none; b=ROrS0gcwTKS1EZE4dF/xTnvZrhoe+iegkf4dZx3saxyYrFQPX3X8t3wQ+mlzuGJRSObCk8ECan7HI6ZszRoO/Wt4Oru4fxOZXgt8AwAqYrkpHvOWIdFe+uPrMVtV8Lfs3YUO2aGKk0MxqSJUkATcmBNzi+uEG4m4w60m4yBkF1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302739; c=relaxed/simple;
	bh=b9VMK7LrOPbq0gWmtMnmhAVIcs11vfUF89AopbErJY0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMXHINFaskbjOHPkwd41ebB1BuBvkRebjl8Lr0Yt2UVwC2gKEPzB5oBZfn/URGQQ1dxx044soBTQ2rOQ+1LAhVzuhNcy+IN3VUUs+mgEI1ZwC2vhoKNFXyzHQ02yacwf7wRl0CDa/iQP6aWNudTDgIPbAuL6l4vj1O/Dkniox0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0sjF0Qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0sjF0Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AA4C32786;
	Tue, 30 Jul 2024 01:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302738;
	bh=b9VMK7LrOPbq0gWmtMnmhAVIcs11vfUF89AopbErJY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P0sjF0Qs+nK2CvJoS6tV2fGnWSu+Bp2N06K8hwqqHwhp70cBZLgzu+gYiSifiT0d0
	 CITjstao17L5oNeYq7tgjLA+e3e4Rf7jM/KmZAZeUZ5zN1e1fyd7uztGDiMGLiOStM
	 0VYNpBiI/uZl3mqU7b8JWEevUrZoyQoTml/A90fHhdrwI6m3i24DrVnsDqqLiZNsok
	 hCRybA7pI3Ob4WVJG0QM78V67HER+vyjuwrdDSmM8Uu0VfH3zSIhm5WbvW9kVSXVYW
	 2wdLXX4G4D9ifXjVwPCQ6lpTv5mPzhE20UcMiNWruIL4Ev3jcOZUucPb3G0Y9hiBCf
	 2ZXYU3pljFroA==
Date: Mon, 29 Jul 2024 18:25:38 -0700
Subject: [PATCH 2/2] man2: update ioctl_xfs_scrub_metadata.2 for parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851166.1352400.15153448355647364826.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851139.1352400.10715918413205904955.stgit@frogsfrogsfrogs>
References: <172229851139.1352400.10715918413205904955.stgit@frogsfrogsfrogs>
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

Update the man page for the scrub ioctl to reflect the new scrubbing
abilities when parent pointers are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_scrub_metadata.2 |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)


diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 9963f1913..75ae52bb5 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -109,12 +109,11 @@ must be zero.
 .nf
 .B XFS_SCRUB_TYPE_BMBTD
 .B XFS_SCRUB_TYPE_BMBTA
+.fi
+.TP
 .B XFS_SCRUB_TYPE_BMBTC
-.fi
-.TP
-.B XFS_SCRUB_TYPE_PARENT
 Examine a given inode's data block map, extended attribute block map,
-copy on write block map, or parent inode pointer.
+or copy on write block map.
 Inode records are examined for obviously incorrect values and
 discrepancies with the three block map types.
 The block maps are checked for obviously wrong values and
@@ -133,9 +132,22 @@ The inode to examine can be specified in the same manner as
 .TP
 .B XFS_SCRUB_TYPE_DIR
 Examine the entries in a given directory for invalid data or dangling pointers.
+If the filesystem supports directory parent pointers, each entry will be
+checked to confirm that the child file has a matching parent pointer.
 The directory to examine can be specified in the same manner as
 .BR XFS_SCRUB_TYPE_INODE "."
 
+.TP
+.B XFS_SCRUB_TYPE_PARENT
+For filesystems that support directory parent pointers, this scrubber
+examines all the parent pointers attached to a file and confirms that the
+parent directory has an entry matching the parent pointer.
+For filesystems that do not support directory parent pointers, this scrubber
+checks that a subdirectory's dotdot entry points to a directory with an entry
+that points back to the subdirectory.
+The inode to examine can be specified in the same manner as
+.BR XFS_SCRUB_TYPE_INODE "."
+
 .TP
 .B XFS_SCRUB_TYPE_SYMLINK
 Examine the target of a symbolic link for obvious pathname problems.

