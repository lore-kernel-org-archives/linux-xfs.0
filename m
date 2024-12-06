Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D0721506D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528333; cv=none; b=cbP/FDIpvL0L0swltPeW1Gj14DQX3fFHuUyCLEbi/d1Yqk0xTGd0IgQ6phQFPbqIFzXZ2Z9k9/ydAJsAMc56CUW9ReOzO9NCIZC9G2Gb6t/LCvQnr+kt5/Y2dUNSd18nYwv3xmJGiQdvDqv6LvErJMFr7h7fFr//4IRRD+4i75I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528333; c=relaxed/simple;
	bh=dE/gX7IIpQslD7Lf/wffy5xYW2sN7a4gHVTSELyN468=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=us6TqFR/ONkEbjCTqoURy0NIBISn3NxqVyNyJyTIW6SyszsFqjzo6Hnjhs/xxrsvzPen6dKuFdF9QCaPAsGf8BRGynO8u0CYwAsaCGEtNkFBhaQYy0LKndzgeqqoLkDr3XNd7XFLMl48vDsOiZk6D8ab2Phw82VtzHRTSv2XbS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qw6eERvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qw6eERvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AD0C4CEDF;
	Fri,  6 Dec 2024 23:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528332;
	bh=dE/gX7IIpQslD7Lf/wffy5xYW2sN7a4gHVTSELyN468=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qw6eERvNLAXoBvo0qo+9sv1H6sfISysYQuchNtlv08Df/TfqxWVIbbuvA0LhRAhmG
	 TrYcPINmsMGtu5uEJrnrgoFGzOTyjUcK6x3zyFQW2hR/oNVUjTqkiBVBJSDflpPlZo
	 sOq7I+MJxb/QsgfazWWoBJw3ziA6zlO5X6KBm9CJzYOj7nAkC/CZ9xYy+Rqc28eBds
	 X3pIrqifvLWcnZA0c232/w3hsturjpjJYaZL8BvBuCaZYlpY9ieeuKsqEamBlrbD8J
	 HsgxxiceuNAL1fEbXe+BJn1sevfLtEkjPE9/dMUSvnx6lwiQ34D/In06QdyOuabm33
	 ZkOpQz2c9R/FA==
Date: Fri, 06 Dec 2024 15:38:52 -0800
Subject: [PATCH 33/36] xfs: allow bulkstat to return metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747380.121772.12137566266343094869.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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

