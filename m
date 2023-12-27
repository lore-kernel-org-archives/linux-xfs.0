Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B36C1368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9CG/cfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCF0C433C7;
	Mon,  1 Jan 2024 00:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069098;
	bh=oaM0J71CzUbPhWLaP5ZCyoW0r00q3RauGAU/FRL5TwM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U9CG/cfUH/S4ycK7nxC7b3viI2sNX4N8bSQX/rqTTnxLsvSKvbqudKPrIDLvz5tAp
	 oydU9JJEbhGpUI2PHAXwdoa4yuZs8VL1rjsm51/fjN3C9zp9bol0JtPluJQsjI1uqC
	 G0X57Hsh/Aw7PkoqlmqzYEhjbI3avGnkr9nqU6OGC06fBBxCqhGHC5TdLWgFdpC7wU
	 LcfYLPXLRnb5r7vYSFOut4aljQiPixMR1UQuAHOrF7Sh3HnDeLozMYnMHR6OtnGd75
	 H884CruvRr60L3q+enMTXcAgfeUBURSF4QMOnyyvlSjp7NWWU2+Y7E5o0qDkcFV6m6
	 q2Oiqhrd3tpHQ==
Date: Sun, 31 Dec 2023 16:31:37 +9900
Subject: [PATCH 21/42] xfs: scrub the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017406.1817107.8670798702206742630.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Add code to scrub realtime refcount btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0bbdbfb0a8a..7847da61db2 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -738,9 +738,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RGBITMAP	31	/* realtime group bitmap */
 #define XFS_SCRUB_TYPE_RTRMAPBT	32	/* rtgroup reverse mapping btree */
+#define XFS_SCRUB_TYPE_RTREFCBT	33	/* realtime reference count btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	33
+#define XFS_SCRUB_TYPE_NR	34
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 79875968d1c..e8717b41ccd 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -100,11 +100,12 @@ must be zero.
 .PP
 .nf
 .B XFS_SCRUB_TYPE_RGBITMAP
-.fi
-.TP
 .B XFS_SCRUB_TYPE_RTRMAPBT
-Examine a given realtime allocation group's free space bitmap or reverse
-mapping btree, respectively.
+.fi
+.TP
+.B XFS_SCRUB_TYPE_RTREFCBT
+Examine a given realtime allocation group's free space bitmap, reverse
+mapping btree, or reference count btree, respectively.
 Records are checked for obviously incorrect values and cross-referenced
 with other allocation group metadata records to ensure that there are no
 conflicts.

