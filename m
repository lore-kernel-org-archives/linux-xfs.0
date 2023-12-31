Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165E7C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkPZ9Iwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F59C433C8;
	Sun, 31 Dec 2023 22:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060607;
	bh=2tLiQSpxHEmh4bIia16WLvHqYu+mY9uVg7JjTXzJVeY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CkPZ9IwrYiVcA77SxpBllHV4xyFodr9noWB6rcgl8SAtrDOQK93D2Xuk6riRkyh6x
	 YkQxjJ5Nv/rUg/DFypC5+/u1yZ7D54A1BihYYjhUTMvga5bNxiFDnrimaqQRtTBAhZ
	 WBv44CX+5evHL9R0NN3xEyJcYW5iU+ZmBAKAxGtAf+UC+9PAJ4NtzlLu4cNxLJag51
	 USByjAP5pAhOQ+cNLzChyd4pRKnj0zFtbLIATwGNHdmlQn0LsjxW+248qfTm31SsMN
	 RR7aJUu6YYl0CYwOo+wrVuKZ5dNo63BpW+NTAyvCRJ9W6qKPcnWpxUudHEdBed1XZj
	 75SpF0mw9qAjg==
Date: Sun, 31 Dec 2023 14:10:07 -0800
Subject: [PATCH 7/8] xfs_repair: don't create block maps for data files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991231.1793698.14185413593373261700.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
References: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
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

Repair only queries inode block maps for inode forks that map filesystem
metadata.  IOWs, it only uses it for directories, quota files, symlinks,
and extended attributes.  It doesn't use it for regular files or
realtime files, so exclude its use for these files to reduce processing
times for heavily fragmented regular files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index a6a44b85424..f2961275cd1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1929,8 +1929,8 @@ process_inode_data_fork(
 	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
-
-	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
+	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
+	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
 

