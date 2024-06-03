Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4EFF9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440708; cv=none; b=n2ydkTzBSxCNmWp8UcAztQriZfUo1TpfstPnawW5SYZGYCywlnxJtLDiyHDnptTs3dVXPYiObnHIJGYo4/aT18CqoW2i8bC4viTfeIJ6JvazltoUmxKVpKmOn5XKGRjmy65F06ENlkiuPbVFhsH8OFFKFaIb5+QNrQN5Qyg1KQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440708; c=relaxed/simple;
	bh=SpAgybialj+xMBW6sZNsnTZpb4GMoeTSt8MPhy2C/DU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iP6TU3BcBqrG3cwipknhRXiSCvgMVAZFuGlJXTQS9ZLF/P6JSEmdLGzA/OYCec+FmGDXxdb8qFtjFWf79/0ESggIv300xM8cEcHLbRU0/1oXV5UVP1m4F7H4o3+6B50jVIbCmKtyVG9eEowPdd6gvr5vDTd8nyQ1KcmilppwuGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYDvNG/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYDvNG/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E391DC2BD10;
	Mon,  3 Jun 2024 18:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440708;
	bh=SpAgybialj+xMBW6sZNsnTZpb4GMoeTSt8MPhy2C/DU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LYDvNG/D9gYVp0RoU0FA50a38Mwyqbma7cgFVvQczpO7j8IEYLgf3lSYV3u982Clv
	 wKxrohHti/jPe/nDD71w+aETb7pogVNIMNZ1ftBENTgg0RYr9+AvkQgn0RmPm64NZJ
	 C8qClZwIU1QRz9F5nB5WEBjSuwUD9LfXK09jgJ9A8i/JeqzfKFIvUCivKqgo9BpF+1
	 rw6odUl7tCTP1KuKdICIhJZ8+1m8OCcROkaHs5RRAnFK119dHR5hxX9d/eqWPRpX0y
	 wNFB8ki7JrBV63VK9oM3N26dS9c7mDWUoGe8BwJlrqIYZbG8a16YsNAzcFZ/lozYA7
	 dUSL096nrolGA==
Date: Mon, 03 Jun 2024 11:51:47 -0700
Subject: [PATCH 2/3] libxfs: clean up xfs_da_unmount usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744038818.1443816.10604499988707562569.stgit@frogsfrogsfrogs>
In-Reply-To: <171744038785.1443816.16653837642691924792.stgit@frogsfrogsfrogs>
References: <171744038785.1443816.16653837642691924792.stgit@frogsfrogsfrogs>
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
index c9c61ac18..b2d7bc136 100644
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

