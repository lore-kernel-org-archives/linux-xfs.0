Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A91F21C18B
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191873; cv=none; b=aS1pWuo3KgWUCcNCeceLQgIg1DveVPWyvYm8upkr+HZqXWqG+hoKAVidAADki5qAe0MZVXkEGHmWtply+Ff4xxcM0x2lkla3fopwsqe9yCm9G+EHxe8MTpNkqf4mis3aCHZgo+ub4V7l+DzuUvR1ZQJkZK49w4osz21mV+zjb8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191873; c=relaxed/simple;
	bh=3MhcNq9E7Zhfb3Wl3p4T7RJv8Gs3D/NgwmzTCH7Qs7Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPLuZguWCNbjpeUxM+kg6bx2fLUxh7PngAEXwUJoHgTys0B5fOz+e0rthWhdlHAi2M3K9dn7bjJRwwQe9+DWvhKwpKevpHpDm3qHP41Tk5VUnoeMXwRVQwC8OtsknZhQy/OWAgS9ClVYkfCQ62pXkei3Sv5yEIp2jyrPdL7B8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sCVaWB9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sCVaWB9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CEBC4CEC3;
	Thu, 17 Oct 2024 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191873;
	bh=3MhcNq9E7Zhfb3Wl3p4T7RJv8Gs3D/NgwmzTCH7Qs7Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sCVaWB9F5dLKzB/E7UIXwLVxHlDghysRlktIjjaYuEiDuxqD7mwpoKVgFideAf8xx
	 KVw76/hrPDzHlTswdCEtqEs/YAodX13NfbwzipwdpfAk8Pj48GyHwurieX53FelOod
	 dx1MJFrCLOV6hUNSx193ENaeVZ54LSsqRAMbb8dCiIjiEdI3CKn2cj75wTGHKkSTM1
	 E7GpqDweQSWqxZg/SlkK/1t23IzEwzoQop6zLu6Fjf/XuFsyHt2/1K+DNvCWEc2tEh
	 hiY1SAzF/guH5Kh3ISuV7TGASA6SGBEvDUz9G3B2W3cd34xPQFqyeqYQ7fXW+coFM4
	 2+8YrzkF6eqUA==
Date: Thu, 17 Oct 2024 12:04:32 -0700
Subject: [PATCH 04/34] xfs: export realtime group geometry via XFS_FSOP_GEOM
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071735.3453179.3805342059369104132.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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
index 6b0757d60cf3af..b1e12c7e7dbe23 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1413,6 +1413,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgextents = sbp->sb_rgextents;
+	}
 }
 
 /* Read a secondary superblock. */

