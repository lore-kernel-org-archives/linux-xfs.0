Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1337128381
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423674; cv=none; b=DRjkIGVgeZL7vjAJ+pZgd8BobGGXXC5FpkW9poflEZFhtiu574d4cXe+zYGofksS3aL2nVXQzb6wdABG93roLVl3zvfFbyLGqDESN7TfSkNMnZdmkG7O96ADOlV7nNAEq7swgxfoROw5ltl9Nb1P6FZCUeo4WDje8koXRBmzu0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423674; c=relaxed/simple;
	bh=Jgvuj/GLOBNFYOCk2Qn9WVie7o1783eGbX+CBlUKyXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9KPjiM+yDzbNuNfYu7c3bzuUr0BHQ5a4HB5m0fmJTjNUMzSfTgmfG2sK1iLKeDkRh5XqzS8cIY7ZHZJ2/aPJH1IY6YR4x85yNG1fdobf/CUuuNE9RjtZNtbFt+As80Qa77n0xOukDJy3m5GJP20vNV1wI0uMAH8kWd+kBvVMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awCzmgc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awCzmgc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B573BC433C7;
	Tue, 26 Mar 2024 03:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423673;
	bh=Jgvuj/GLOBNFYOCk2Qn9WVie7o1783eGbX+CBlUKyXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=awCzmgc3i8cyiMb1Sq/m/9x6eH6hCU+ZK6Fbl8HrUSxyE2FXUXFe0hCHnBpTggPy8
	 ol61cNL0Xv/GndmtX2OZstcj3Wp4dANHoHH/kPY6H7mux6OProbxDli1XUMvS/33IT
	 VIkqsxV0qseU4pFU+SufLGn4vPnu+AxhhihYdr+SmtUPOQwBK8o1xlD4r/AUlxGwaS
	 VeU7oElvzmCxQ4dCUJU32wveR3YquBkU97qIFw9gF4ARkOzswd2YwL4E+qF3oek2Ln
	 Q+TOD88gJ9oSRuIGHjlPLDB3YqPvEpQi5VH/QTmzSze+rceZk0ZAJMwatErO91kqbl
	 XmRIKwd4eeHJw==
Date: Mon, 25 Mar 2024 20:27:53 -0700
Subject: [PATCH 1/3] libxfs: actually set m_fsname
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130787.2215041.8235789914166398192.stgit@frogsfrogsfrogs>
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

Set the name of the filesystem before we actually start using it for
creating xfiles.  This leads to nice(r) output from /proc/maps such as:

7fcd0a44f000-7fcd0a450000 rw-s 021f6000 00:01 3612684 /memfd:xfs_repair (/dev/sda): AG 0 rmap records (deleted)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 1e035c48f57f..c8d776e3ed50 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -643,6 +643,11 @@ libxfs_mount(
 		xfs_set_reporting_corruption(mp);
 	libxfs_buftarg_init(mp, xi);
 
+	if (xi->data.name)
+		mp->m_fsname = strdup(xi->data.name);
+	else
+		mp->m_fsname = NULL;
+
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
@@ -903,6 +908,9 @@ libxfs_umount(
 	kmem_free(mp->m_attr_geo);
 	kmem_free(mp->m_dir_geo);
 
+	free(mp->m_fsname);
+	mp->m_fsname = NULL;
+
 	kmem_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		kmem_free(mp->m_logdev_targp);

