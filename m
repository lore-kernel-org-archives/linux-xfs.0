Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778318F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608564; cv=none; b=YK5ym+M73IIhklnVhqoxmRHTE8AGs5p+uPw5x6UOKWoosIXffbQFguuAn0q8pJpq55djagUKcTNZjpjluZw/KCA9f2dwLuo+DObOmCTSWst9X5GuDu8Ir+cuEcLma8kgrGsQ264y+jpJGl1/KOgZ7qD5h2ctay4Htm8BwG29OFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608564; c=relaxed/simple;
	bh=aXhabKKEmjdKHg0SJJaO4P7Y8Qwmk5s0udrwEBmN804=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cSixUKhXa9+8+gSd0vuMQ1zaooJi5S5Ccxs7Dczyqk711e4DJOT7jXv+Im1yxwajFKUd1hbOk6A6YbgerWT3A5Gr3MQRCEOJ9fn23hA5gyex7RVtOjbOe0vDeuJQIrxdiszcu0PBqBDpmcV17+DseeCMT8DJpiSXki3wgoOIcKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWgsNVor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWgsNVor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531DDC4CEC5;
	Fri, 11 Oct 2024 01:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608564;
	bh=aXhabKKEmjdKHg0SJJaO4P7Y8Qwmk5s0udrwEBmN804=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LWgsNVorTAGrfvGvbuqfimKgGNC2qJRVziEk8C3iRYolQTVdapdCjy820v83WQUrh
	 zEHUJD+oI/d3BSWMqJdmvwu6Xy29jU83FEuU4pLzEeZa20Za1rUcoPZ4ryXYFlYRPX
	 cVqm80qVO2gywUE7k099CJ1YrkFFW4VUt/L6dggXxGwgoFEWLPJ+lq+1Hne1HKKmYC
	 LFvF4a8RMGr9y/7VkIbWaVgyMBt8Kunmlah3fxTnyrBxF1WwSepvfHui3Q4bKfixvo
	 WY1vWcWPU3S6239RA+F1PjbwHM9KKGf+jZWjsMblvTxIM7n0a3xj8G0h0fn/JbZ45E
	 4hg/JoAs9gjHg==
Date: Thu, 10 Oct 2024 18:02:43 -0700
Subject: [PATCH 04/36] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644308.4178701.13988052700465758346.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Export the realtime geometry information so that userspace can query it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +++-
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index faa38a7d1eb019..5c224d03270ce9 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2b0284d78028fa..f13904a9b200df 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1410,6 +1410,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgextents = sbp->sb_rgextents;
+	}
 }
 
 /* Read a secondary superblock. */

