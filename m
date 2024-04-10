Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6419623
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711147; cv=none; b=Dkpgz5xWaSy1PxAXoi7gvIsbJwD6pinpNc8FJ1Dd15gfsC7LttpeM3XaIaoq3S8nANt3YKQdFx1DH7IcfPpAqVUzyXcze8pL31v2wwoUsFmRcTccEM9znnk85J7CppzSoiPlZ/FlyPHuU2cVhqodX6b7f3JSuaQRjrSlrLENehU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711147; c=relaxed/simple;
	bh=vHaQt4LMY5bnqf41nnIGKg/9efolCVvl6rCTcDXyyys=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZM4SdKLSMUag0MAkBOIQs9G5FlVwtF1PazZjGJx+Y/0/ybCDBkRMla7vCeuW94ODqlaDxevpKY4fW65KsM68a8aO3y3eJJs5oSuhAk9spc9gXE7HnoLLOqbs/5nGnFxaHYctYRbG0BQoXsl5dyG3kVdtuPrATwR73R9DlVLJcFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3RqkmWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3RqkmWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0243C433F1;
	Wed, 10 Apr 2024 01:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711146;
	bh=vHaQt4LMY5bnqf41nnIGKg/9efolCVvl6rCTcDXyyys=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b3RqkmWzlhXjHntWC86fTVtOcrVtYP7z1Jj7nq4ppXPthMgGQpRC/ztf6TC78FtXE
	 RD1dVhLq3q9+EdvvWjXOoQlQiExG+27eKRcnLg381FEZpnLhdeQk9yJYN2/Pd5iHRN
	 f3DFnryzkpubQolgluuyyoUWtL1VAa75SPACq350k048S124HTzDaAwpT1jxi+QRnT
	 Vh05JhnFIxMfcKEzc8GLJNehJG2vGDhUbn1ONvhQnkP+KRwnkic5DzegTdoQt70+iY
	 V1766fdd2XPPRs/yqi1nioRVFK3e1nFWhdWx6eJC952EN9z9jw6zjvppk4MK9Tbva2
	 2dKiOI23ZRhKg==
Date: Tue, 09 Apr 2024 18:05:46 -0700
Subject: [PATCH 08/14] xfs: remove pointless unlocked assertion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971120.3632937.11416985248213244019.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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

Remove this assertion about the inode not having an attr fork from
xfs_bmap_add_attrfork because the function handles that case just fine.
Weirder still, the function actually /requires/ the caller not to hold
the ILOCK, which means that its accesses are not stabilized.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 59b8b9dc29ccf..55a64a72771f2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1041,8 +1041,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

