Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FBE171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390347; cv=none; b=aHdivXfNuwPYAJawAhXksMDnVFY25EIJSkXn5R+7itSNEuLI6p1P+EJcqDW7ZsoVbSJsTr1GkbPt/ZQlIAy8ewQIIoTvdsrzIkjQhhpJ+mKz+MXMofpqLGKXA38vN7ZTccDERU9bqsPrL/wu7RI6m9SWN4Opagd8fm1Q66AmJho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390347; c=relaxed/simple;
	bh=zAqHk8rp5caktCKS/cBKpDt+8LKlzgeud/DnJkv/ls8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgueA9Ljzg3vv7ddFiA2JswjLiACfGago4U4dwfIopHW0bT8Gv7uqN7LpXMDiNYyvy0NmhAcvUrliXPw7awsO+ld2job7e0Ot3NeLE1acLpb3+pv1jmaL3w+5k1JCrm0p18418X96HusJ7d6VE+Ohc57gUL2OolERy8S5fDv16I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3AaVEUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3AaVEUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D665C072AA;
	Wed, 17 Apr 2024 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390347;
	bh=zAqHk8rp5caktCKS/cBKpDt+8LKlzgeud/DnJkv/ls8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K3AaVEUU1mt4RJt6yg5O05uaZN4uZ5qIuiXTks0kE52ayIwLfQNNn721w2a0kxw6A
	 FetWpq183Pam8uFTuukd+x2DCtyxgwr7+HGO/RziKFWtb3bXE3p1MjFvRUINMrU0+b
	 KYOMvGCCyiC8hZqHDym1e/3+VpEHvn5dYV6OMJ4Bs8+Gh6xWpyt8nNCP+hsUzZJ8Ox
	 1Q0jsf0qkNkCTVTNsC7O1NZ3xHwNe0drW4qpTExHNP5VdwVCdoEpdVSp8O1gLmyXnI
	 tcyYtVegCxtAvLwIfK230DkU9R7dg2EXrLs982Dy0XoO5pfM75nlC/UWBikoLamZTM
	 NJr3i+LqlXMgQ==
Date: Wed, 17 Apr 2024 14:45:47 -0700
Subject: [PATCH 5/8] xfs_repair: clean up lock resources
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171338845855.1856674.16300821271746079157.stgit@frogsfrogsfrogs>
In-Reply-To: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
References: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@djwong.org>

When we free all the incore block mapping data, be sure to free the
locks too.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/incore.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/repair/incore.c b/repair/incore.c
index 2ed37a105..06edaf0d6 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -301,8 +301,17 @@ free_bmaps(xfs_mount_t *mp)
 {
 	xfs_agnumber_t i;
 
+	pthread_mutex_destroy(&rt_lock.lock);
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		pthread_mutex_destroy(&ag_locks[i].lock);
+
+	free(ag_locks);
+	ag_locks = NULL;
+
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		btree_destroy(ag_bmap[i]);
+
 	free(ag_bmap);
 	ag_bmap = NULL;
 

