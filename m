Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA2148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529301; cv=none; b=tHXzoJTuEUI+yYRiv33jMxc6gEzAr6iyp6EZrtmPpovPJ6md67TSzQxAZLwaRYhIy+aRFn13OlrKt+rTVTaDyIdXZxJXcrS6J2CUwqJexy1Pjuyid8FemCyEWuD9mWqRblljHfqJmH80ULhUMlAAH//1JdrqdAs8Hpl0JWkHxQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529301; c=relaxed/simple;
	bh=bp1BAVXxm46tMIwXm4EljSmq784/lJ0DzTeKRWBw9eQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlLNODJmcAcWels+hFdfnOx2UHkm8jBCwMh7y6wFvxMy+DHBSMcV94B1Vs6xq0PkGfLGX7TaIdf9guYZpc2ZCtWCBGtgLFpYCK45RHXsBoaHFUsc/6OiVnQJ6hYmc2GDTI1UkhdxI/KRM1Xsn2C9YhKwG4YNnsjQ4Km13SenRv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pY/UIpEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pY/UIpEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D148C4CED1;
	Fri,  6 Dec 2024 23:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529301;
	bh=bp1BAVXxm46tMIwXm4EljSmq784/lJ0DzTeKRWBw9eQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pY/UIpEHQxn0apa08j0wGv36duhvyckMfcS5LncJsS61DiNk31KaYWya7XEvb9Bqs
	 iP15VgS4aoM86X9evFmEwiBAOMDfOpTzVcuIkojNGN/UCwO3s6ReIekV3LCsCq5gkw
	 HlTITBcZgl2++Lybv7tox4czf3p4uBtuJ5hchvwPLHssEaab3pcTyhLM1ynIbkLu9B
	 XR0qDo8X/ptSmVXSL5r7J50FdoffIPg/cKLQ3TygFjOyBtchZVtETpCaB8S/2cvVN4
	 Vawjj5fJ2D4H/z39yQluSsJvEFb0SHCSKi5meP9sGdnkF7Dkg08iJZGo+KsA1Wmpni
	 T1Gbo+/yq0ang==
Date: Fri, 06 Dec 2024 15:55:00 -0800
Subject: [PATCH 14/46] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750208.124560.17162614860131545242.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8edde94d640153d645f85b94b2e1af8872c11ac8

Export the realtime geometry information so that userspace can query it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    4 +++-
 libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index faa38a7d1eb019..5c224d03270ce9 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -187,7 +187,9 @@ struct xfs_fsop_geom {
 	__u32		logsunit;	/* log stripe unit, bytes	*/
 	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
-	__u64		reserved[17];	/* reserved space		*/
+	__u32		rgextents;	/* rt extents in a realtime group */
+	__u32		rgcount;	/* number of realtime groups	*/
+	__u64		reserved[16];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 96b0a73682f435..2e536bc3b2090b 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1424,6 +1424,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgextents = sbp->sb_rgextents;
+	}
 }
 
 /* Read a secondary superblock. */

