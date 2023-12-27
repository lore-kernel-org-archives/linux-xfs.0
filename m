Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0D38E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKpsh/cW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8C1C433C8;
	Mon,  1 Jan 2024 00:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068097;
	bh=PFdtcNrt6Gy5q9/UrBtGtHY6d4MTQGLNxWjKVJPyLqU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NKpsh/cWLRVPfoH9AsIs3tGLH/WcK7amQ5/Lb5ajqCCgAAkx/v+7el3x/RoUGRqmW
	 ULV3RZObDwd4XBQ9aNIHStka5O7H1aRc4TC5uaMm841NPsXs0ejXH+Ld1MjO5gPFKt
	 LjzfNWti0qJ5wIu403detElJDM5opZqSkCMmp+wyPY045Im+l90NBn3u2GfoVjNjxa
	 pp7J6RJFM+eco85mqBGvpdiFr1gCsl2GlfHbIl88sgfBzWwYS2LoWTsxwp0jLLncoS
	 TDcb3SShso4pAFRiBEb2SIEDWbW4MECER9o8yse7b7ac9Ida2qoer/KWtpokkKl8jX
	 xqPEJWTQstp9Q==
Date: Sun, 31 Dec 2023 16:14:56 +9900
Subject: [PATCH 17/47] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015540.1815505.4202138808019867178.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 102b9273360..dcf048aae8c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -737,9 +737,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RGBITMAP	31	/* realtime group bitmap */
+#define XFS_SCRUB_TYPE_RTRMAPBT	32	/* rtgroup reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	32
+#define XFS_SCRUB_TYPE_NR	33
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index dc439897c98..79875968d1c 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -98,9 +98,13 @@ The realtime allocation group number must be given in
 must be zero.
 
 .PP
-.TP
+.nf
 .B XFS_SCRUB_TYPE_RGBITMAP
-Examine a given realtime allocation group's free space bitmap.
+.fi
+.TP
+.B XFS_SCRUB_TYPE_RTRMAPBT
+Examine a given realtime allocation group's free space bitmap or reverse
+mapping btree, respectively.
 Records are checked for obviously incorrect values and cross-referenced
 with other allocation group metadata records to ensure that there are no
 conflicts.

