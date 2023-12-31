Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F50C2DA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYlhMorI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1EEC433C7;
	Sun, 31 Dec 2023 23:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065657;
	bh=GTYM4YePpQzaZbIjnxH3IEMv+II+VgzHDRWDDCem6Ko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZYlhMorIGc+Maiq6EWL9q/dY7/m+uKhSaxSx6wkdlJdaALgnSxbCqcggiHQGUDXGX
	 8/pewYNbtlLP29ABJHfLArcoxSh3FBoSb3enYfD0vO9uBuwkdiyRacycXuewjv2SRs
	 xUFhFO8775bv+3ejBUfiRIMgdRLHg4qQOIFSGnbWYxN4pEHg6Uyo4B7CSh0a5PSSac
	 eRe2fLAnNo/HnP872AEP9mjTgB+M2u9zkIE9B+YoBN/3gs5oianpD27p5Id67DG/e/
	 Myrs5FkCvVWsVBRrGzeW0vgNfk4fyf//rnMvS+n1dg6zHxdY4zf1PyNYHDuGmfgQ3I
	 9GW22VbGkxJHw==
Date: Sun, 31 Dec 2023 15:34:16 -0800
Subject: [PATCH 18/58] xfs: allow bulkstat to return metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010188.1809361.9107414533584480320.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Allow the V5 bulkstat ioctl to return information about metadata
directory files so that xfs_scrub can find and scrub them, since they
are otherwise ordinary directories.

(Metadata files of course require per-file scrub code and hence do not
need exposure.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2e31fc2240e..ab961a01181 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -491,9 +491,17 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_NREXT64	(1U << 2)
 
+/*
+ * Allow bulkstat to return information about metadata directories.  This
+ * enables xfs_scrub to find them for scanning, as they are otherwise ordinary
+ * directories.
+ */
+#define XFS_BULK_IREQ_METADIR	(1U << 31)
+
 #define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
 				 XFS_BULK_IREQ_SPECIAL | \
-				 XFS_BULK_IREQ_NREXT64)
+				 XFS_BULK_IREQ_NREXT64 | \
+				 XFS_BULK_IREQ_METADIR)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)

