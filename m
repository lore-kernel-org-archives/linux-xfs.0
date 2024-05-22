Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66B4DF5B
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346111; cv=none; b=HEz/z8Sg9xdhk6baxQdOPUIxz6UbC2TwNACU/IKQ+T/nYb+lAYkVQ9G148fD+fIiryb6TklhRpy0DEtqEmcGpBeLAaMhJqzvHyu+zvvfbabGJVPFcr4skYl/WHOGpg7j7Cpjnwh3uu7QAiVLsqtDkPNxqleO6Q47dP3VlVE7eRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346111; c=relaxed/simple;
	bh=SpAgybialj+xMBW6sZNsnTZpb4GMoeTSt8MPhy2C/DU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lz0mwx2OSEqOmW8WL2LRmASI1mx5lZzvFP9MavAMqd7Dc4SqFi2J1hVHBNFAscb49sHLojZe62lA5a20cm2WqdyoPoQ3j14J3y3ExhUThlZHbzUNInRCoMZD5J22WSAuLR8tEVPF9PVA8ujHOqrs1mQyyZ+e+i6ejSa/p3OFizo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQdfEj5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQdfEj5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50C9C2BD11;
	Wed, 22 May 2024 02:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346110;
	bh=SpAgybialj+xMBW6sZNsnTZpb4GMoeTSt8MPhy2C/DU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XQdfEj5tbhfNtqL3s+U+1JqFEhox3RMd/Mf6eLHI703eTOM0KbExYOnvwMNrxYUbE
	 Z/K5QbRFYMW8zpKiMnc9JWhpvH9NoWMXjtR91TtsavH5oFiu36O268qdIuXDgzB51F
	 x3qJYLSu6LlJ0iignv8b79p7Hk4mKuJPK2HeGquxhYSH/l12135q83anUb4hQwnwYb
	 Yduw21SQzsEfsWU92ouFQraTDA0e2qSU55sP7upQPKUlLEfjLjxJ6mvsHX2xRLEQQI
	 EmIdGs8IKCNznCgXrcf/nZam5j6cSiY663lvIXxAfeYj1ZCVHYoWgQmIOJv5Jbvf7C
	 KEPs6LI+r2kcw==
Date: Tue, 21 May 2024 19:48:30 -0700
Subject: [PATCH 2/3] libxfs: clean up xfs_da_unmount usage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531171.2478774.394963380985005419.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531139.2478774.17043099852261356412.stgit@frogsfrogsfrogs>
References: <171634531139.2478774.17043099852261356412.stgit@frogsfrogsfrogs>
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

