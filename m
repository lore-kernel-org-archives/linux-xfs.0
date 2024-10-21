Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9B2195FEC;
	Mon, 21 Oct 2024 10:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506962; cv=none; b=D3glU6kF1tUInVs2Pto9QvESVHaKE6eJyo8StiSHHVA15edz/CdzMp/WMhGOCOCGMW058dLzicMPA3cctmnuYoqBzunD6q1DXb4hWlmlm1G7/mcmrJ9D+HzHwd2bCaxobbd310U6CThxbNs6ab6wnGEBvzR3V9zu1mwdTWngpkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506962; c=relaxed/simple;
	bh=pwhjJQXH/iVgPZehC+oZFBS0OczkkrdU/um2PTezWdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpFxiXLte496aqK4zDvr0XdjIwIZBB5QAfHh7kX8pg8DSP42SpGy3pCEM/+UtSOfdVuuwc7qTUERM5w7eqwhRcW94q0zF+5vIlo7g2Y42dvEniHU0av1uTusDh8Z4LcWLzfo5XxytvWBOPFQpj6lPaxQBGAgWWpSystj34z7vjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3ZYr4rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3ZYr4rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3DFC4CEC3;
	Mon, 21 Oct 2024 10:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506962;
	bh=pwhjJQXH/iVgPZehC+oZFBS0OczkkrdU/um2PTezWdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3ZYr4rqVJzOiguHt+/aBQMfa+yq4NHwouI+3ISUrXJwvNf31JYotiIF2R/1N5Ye4
	 lPsro45RwCcdlHDRhPsJDIFNXXLnP0VxBmOokBBEaCxRvSLSnyYloXmCUnW4sJl0T0
	 nmUpzB6zCONDV0ozf5tZYwxzLI2NxyCVr1Plyb5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 043/124] xfs: allow unlinked symlinks and dirs with zero size
Date: Mon, 21 Oct 2024 12:24:07 +0200
Message-ID: <20241021102258.395753218@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1ec9307fc066dd8a140d5430f8a7576aa9d78cd3 upstream.

For a very very long time, inode inactivation has set the inode size to
zero before unmapping the extents associated with the data fork.
Unfortunately, commit 3c6f46eacd876 changed the inode verifier to
prohibit zero-length symlinks and directories.  If an inode happens to
get logged in this state and the system crashes before freeing the
inode, log recovery will also fail on the broken inode.

Therefore, allow zero-size symlinks and directories as long as the link
count is zero; nobody will be able to open these files by handle so
there isn't any risk of data exposure.

Fixes: 3c6f46eacd876 ("xfs: sanity check directory inode di_size")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -371,10 +371,13 @@ xfs_dinode_verify_fork(
 		/*
 		 * A directory small enough to fit in the inode must be stored
 		 * in local format.  The directory sf <-> extents conversion
-		 * code updates the directory size accordingly.
+		 * code updates the directory size accordingly.  Directories
+		 * being truncated have zero size and are not subject to this
+		 * check.
 		 */
 		if (S_ISDIR(mode)) {
-			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			if (dip->di_size &&
+			    be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
@@ -512,9 +515,19 @@ xfs_dinode_verify(
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
 		return __this_address;
 
-	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
-		return __this_address;
+	/*
+	 * No zero-length symlinks/dirs unless they're unlinked and hence being
+	 * inactivated.
+	 */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
+		if (dip->di_version > 1) {
+			if (dip->di_nlink)
+				return __this_address;
+		} else {
+			if (dip->di_onlink)
+				return __this_address;
+		}
+	}
 
 	fa = xfs_dinode_verify_nrext64(mp, dip);
 	if (fa)


