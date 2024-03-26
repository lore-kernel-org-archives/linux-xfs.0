Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED50486AC1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423690; cv=none; b=EbBjP+e7g/YZ3yzNHG0TIMnBaPkYxwlsjU5NvzoJf55C2jtVSXMhrtTuZjENbw/BPqPXCv8pWGvpH/61bVHjivl/rAOxWQ0QUPtYyoAb9kdofzRYW0DOUlnr+ttoewWjZTXFcxUWQ67NH/GIUzSkKSogx/32lyPDjwi3ur/qRIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423690; c=relaxed/simple;
	bh=J94Zt5fhfjTMgv+WL6CiT7XFBZoRm07AkoKxd+gbMgQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6HTaLKx3Hj9Ina9v36vmfNPpLiMafV1wN0Vxy0tIZzmMH8+E7SpxN3CvkelWHnOwBOPORMFg1iVo7GJSzaPAKZQP7rxb6UtOdlMi+e+0g1ZI3jpL4z9c6+0ZwelMTTmj71cD6/8cvjpvKkF/KIud/IN8mop2spG5LAyEpIzXVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frxeCpCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frxeCpCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61784C433C7;
	Tue, 26 Mar 2024 03:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423689;
	bh=J94Zt5fhfjTMgv+WL6CiT7XFBZoRm07AkoKxd+gbMgQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=frxeCpCgF9mG+qi40qK7sq1MN3bf/ZmkbJqEFKfb4lZRPGGXZYf4HVNYro8NcY6Lp
	 44kUqzWyqmWEC/nWysvojqzTlDyk4EiykI+20tI6Qkb66W0p+Aon6K2A/binu4w998
	 M7nE1xqkL2QnBgPHR1lgZk1dXbrWuWsK4sSJnmz+4STpu2fCFD/mL2+4MNJi9bQ12p
	 eB2rNpB97xp9cv2SCNwVTYYTh7/UCmp0HkOgV17rjTeYuT6JH7PnlJ8g9egg3PUBGT
	 iuO/fTSjAl+fS2iPH43ospwVZIkxsNrPwNov6XY0MnuMLy19bWhU/nLAGUhk2QXDPi
	 t3/UxALWp7hPg==
Date: Mon, 25 Mar 2024 20:28:08 -0700
Subject: [PATCH 2/3] libxfs: clean up xfs_da_unmount usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130801.2215041.494353760427148201.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130769.2215041.13045675877934918888.stgit@frogsfrogsfrogs>
References: <171142130769.2215041.13045675877934918888.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index c8d776e3ed50..5641b9bef6bd 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -721,7 +721,7 @@ libxfs_mount(
 	if (error) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!xfs_is_debugger(mp))
-			return NULL;
+			goto out_da;
 	} else
 		libxfs_buf_relse(bp);
 
@@ -735,7 +735,7 @@ libxfs_mount(
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
 			if (!xfs_is_debugger(mp))
-				return NULL;
+				goto out_da;
 		}
 		if (bp)
 			libxfs_buf_relse(bp);
@@ -746,8 +746,8 @@ libxfs_mount(
 	/* Initialize realtime fields in the mount structure */
 	if (rtmount_init(mp)) {
 		fprintf(stderr, _("%s: realtime device init failed\n"),
-			progname);
-			return NULL;
+				progname);
+			goto out_da;
 	}
 
 	/*
@@ -765,7 +765,7 @@ libxfs_mount(
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
 			if (!xfs_is_debugger(mp))
-				return NULL;
+				goto out_da;
 			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
 								progname);
 			sbp->sb_agcount = 1;
@@ -783,6 +783,9 @@ libxfs_mount(
 	xfs_set_perag_data_loaded(mp);
 
 	return mp;
+out_da:
+	xfs_da_unmount(mp);
+	return NULL;
 }
 
 void
@@ -905,8 +908,7 @@ libxfs_umount(
 	if (xfs_is_perag_data_loaded(mp))
 		libxfs_free_perag(mp);
 
-	kmem_free(mp->m_attr_geo);
-	kmem_free(mp->m_dir_geo);
+	xfs_da_unmount(mp);
 
 	free(mp->m_fsname);
 	mp->m_fsname = NULL;

