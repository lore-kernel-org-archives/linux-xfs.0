Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32422FC1D;
	Wed,  4 Dec 2024 03:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281366; cv=none; b=puSXMMgjBMCWFhaYpl4oj68B2EBy1KZCxrKRC1jBzhNF1J413xgYTwirZHKDuPZbxXFny1My4bb6qdsz6A97DNmaroBvQ9Vg9JKsiO1UwoKO+gS643GkPuAPBMBwizPu2WW/wqyP9d8WHscDUfmZxtMR9WjjvOaF0lY5VZJ+9eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281366; c=relaxed/simple;
	bh=Maz2LbzoGI6xm0fNVl+vVrV3CgDAB4vqWeM5uCVdx/s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Df1l6eIy0EiNc2HbjIThelcGagEXy3AIrfIh7qJJZiiUkLdKdVmPV3M+2IeY+2Oo9/f2HDiyB1qc2Ge/vw2IVaYkf52zKCndY3wdeWlEobrfQTx2bhnltKIfKw6WDptNIB5UwmMW8zGPsN5pZJUc0vLHWny011lR8fFU1t+YRTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u6DdncGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6DdncGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9336C4CEDC;
	Wed,  4 Dec 2024 03:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733281365;
	bh=Maz2LbzoGI6xm0fNVl+vVrV3CgDAB4vqWeM5uCVdx/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u6DdncGOJzpy6rpafOJPXdePxfkDmOrlfgr2ZL1EgYgKgWMmrd7yyKSra28uXplXC
	 xHPRTzOp9AKbtA/7+igIEIV1UaEzuHOYbhJEs+vYhH8yw8eqloKQOnrQYV2yvivgUh
	 vH6sCaLdQKeTpiwA/j/ANeQOuwUw/oTmsN/hU0ae4DxjASQ7/TekyOKBjGNPr+txOu
	 C8qEg0QHAwwxzTatQYZcZ5rJeAjlMEIlWeey/vCRKjayuRJ7Gki5noSy7v59egKt9b
	 +3QTe+igDWqjVFoXlA9gQAQmQWr2B5lV58hCCPOAQX5SV2AmYS+DEPpleuoqqvS7nb
	 fmCVfk0OmeQWg==
Date: Tue, 03 Dec 2024 19:02:45 -0800
Subject: [PATCH 2/6] xfs: don't crash on corrupt /quotas dirent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173328106618.1145623.18381388947501707203.stgit@frogsfrogsfrogs>
In-Reply-To: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the /quotas dirent points to an inode but the inode isn't loadable
(and hence mkdir returns -EEXIST), don't crash, just bail out.

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: e80fbe1ad8eff7 ("xfs: use metadir for quota inodes")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 69b70c3e999d72..dc8b1010d4d332 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -731,6 +731,13 @@ xfs_qm_create_metadir_qinos(
 		error = xfs_dqinode_mkdir_parent(mp, &qi->qi_dirip);
 		if (error && error != -EEXIST)
 			return error;
+		/*
+		 * If the /quotas dirent points to an inode that isn't
+		 * loadable, qi_dirip will be NULL but mkdir_parent will return
+		 * -EEXIST.  In this case the metadir is corrupt, so bail out.
+		 */
+		if (XFS_IS_CORRUPT(mp, qi->qi_dirip == NULL))
+			return -EFSCORRUPTED;
 	}
 
 	if (XFS_IS_UQUOTA_ON(mp) && !qi->qi_uquotaip) {

