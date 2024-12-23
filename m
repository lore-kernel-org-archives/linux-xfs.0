Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BAA64A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991312; cv=none; b=HOC/u3gRfNtrsGOXzmopZyz9krusEh7eytbDrDSVQny/xWiE+stWzc0jM9ueW+pGuJuFumGzrhBoHmT+2ekqO685zsN7mLzGBr7UrQ7VRyHtFstgSD9TKevHWw/r98jAS7xlGfjHz8OkKxF/YIYzW1fat03McSJGH5x1b49RJfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991312; c=relaxed/simple;
	bh=bp1BAVXxm46tMIwXm4EljSmq784/lJ0DzTeKRWBw9eQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMQ3dDd8+gpyVW6aAjMPptRK7y37T1WVqeNyEm5hc3fsm4DTdnMwx3fIIRwJhJ/FbKshA5U1eFUGc9nzr+JHk14qrlUQz/tipydrE2EJhB/OJ253vY6+HlzypCul3M5aptN977KpmhWfLTp+/i/6BohXT4Xovwok+LMFakZDVBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s3g+uIF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s3g+uIF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FAAC4CED3;
	Mon, 23 Dec 2024 22:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991312;
	bh=bp1BAVXxm46tMIwXm4EljSmq784/lJ0DzTeKRWBw9eQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s3g+uIF6CQxPSH8yYdhnKizIygu6a7cEYZXmFf+z7rxMwtNQtlAz04CnUtJZ/Drpe
	 Apj/D3rF0C/nph+OHzWBVnwfmxURSr67TS220bkKEw0DziKJl3e4PkanUfJkApPq/3
	 yZMpZUbr0B1/xdMtit3ljXCPyU/OW6D1EzFQUBczDmCY7ynZvcqt36GsN5fxiB49pi
	 il7L41VUBEo8DmwOnKRFZ6erAJP+m3XhlZTt1KQ2mpUkvl0TpLI59YzN23xzDYXj0b
	 5VfbAfaHmp+0/FLnlchGtAFX0MqIb1lhNm2gcUSD3f1k2eSEohJnSBODzr2rlaUAbg
	 MQS0gLhjTNPQw==
Date: Mon, 23 Dec 2024 14:01:52 -0800
Subject: [PATCH 14/52] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942709.2295836.10574373869363074821.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
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

