Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4650A17E0
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529693; cv=none; b=EKvdKOySFTEimqEl1w1ZF5dASoefFZSg+JxqDh9YORKNHkuSmY24z2FoUWpyWnFIvoURq8HwM0bUYxZ5iXlg0qwsaXXEIwSSwoROPAEGMOjMB9yl5JEUeOngQBKQ7t/qD4qBhYt85zimB7ZcIczka3GSobMgCPTor6mB2tz6CHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529693; c=relaxed/simple;
	bh=XIsbQYlZ5NMAXIDveOO6uxLjfpXf5sompTCTutu4oSw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0XMecGV3xk1b3BJThru3dfYRJ2fIP5A5mDJrPTXVTdj/WobtDRr+8XhEtKsSYTDykBWT8VqoELuk8DkJ2xA+/Ewbkb9B2/aIXJH99kQi5kGLDs0vjFD0dNKfKQt7NlfKsryeOvQa0LKVzkxYqvwhxbINlCkJD36SytSSh1krUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZ0B4wqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZ0B4wqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F8EC4CED1;
	Sat,  7 Dec 2024 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529692;
	bh=XIsbQYlZ5NMAXIDveOO6uxLjfpXf5sompTCTutu4oSw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lZ0B4wqsZn9BJlThqkUKUxvYz/AghaOaxVeMPXiwv7V3JWmThyW8+7GwxkFkbpgPR
	 wf2JOKfP6WVFokw648rHVy81s3tfoBZjRaYRcAQt6hR7cugg/GwBAm1wK4M1Pg0Aqa
	 jAzSpuqmA+EIQF1Hh/QidraE6VYorWB5MXuWHVlD7Kw58B1l7gJu5630gva5mrCGg+
	 4zE7vYYBAKTJXCF6CGP9j0IsdHrL5MGE0QiqVP6Gd9J2xX4xj5ZbNYHt6UnOvyvo5I
	 wIAVtkT7MYwRvjArlfZ6C01HCen0ilEbLofGuXSbkJARvLROc2pZM8f0CUTp4QdptN
	 9MWBISB35TYig==
Date: Fri, 06 Dec 2024 16:01:32 -0800
Subject: [PATCH 39/46] xfs: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750591.124560.16146836273346836231.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 128a055291ebbc156e219b83d03dc5e63e71d7ce

Enable online fsck for quota file metadata directory paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 96f7d3c95fb4bc..41ce4d3d650ec7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -825,9 +825,13 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_RTDIR	(1)  /* rtrgroups metadir */
 #define XFS_SCRUB_METAPATH_RTBITMAP	(2)  /* per-rtg bitmap */
 #define XFS_SCRUB_METAPATH_RTSUMMARY	(3)  /* per-rtg summary */
+#define XFS_SCRUB_METAPATH_QUOTADIR	(4)  /* quota metadir */
+#define XFS_SCRUB_METAPATH_USRQUOTA	(5)  /* user quota */
+#define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
+#define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(4)
+#define XFS_SCRUB_METAPATH_NR		(8)
 
 /*
  * ioctl limits

