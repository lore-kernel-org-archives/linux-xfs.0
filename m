Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400DCA21
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371596; cv=none; b=HpeAfgKjoST31ZP121/mL5gOx5yJLiE6Ev8SjG0I+BRVNkYeUWMMf1QmKx9Pcn68mvCEMlKDgNlKUA3B0qz/hAv8OaduP+jD+AOiCM3JyQD8TKLwwoB5jyFWIALciU9nplyiQy3gSlwTPpB26XWOC/DSqnKFfejoYS10GM0dX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371596; c=relaxed/simple;
	bh=xzR5Zdzw+FuqRtoKZvAgyvYPzQN0/IRJ4YGJTZpqpsw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqum+yezgVbFC4cFgHgrQoJ7W3xk7cD1Q6C5K+mNo2tAFOMPsaDBZTrsOvXvvzD67JS5HErpJgdyQn8iaSUgzQVSNDIDhXZChs1TQyWecIJ3iRW7LKTggaA7LqMPYngAtwI5kzXGCltOdyNdy24+bXzEThTdfvmVnZRueXfy434=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McQDbHoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McQDbHoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9E1C32782;
	Fri, 23 Aug 2024 00:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371595;
	bh=xzR5Zdzw+FuqRtoKZvAgyvYPzQN0/IRJ4YGJTZpqpsw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=McQDbHoHhNZkTFcfTtEVF9egGZ1pD3ej1E/+o5twCSBQydt3HpYOnEttWSp9ssXMi
	 gaONJPRb0s8WwNPDS1F9kV7yrCeXFJfxnYZUQ70qApbefD7LTSaQv7ENcGHlIt4VT6
	 3AKVPKTlw9KsHEfFvtm5kCotUnui3V/CEdffj81yN1WAqe778OIKUcIpk9ZS8kJVZM
	 8AVk7ilsW5gcNhI1hIj52zh6+zXDnp4gwKLXIarlj+7o0kLEnS5Z1dJV5YRRGbdzKV
	 Sq98ZZKV/FlxAOlB9dj/MVli3OI5WSqBKPR6lQjEPXdSd7pJMofxryFo9oKfgfIfa3
	 qYLJ89FxjX5HA==
Date: Thu, 22 Aug 2024 17:06:35 -0700
Subject: [PATCH 17/26] xfs: don't fail repairs on metadata files with no attr
 fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085468.57482.3631281958745114225.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Fix a minor bug where we fail repairs on metadata files that do not have
attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.

Fixes: 5a8e07e799721 ("xfs: repair the inode core and forks of a metadata inode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 67478294f11ae..155bbaaa496e4 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1084,9 +1084,11 @@ xrep_metadata_inode_forks(
 		return error;
 
 	/* Make sure the attr fork looks ok before we delete it. */
-	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
-	if (error)
-		return error;
+	if (xfs_inode_hasattr(sc->ip)) {
+		error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+		if (error)
+			return error;
+	}
 
 	/* Clear the reflink flag since metadata never shares. */
 	if (xfs_is_reflink_inode(sc->ip)) {

