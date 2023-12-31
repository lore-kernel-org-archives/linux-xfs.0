Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455ACC126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8Vw1NRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B825CC433C8;
	Sun, 31 Dec 2023 22:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060044;
	bh=WMnAF7dnXvS/pRgYhQQ8L3bL07qlCIMAz+0DYIcT4Yg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T8Vw1NRApxMtDWwDMdkEyKPtuh/g/JKKSlVZiyHooowu2A7TINvgKblD2ayflUofx
	 aRtME7gkB+fb65UCm0B7DEJ8TkD7PMAlV7HmFZySUvXqBP43WScekW9s+pCuCKjv2g
	 zlEY2EB7ONGK5+Lht9tgdV8AHiVZRc5r9bZ/MbRAJpExaZh4LDBclPZTg16LK8ba+i
	 7HTLne0KPq6TtGc+o+TOT9e6X5tIb5ByUyP9exEobskqlCoc/xqbOr5Q3zgVjDAqim
	 wYsKiNegv0ovp1a9xj24ZAz+u0Nyqzv/iJnCKduEXIFxPCMMdW7nJYWDqHfV26yR7c
	 uIs6b5S9YucNA==
Date: Sun, 31 Dec 2023 14:00:44 -0800
Subject: [PATCH 3/3] xfs: Don't free EOF blocks on close when extent size
 hints are set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170404854374.1769544.16112994193598836189.stgit@frogsfrogsfrogs>
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

From: Dave Chinner <david@fromorbit.com>

When we have a workload that does open/write/close on files with
extent size hints set in parallel with other allocation, the file
becomes rapidly fragmented. This is due to close() calling
xfs_release() and removing the preallocated extent beyond EOF.  This
occurs for both buffered and direct writes that append to files with
extent size hints.

The existing open/write/close hueristic in xfs_release() does not
catch this as writes to files using extent size hints do not use
delayed allocation and hence do not leave delayed allocation blocks
allocated on the inode that can be detected in xfs_release(). Hence
XFS_IDIRTY_RELEASE never gets set.

In xfs_file_release(), we can tell whether the inode has extent size
hints set and skip EOF block truncation. We add this check to
xfs_can_free_eofblocks() so that we treat the post-EOF preallocated
extent like intentional preallocation and so are persistent unless
directly removed by userspace.

Before:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 1002
/mnt/scratch/file.1: 1002
/mnt/scratch/file.2: 1002
/mnt/scratch/file.3: 1002
/mnt/scratch/file.4: 1002
/mnt/scratch/file.5: 1002
/mnt/scratch/file.6: 1002
/mnt/scratch/file.7: 1002

After:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 4
/mnt/scratch/file.1: 4
/mnt/scratch/file.2: 4
/mnt/scratch/file.3: 4
/mnt/scratch/file.4: 4
/mnt/scratch/file.5: 4
/mnt/scratch/file.6: 4
/mnt/scratch/file.7: 4

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 60992f8e86adf..a3b987fafcce6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -710,12 +710,15 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Do not free extent size hints, real preallocated or append-only files
+	 * unless the file has delalloc blocks and we are forced to remove
+	 * them.
 	 */
-	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+	if (xfs_get_extsz_hint(ip) ||
+	    (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))) {
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
+	}
 
 	/*
 	 * Do not try to free post-EOF blocks if EOF is beyond the end of the

