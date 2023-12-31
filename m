Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01AEC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxOuwyVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70BC433C8;
	Sun, 31 Dec 2023 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060654;
	bh=SlY9SlVgzxiMeq92njfRQSzrBtavHUWPIpccILoxJNQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fxOuwyVTUmRhNwcVKz9oEwnMsPAeNOErf6SK8CeYZnXE8F1EJ/GL/fJE17oQ+tGL1
	 enFg63bL0c8gKCg69T+rU9TsqMAAF3MSva4wOTij71hEMbmRxMNsMmGvQ7xG7UfzTH
	 wtGxL9hQXe1vSQYnpRHg80YqVT8a+VzTsWan/K/1Dj1PJor7i+vMTIowS8jGz7nWzl
	 I2O1Nq5TXBRTeRHRFyh/ASJuyhe53DiN62/svXfQrgQih02XSzHBaKsM01xc9Uiaxx
	 5z5G0SwxiiP3+reD7LpsT+l9y5UULPFG3ClrUKtB+acN1XRGL4LlJ4rwmzmz/x62qI
	 3nCPna/RWCzgg==
Date: Sun, 31 Dec 2023 14:10:54 -0800
Subject: [PATCH 2/3] xfs: teach scrub to check file nlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991600.1793944.13700260385207472315.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991573.1793944.10238192046951704393.stgit@frogsfrogsfrogs>
References: <170404991573.1793944.10238192046951704393.stgit@frogsfrogsfrogs>
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

Create the necessary scrub code to walk the filesystem's directory tree
so that we can compute file link counts.  Similar to quotacheck, we
create an incore shadow array of link count information and then we walk
the filesystem a second time to compare the link counts.  We need live
updates to keep the information up to date during the lengthy scan, so
this scrubber remains disabled until the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 53c47bc2b5d..b6b8ae042c4 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -139,6 +139,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "quota counters",
 		.group	= XFROG_SCRUB_GROUP_ISCAN,
 	},
+	[XFS_SCRUB_TYPE_NLINKS] = {
+		.name	= "nlinks",
+		.descr	= "inode link counts",
+		.group	= XFROG_SCRUB_GROUP_ISCAN,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index f10d0aa0e33..515cd27d3b3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -712,9 +712,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
+#define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	26
+#define XFS_SCRUB_TYPE_NR	27
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 046e3e3657b..8e8bb72fb3b 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -164,6 +164,10 @@ Examine all user, group, or project quota records for corruption.
 .B XFS_SCRUB_TYPE_FSCOUNTERS
 Examine all filesystem summary counters (free blocks, inode count, free inode
 count) for errors.
+
+.TP
+.B XFS_SCRUB_TYPE_NLINKS
+Scan all inodes in the filesystem to verify each file's link count.
 .RE
 
 .PD 1

