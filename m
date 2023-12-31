Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872FEDF42
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cq2S0pEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6BDC433C7;
	Sun, 31 Dec 2023 23:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064454;
	bh=5HYn3b6QOVRQ2XfANgmsjyALqtbpr7fzafdRlv+tdhU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cq2S0pEf+wo3RS+UFtI8umQWnTwDPj7WUPAN1NZofdvlw3pozetrhweP7QHv0p0EM
	 tLK69CYZcuLFDAy1xW27kaJllV/vBS3E0Kfa9+EG4d18NaKjeeqp1JeeIXdUTTLMH9
	 7Hbp/iPO8m6TjRiPSmSBlvbpRDGoQcJKCdj1a2PfT3+IZ1AaBdQ5YycJenb1dw0oeE
	 wx3F0S5pvo1QxDdBU2OX3W93j5l7kySJQ8h752vFDZhr/fjLQEVErVZuccHBosqpep
	 nC9YKLkWrHYZk2AOGsWzvnjIRU2MDyABBPUwmAJrMobKP5otdMo8rQtQuusoR+PbbJ
	 Vjeou6H3p6Ocg==
Date: Sun, 31 Dec 2023 15:14:13 -0800
Subject: [PATCH 03/18] man2: update ioctl_xfs_scrub_metadata.2 for parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006903.1805510.18376884190572161694.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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
---
 man/man2/ioctl_xfs_scrub_metadata.2 |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)


diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 9963f1913e6..75ae52bb584 100644
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

