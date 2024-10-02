Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B714400
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831521; cv=none; b=qIQ/ZYsleESOPUaEEW6QgDM0m6U8UHfM+ugzIS6mzb3GAINcZ5BEvsoiZCVX5XCMpX1XUIQHVdlyKbi3pomtHQe8U+8Y9p40Pd1KRtSTZeDsZU1OgWUlJv9757N9s0waEAsuXAxlEd/VAQC+lEq6jYZAvgRU4iPtIWs0zOp+MLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831521; c=relaxed/simple;
	bh=YbSImtedkp+OGC5XAMS/Pv+k/LMgdtbNpFErTQD1etg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCACuq3052fybPpCTthDVzvIqZCLn26a15NvoMZYJ6qoQJrwCYefd1NuogSsPDpOQaA8ZrXk/QnDOnqPVxnc1lMgu4r6frXmOBkQJOuolDaEs2FZ0+IqRF3gK2GqwlbX97b8Qb8NMgmH+skepZDTQdSkQ4OGVi7NbYkXa28VVRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXH0l09H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXH0l09H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4906C4CEC6;
	Wed,  2 Oct 2024 01:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831520;
	bh=YbSImtedkp+OGC5XAMS/Pv+k/LMgdtbNpFErTQD1etg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sXH0l09H222AFdYav0rvs7pqi7RYAOb8YARHOZJys/QmPoMVA+YGGK5NlicvjZVvM
	 O2OF/wTv3WxqFi9SzUYG9jsdvWbDmT5+2ozYKAhPI/yKcv+VbywACokbmgVzQFI3n6
	 0F0kiOwJ5PwCHDPT2PWxcMCamRDdzZy1MMrX7brzJd3XNI2w0yfhi9d5dS5DmhyAtQ
	 cfyDBm+so1c5333sPVp/a9jDIAXAX9wlnk71IlY9PrtenGikfnH41lcCAA/xrbJbLM
	 30Xi42K7TR8FILYWdNjkAYvhkwH+n3V3h2kWEoLDmZQJyuGggMEepxuQgdOuvZRoT0
	 pOAKEq5oRW06A==
Date: Tue, 01 Oct 2024 18:12:00 -0700
Subject: [PATCH 16/64] xfs: split new inode creation into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102022.4036371.17986883848922355216.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 38fd3d6a956f1b104f11cd6eee116c54bfe458c4

There are two parts to initializing a newly allocated inode: setting up
the incore structures, and initializing the new inode core based on the
parent inode and the current user's environment.  The initialization
code is not specific to the kernel, so we would like to share that with
userspace by hoisting it to libxfs.  Therefore, split xfs_icreate into
separate functions to prepare for the next few patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ialloc.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index d8697561e..cef2819aa 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1941,6 +1941,21 @@ xfs_dialloc(
 		}
 		return -ENOSPC;
 	}
+
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if (ino == parent || !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
+		return -EFSCORRUPTED;
+	}
+
 	*new_ino = ino;
 	return 0;
 }

