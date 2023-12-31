Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE93C154
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbgKWZiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCC8C433C7;
	Sun, 31 Dec 2023 23:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064501;
	bh=S3QoYizRg2Ne+OOUHrXXCEzznFSLjhMQE52aBk6E3sA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AbgKWZiFVhjDa/bWAP3Q3dzPbJ2IidEwLJApnCfQCsn3v6iMB0svhiQHvuifsakv2
	 qtsU+hEm11fL95tXB0miOYQkPmPy/+S6n4cANb18wD2VbCS2pvEVxo+G9J21bWNELf
	 9uPpDPfDa0BAi5XcCbt347D/C1uWZYsOKyehiwZQSYWJR1b7Eg4Ff5CoAE6QTiQiUJ
	 RbPhncJi4U/dOb0JokKTETS4IW81peOt2vV7jc9H7ztbGmpNP3qDe97XS4z5CXd7hu
	 ZaCwahtASkTcOT/nOqxtmcAW7SDYyxikxLF8rfTrtopg5gx7cmE/KvxiCT2cC9nlhA
	 axh6Lo4sla9JQ==
Date: Sun, 31 Dec 2023 15:15:00 -0800
Subject: [PATCH 06/18] xfs: remove pointless unlocked assertion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006942.1805510.18077720532726803815.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c6f2f4ace53..f16e4369306 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1017,8 +1017,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

