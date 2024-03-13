Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289D0C122
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296237; cv=none; b=WKUVR+MBaTT5LPbX7D5AyIvPlGjc5fs4x7UtY44i9jZ39Le3HRNTzHF5ZL7IK/edD0TJ3yuFgNnIlZn0QVhN4YNjR3pIIyrj2XmffbxHoK0DIrRbcA5n0T3k8XRdOgrsOlCBh9HmJXXwDyw+P6NrlcXTMy0Sx4xzbqBhwgDNgc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296237; c=relaxed/simple;
	bh=3cO2YXAMesNcgZ0Rf7ZLllABv1kSgf/xFr6TGPXz5B8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BiOIoFH0evia9enCPoUotLNRJVzwv/0z1ca1x0BU94korCzFF9Rqv4rPm8nenBL8FyKHeQb8rYCwJIRfi0qnnWVUrPZ5JFdWQG27rcwA/l7K3jbGsfg6UPLFrLDQ2+7RGCgSmwySSX7yqxcjwh/TR2oej0gdD3cQFe0B7RjdcQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBJPzaF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBJPzaF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01102C433F1;
	Wed, 13 Mar 2024 02:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296237;
	bh=3cO2YXAMesNcgZ0Rf7ZLllABv1kSgf/xFr6TGPXz5B8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dBJPzaF/ZevSp7pmlzU3gKfcagstEomqZl8uCXRTgsUFiRgM6Jj1hdvR1N9p3Q24v
	 0vpaurll0RzuomPXqPJQfyvlyIYTBS5zErJBdqd0bTFBWduEFZ6XoHwncaSOJhIOq5
	 /uWsL41P1AdzVPnMT9Y/fv5e0eS7EM/wQqw8O/BX+8Xdy17wyw6pP7VJW7Vzz47ZHE
	 PSuqmoE0PlRvdMpqnYUXvB69fHafFggqVwsB9+22rGI49LkrO69c9kZZiH2/dFW5Ai
	 zG5FKfIvHzNhdRJq1SACES1ljU8rnJ5kLuuE/yCrDI1jMNLY3AiEJhSE7MG6QMOGdH
	 qnJBgs1toXO3w==
Date: Tue, 12 Mar 2024 19:17:16 -0700
Subject: [PATCH 2/3] libxfs: clean up xfs_da_unmount usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029435204.2066071.12077621897985625395.stgit@frogsfrogsfrogs>
In-Reply-To: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
References: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
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

