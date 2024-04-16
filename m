Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B66F6AB9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231154; cv=none; b=kMS93NgNf+9yYwzVqorG07kIz6gvhSmxuS7/fBF12iZ5kxtFfzizbBj/MCyjLg+CqixiS8JzXzeyuXlXvMh0JLj3CKkzN85pySnsMjK1Wxkv9a3CHPXb5YQgxx/UCwrDAj+7qPV5h28A9A9DO4QxI2RBTYUhtK8EX6/k+krSubk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231154; c=relaxed/simple;
	bh=iKDjM+R4HFv8yCEGIGKmjxPlmerviUoh3weHYHX2SkE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzPlC0wspP1IjvEuDxQ4XKL75UvRs2vuyAF5BuPQnCEzyma255AO7gpQjqRSvdpz746zKcK9n7xRrK/RY2ld0bvjH4WJfLMOqtTPlk2skCr68KnPY2rdlf+ERNtT7AjOff65gm1UjcITNNifw8uH7LSdkSPt9SxUELkgzkxCKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNnw8ljd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNnw8ljd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D19C113CC;
	Tue, 16 Apr 2024 01:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231154;
	bh=iKDjM+R4HFv8yCEGIGKmjxPlmerviUoh3weHYHX2SkE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lNnw8ljdjRgxxEuqdXkhWLltgSiv3jLD0HV/L02cQM+LEkyShTcScX7Zk/j4DFqP5
	 jss5ZdR3me8P2U9rhLzD8C7E1+W7kQZJi6p7Dp1IZeRbCaTuBs22qqnDo9V8CYIREU
	 LQqygRHBUazSI32XtU6E3N2byLdrxcACdUWGcu8ADmtixaumsqVXyma95gaTLIF67y
	 X4W/3AOYiDgZBIjnEe4y7tZoRLeHAQDGP9EJ/th+NMAN18mJhYQ09FwAOojf1HsK12
	 6noRr3v7UCuk7hLRI+kQApYbcBlSUK/vMFehgVtoGwDQFgMSWLENAtQBAkN9YECKFr
	 fXk+wq9D/SLBA==
Date: Mon, 15 Apr 2024 18:32:33 -0700
Subject: [PATCH 25/31] xfs: actually check the fsid of a handle
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323028194.251715.15160167066761168436.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Compare the fsid of a handle to m_fixedfsid so that we don't try to open
a handle from the wrong fs and get lucky if the ino/gen happen to match.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_handle.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index b9f4d9860682a..417e4a1f5e6cb 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -163,6 +163,7 @@ xfs_khandle_to_dentry(
 		.ino		= handle->ha_fid.fid_ino,
 		.gen		= handle->ha_fid.fid_gen,
 	};
+	struct xfs_mount	*mp = XFS_I(file_inode(file))->i_mount;
 
 	/*
 	 * Only allow handle opens under a directory.
@@ -170,6 +171,9 @@ xfs_khandle_to_dentry(
 	if (!S_ISDIR(file_inode(file)->i_mode))
 		return ERR_PTR(-ENOTDIR);
 
+	if (memcmp(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid)))
+		return ERR_PTR(-ESTALE);
+
 	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
 		return ERR_PTR(-EINVAL);
 

