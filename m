Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0AD20E6;
	Sat,  7 Dec 2024 00:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531483; cv=none; b=WXVcX1m1qh8Vy9HaQZZ167zwy+5cy5a/FjKGD8sTwb5dI4wmvmZBLN3NO5qibZemL/ImxV1GWL/wqoiMgqLcQsVLMOVwsqCozk/zxLSH4qzDd66OCgjogLCqZxW3MVMfFFklTET0m4GL+W50ZAc3OrrHBaxi6bc/Bgah+qzAZKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531483; c=relaxed/simple;
	bh=jYJayrTQJvKRAI0mBU27ZP63G//tvKs0ArIgrBMb7G4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EY2Bbg5XgQUzpAgPtklqurQHEB1LYmTwPWW7AcWOsW0o9DBlChaNqjIku+weNr/n0m/nUiUhI8Yl2YK2E1DGyCaKiTjq36vi7xc7sU4nasdGdVh0nc56JwFunQeUldtNntgoWJW9SbW/AVMCxIiMVNsfesw8ySRI2VVF+7/JoLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tjkx2n8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tjkx2n8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25844C4CED1;
	Sat,  7 Dec 2024 00:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531483;
	bh=jYJayrTQJvKRAI0mBU27ZP63G//tvKs0ArIgrBMb7G4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tjkx2n8kIJDMqWuZqhZ7kldgQPhQ9pYAQ9p5/bkecE7Cb1i8GLh9xpgZUOvLr3sVn
	 q/sSUYt4OyBLqDXBSrfJF+zBoeNLStZhiaPX3umu8po5jq6gSwxFSzp+wxiYzc0Rg0
	 x5ly0D+t0hVjneey++lMq21RvXr2BkYtJ3UppySg3X5gnvaDkUWD1KHNc7fRTwNbRL
	 H2lQNXjgFSnm2IlbEKlpLzICoAqKW2yQQsj/3x7Exje3jIKWwEq45WsukpRq+JbXeo
	 jNbe3URH/on95nIqjq0XOjIXnzXWz9HuWagpmV9vK+lj674s8JWNJGxr9P1+oaA62H
	 4rabikpsKaClw==
Date: Fri, 06 Dec 2024 16:31:22 -0800
Subject: [PATCH 2/6] xfs: don't crash on corrupt /quotas dirent
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173353139335.192136.5415870424463872835.stgit@frogsfrogsfrogs>
In-Reply-To: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
References: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

