Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00823C126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRzaIIgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E951C433C7;
	Sun, 31 Dec 2023 22:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060013;
	bh=7vxVa9Tni5OPY8V3oH0AqHJ+qD4HROClKiCeCi8NBDc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DRzaIIgQh2SxhgAt4W2VDA4qSvINpNfS8530TeJIDb3gy/YFMZ5utcPOB9YcsE0OJ
	 W+D7P4Rl9rGuDPX4CAd2d7Ut0h1JrqE8DDQXw8mT4rcPWk4B8dEX3ILsCOX1zZXfHV
	 W5q/I5CxxheQv/jHVPkrbt8oMDhBeZpO+Zlf2ZBURj39UVOx2M0VWTj017CwzfrPQD
	 qcwyKvxznlCy1flSJNOcD+MsULyPERW6L2ug+sMBlQe8MLhKXgahhLaXcQEDUnuN6n
	 xaTZ1vjiah/7XERIWQKBUl8eT54VUgPsn5sQ6lOHIJcYLV/scFZN0vIFWtWDfbhDRO
	 PGttea9izggJA==
Date: Sun, 31 Dec 2023 14:00:12 -0800
Subject: [PATCH 1/3] xfs: only free posteof blocks on first close
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404854342.1769544.1524332572634769354.stgit@frogsfrogsfrogs>
In-Reply-To: <170404854320.1769544.582901935144092640.stgit@frogsfrogsfrogs>
References: <170404854320.1769544.582901935144092640.stgit@frogsfrogsfrogs>
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

Certain workloads fragment files on XFS very badly, such as a software
package that creates a number of threads, each of which repeatedly run
the sequence: open a file, perform a synchronous write, and close the
file, which defeats the speculative preallocation mechanism.  We work
around this problem by only deleting posteof blocks the /first/ time a
file is closed to preserve the behavior that unpacking a tarball lays
out files one after the other with no gaps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 334f87f7a8f3f..dc0710661013f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1207,9 +1207,7 @@ xfs_release(
 		if (error)
 			goto out_unlock;
 
-		/* delalloc blocks after truncation means it really is dirty */
-		if (ip->i_delayed_blks)
-			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
+		xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
 	}
 
 out_unlock:

