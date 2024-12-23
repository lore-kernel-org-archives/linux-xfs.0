Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426521422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990344; cv=none; b=N2VtAKZflWjGkPYNuzByD4DXnQM000AdzgZ8pLVMOzGA2YWknQbeifyORgkqLrrFSRhJmEIwTbWBYQltiG+l5daYdi3jroZ2wl4QeCATIEE13pdHllXAeeA55g0zar0bQ12ddWOg8XGWA1TV81WiR+2wQglFaqhO+3zwcyDVVnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990344; c=relaxed/simple;
	bh=dE/gX7IIpQslD7Lf/wffy5xYW2sN7a4gHVTSELyN468=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrNHZJvJ1E73EYvQJQQDAR7UF4ZrkpEZ6u0RdGMMRr3Fok4FDxUROu4+ZZGbxkh0wq6l/lgxKGVVbNSMGontDP4fTCVadqd+BO99FMf943cSoepOkgOvea8ibm14ASuwIzwABdI+uU284kpL0VKu+z+y0evlJs7swvEbbccTCuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYLo0wJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYLo0wJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3267C4CED3;
	Mon, 23 Dec 2024 21:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990343;
	bh=dE/gX7IIpQslD7Lf/wffy5xYW2sN7a4gHVTSELyN468=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AYLo0wJqBVPuiyn59Ti6i4J+MIjWGR6QF/g1REQJ8dRtsLmJ/RlLZpvOrN7QUHDSf
	 PC84EisLC8371sW9nh+jvLdmhOHz0dq/xhlMBmPzxIXpOYbHVIaageKUj0/T5AK8/g
	 85CgHTT3eLV0LRu6AZniUjbBtPYgyv2AmTvXmaMz1PONU1KdnENz+vWGe0ltz/FhY/
	 n08sX7uVIx4gMBuxRCQ7iJNarRLv0XeuvdPRNVSI8Urb7uSaoPsAPXr91hDutDq5s2
	 J2lZRGwGcqVzVLNJLyWTnxCYcKIyyAKNkezuGlXkIUomIA3ioE7aGNqGPQE4MDVer5
	 wfx6j3sBzvbLw==
Date: Mon, 23 Dec 2024 13:45:43 -0800
Subject: [PATCH 33/36] xfs: allow bulkstat to return metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940448.2293042.388425970319376264.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: df866c538ff098baa210b407b822818a415a6e7e

Allow the V5 bulkstat ioctl to return information about metadata
directory files so that xfs_scrub can find and scrub them, since they
are otherwise ordinary directories.

(Metadata files of course require per-file scrub code and hence do not
need exposure.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index a42c1a33691c0f..499bea4ea8067f 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -490,9 +490,17 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_NREXT64	(1U << 2)
 
+/*
+ * Allow bulkstat to return information about metadata directories.  This
+ * enables xfs_scrub to find them for scanning, as they are otherwise ordinary
+ * directories.
+ */
+#define XFS_BULK_IREQ_METADIR	(1U << 3)
+
 #define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
 				 XFS_BULK_IREQ_SPECIAL | \
-				 XFS_BULK_IREQ_NREXT64)
+				 XFS_BULK_IREQ_NREXT64 | \
+				 XFS_BULK_IREQ_METADIR)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)

