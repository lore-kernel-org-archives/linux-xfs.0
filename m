Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D7439099C
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022547; cv=none; b=on/cUSQlgNQ4gQ0SHkX6YkdmeeRMVr6gtDAFUuCLsUN9tSnmlJjB1PtbmGCONszPHLyYqw58g+ogbT851SWZpfO028szstMPxb5ocJelgroZDoWZ+y2aWjZKxA6k0dpKk5HUgUWazRtrAU1qFIHesjSISjds7AuWmBWJaNqSVAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022547; c=relaxed/simple;
	bh=rlRHYqYaq7M6X4RfId3QuqrupIT4rApoN7P6eQ3C9UA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzWwqchUezNK7t6Ww6EqFXdkSAPc30eBbPrEXOG3iRI07S1z4bgWhZyN9ZceFgII0A/mw19GlfFfaHBfxNydpsArKRqCR/1P2KwSAihk+h+WnXMvJkxVIXybgN9QPDpBrONFt62jRvZ7ABMEXvb/fInDCy54+TxlRmkPJpdXEns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1nZfTzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1nZfTzK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0D4BF1F000E9;
	Thu,  2 Jul 2026 20:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022546;
	bh=CI9SWPvdiJ4wmuEJehpx+nIBi6BzBC6EiB6jeBPIIsE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=d1nZfTzKcWoBpxEg7B+kcYk70yJ+iTc305lQ043MHB+Nh8plOZOckzi3+/JMFHni8
	 4uuao0/72fnfcEQjBr8DoDIAPl+mN3c0ksczrA4/k99rQ3FKgiX+tLZgiAEW3In1wq
	 Jo8fTYNgoujNKElrH68WtJyX/PbOhn6klsh2YWeHmfBwWnVJHU7ZTpbrDO9rhJLJsj
	 5qm+seyoY8kfZgviNEZEpXoSTN4UQIZfOMBasZ45qn6SkLAEk5kSn+8V4aT+HKy0uz
	 9ihYxkJFWXZtfmSbLAZ8b9yYcEcsNfRKP+55iok5O/7S8n3LIZVggTenWYX5SaAfRa
	 P/zZamt69gNCQ==
Date: Thu, 02 Jul 2026 13:02:25 -0700
Subject: [PATCH 08/18] xfs: add a xfs_rmap_inode_owner helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226450.845537.1339067967860341629.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f882fc7dd9f04f73d94379deb9e68d8db613c976

Add a small wrapper for initializing the rmap owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rmap.h |    2 ++
 libxfs/xfs_bmap.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 7188459f61cf3e..6016fd5fcad98f 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -37,6 +37,8 @@ xfs_rmap_ino_owner(
 	if (whichfork == XFS_ATTR_FORK)
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
+#define xfs_rmap_inode_owner(oi, ip, whichfork, offset) \
+	xfs_rmap_ino_owner(oi, (ip)->i_ino, whichfork, offset)
 
 static inline bool
 xfs_rmap_should_skip_owner_update(
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1bd65a0cba2629..23cc5bb4627288 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -813,7 +813,7 @@ xfs_bmap_local_to_extents(
 	args.mp = ip->i_mount;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
+	xfs_rmap_inode_owner(&args.oinfo, ip, whichfork, 0);
 
 	/*
 	 * Allocate a block.  We know we need only one, since the

