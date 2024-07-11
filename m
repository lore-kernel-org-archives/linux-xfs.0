Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6337F77105
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 05:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720676671; cv=none; b=uvv4NF/Ae3Jai9CWINQkvA0yxqFiDQDJ6gvC16cGGz6FnpDPCvXvB09D6s8JQcgt7vlCPPsld7uwJ6PsyexCCcMnuCO6XzgUrwdTglLHT+AYc91M/iIAawTP0soG3myHMel8W/wSn145ihM224jHE+x7lDqy9/flXegT8GqsiOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720676671; c=relaxed/simple;
	bh=dpuwQPkZomslpqPDAcPF7BFr2gG81/LkCiXqf8FOlu4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JlBpnFy5W1Due1bqvhhN2GEWs6QCOgiUkrvapIy0jabf9AR0Lz3lPCK2Q6LPyuQ3IaOu+jKaqtLYue/IAL22RBDbCwSOyC72DsqbRzj/ncbnM6K4TKg9IZKaTlg7qnsCZA7jWPP2kZLsR15qYYZVtXwKtMX4wj/ZgYjQot4xhws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xjr67GAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xjr67GAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E051DC116B1;
	Thu, 11 Jul 2024 05:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720676670;
	bh=dpuwQPkZomslpqPDAcPF7BFr2gG81/LkCiXqf8FOlu4=;
	h=Date:From:To:Cc:Subject:From;
	b=Xjr67GAOKpxqm74g3KSiPH1UrZ9LHR2uQjMd/OmNlIGkkC0APyBp6vgEjAURfwr0/
	 mZGfHppVrvxKuaOaLigULDDet/nyCtt/FtR2ktfLFMNEjFmuRcaHeGhRCra3v/TvqT
	 U2w8Eha9nVrM0VoYhVJgtoiOPPG3IbX9bRolxSrPhBkliLdX3fuEZ/Von5o4qzwDUw
	 DSjE8nzYDS6e+DVIcQgS3V7AswfWv7+Nlgz6enfU2XggsvAtpmVUY+idWFUEt7G5px
	 57dszKT+eGp0ZjMk7hSLHQ5Cq/xy+IeM2aYdgYkVYzISXTCCATrVnBNcbH1bPsFtPe
	 KCAWAklAaNKnQ==
Date: Wed, 10 Jul 2024 22:44:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: validate inumber in xfs_iget
Message-ID: <20240711054430.GN612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Actually use the inumber validator to check the argument passed in here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9967334ea99f1..42a1d2e8cd56f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -754,7 +754,7 @@ xfs_iget(
 	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
 
 	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
 	XFS_STATS_INC(mp, xs_ig_attempts);
