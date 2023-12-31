Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B429DC2DA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EahYD2Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243B9C433C8;
	Sun, 31 Dec 2023 22:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060889;
	bh=Bww2N1IjRuxcG1H4IQPH8+RZYtb10WNeS35Ert8D428=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EahYD2YmeJF5ZrxlBSZpRx9r1NmnYzLPihLnLKYNn6wHwKsKjZX5IhRuIunW5/3nr
	 ShrRzS4FMZeYWtFMHXzDimUSiIZz33E22ZxKOFVGMDd0T3HrWXRrTDaqGzJ22+YOcV
	 5ZHCVsqYj34aiK+epeZqDN6dQd/F9vLMsrSBM9c/ybRHz7FynxaqCUGtM3XNddCAi0
	 fQqw9V9eFi6hjSjlGIP6Z60Ez5qzDuuoarzXm+Wp7TE4wdx7IMsBBB93H5wOQOA/pt
	 guwHZxvIxNw6yEHr4U+qHqSLQnF4dFhtSV8XcYTr3g9y6xCXSl2BPBRNPsqGKNSJFS
	 VqIHB1wPMasjw==
Date: Sun, 31 Dec 2023 14:14:48 -0800
Subject: [PATCH 01/10] libxfs: clean up xfs_da_unmount usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992795.1794490.11964384959099526040.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
References: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
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

Replace the open-coded xfs_da_unmount usage in libxfs_umount and teach
libxfs_mount not to leak the dir/attr geometry structures when the mount
attempt fails.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 1e035c48f57..f15ac48a21d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -716,7 +716,7 @@ libxfs_mount(
 	if (error) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!xfs_is_debugger(mp))
-			return NULL;
+			goto out_da;
 	} else
 		libxfs_buf_relse(bp);
 
@@ -730,7 +730,7 @@ libxfs_mount(
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
 			if (!xfs_is_debugger(mp))
-				return NULL;
+				goto out_da;
 		}
 		if (bp)
 			libxfs_buf_relse(bp);
@@ -741,8 +741,8 @@ libxfs_mount(
 	/* Initialize realtime fields in the mount structure */
 	if (rtmount_init(mp)) {
 		fprintf(stderr, _("%s: realtime device init failed\n"),
-			progname);
-			return NULL;
+				progname);
+			goto out_da;
 	}
 
 	/*
@@ -760,7 +760,7 @@ libxfs_mount(
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
 			if (!xfs_is_debugger(mp))
-				return NULL;
+				goto out_da;
 			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
 								progname);
 			sbp->sb_agcount = 1;
@@ -778,6 +778,9 @@ libxfs_mount(
 	xfs_set_perag_data_loaded(mp);
 
 	return mp;
+out_da:
+	xfs_da_unmount(mp);
+	return NULL;
 }
 
 void
@@ -900,9 +903,7 @@ libxfs_umount(
 	if (xfs_is_perag_data_loaded(mp))
 		libxfs_free_perag(mp);
 
-	kmem_free(mp->m_attr_geo);
-	kmem_free(mp->m_dir_geo);
-
+	xfs_da_unmount(mp);
 	kmem_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		kmem_free(mp->m_logdev_targp);

