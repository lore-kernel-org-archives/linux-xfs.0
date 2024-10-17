Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9792C1E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192000; cv=none; b=oePNKXFWbMBd9sBt4YFBER8sGEV7PhYKjRTauy9nOIYFX+w6gPvM/ybXgqia+Yn7zUUDY8vgHd+iUKMdoTwrNF+M5c7wzLz3JelJjr/5ebVWwFlq9/Bfd8K8h0UlBQMW74WnIMKH7Ag5Sc5sIOijyqWLaSWZ1039c5qCD4EnKNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192000; c=relaxed/simple;
	bh=oOiTGul6Y6dOHkU4GThTSMMYzYDjg7eqnFtTJkIedxw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YgI2g74KRxj6qovbUXvhHN8VO2UsR0APA4NCkkFDfGlkpRJzYR+nNz1C1k2u4Al1t9TL1OC2WsHB1gXLp55ZHNPiZruOVXfsGVutpsfgoeWp6ab1dJOte4tYACmACt/H5t1OYOLQrJ+LucfMOzGaLsoqN9DdNkwARDQrj4JYYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huQ3OMY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huQ3OMY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709C5C4CEC3;
	Thu, 17 Oct 2024 19:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192000;
	bh=oOiTGul6Y6dOHkU4GThTSMMYzYDjg7eqnFtTJkIedxw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=huQ3OMY8ssfmIZtKzgq4PVWcyKOUZWMcmzyX71kupb7ptyv62hoiJWvawppVn3tz0
	 W62RjXSmL7nXQRpZSTHw15zCXZg2ZoFlIDOejDTjWs76Q58Rse9keiyyKnBleTnkLY
	 P7svpAXnH8YEsAPkEfSeDZ3W3Eknf9fHTukp9fM2k0ga2gTc1aBZyKSmek7yztRKw0
	 sChMfcHnYPzSOlUi8Yoj+inDIUwK4nHVdTj9Co/swDLdM2XvW4INGsDFo8Ob4pbVbg
	 gDgJ225TryiJp5ZZUQxbn5uxNWSmqmJCPQyKRfk9MyJao5wdoNPTd5ZjRU56rPasTm
	 Q4aluWSUPp/xQ==
Date: Thu, 17 Oct 2024 12:06:40 -0700
Subject: [PATCH 16/34] xfs: force swapext to a realtime file to use the file
 content exchange ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071944.3453179.16121771276824167770.stgit@frogsfrogsfrogs>
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

xfs_swap_extent_rmap does not use log items to track the overall
progress of an attempt to swap the extent mappings between two files.
If the system crashes in the middle of swapping a partially written
realtime extent, the mapping will be left in an inconsistent state
wherein a file can point to multiple extents on the rt volume.

The new file range exchange functionality handles this correctly, so all
callers must upgrade to that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9d654664a00dbd..aa745cc5922246 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1528,6 +1528,18 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
+	/*
+	 * The rmapbt implementation is unable to resume a swapext operation
+	 * after a crash if the allocation unit size is larger than a block.
+	 * This (deprecated) interface will not be upgraded to handle this
+	 * situation.  Defragmentation must be performed with the commit range
+	 * ioctl.
+	 */
+	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(ip->i_mount)) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		goto out_unlock;

