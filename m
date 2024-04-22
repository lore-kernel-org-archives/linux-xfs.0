Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130F153BCB
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803977; cv=none; b=QdK5X58elYVgbv0FTNwZF7USqsax66I6q5J7jNNK8fd0Yj6V24ZwE2WHkj/azcOoPXv/YrbH+9is8gnEjQPPDs98DA8A3pyqvENeLn/nw0sfiM6Q9Y+oQMijc6d2UXHMAYR+o3xLKgo2UVQ7tbKaEsHCwO+XUSNhscRtsSFGi8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803977; c=relaxed/simple;
	bh=tTLhgomp+cvU7nPjmB+nSWUkBZoU/ebAt/EiPk7bqHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNhNn6OFmr5B/n8QDqYGQ8eI6r3z4AiOmIiOcjihEluIV26EASLi96jdGeJgWjSxaePUsvTuCI7WtiGadZo8HgCIViGzDlTGP9mFxxk0dvNZEvN9ms5i3+s81iB/LNnrMUGRpwB64V4aekV+0VrjEduVKtMRWmpxTkNCuwJlUGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=foX8HSNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="foX8HSNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9F5C113CC;
	Mon, 22 Apr 2024 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803976;
	bh=tTLhgomp+cvU7nPjmB+nSWUkBZoU/ebAt/EiPk7bqHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foX8HSNiFUFYJsfFAFa0QFCMfEwSebCg2CibS+9B5nSMDSiJyPDuobo1X6sU8PyWo
	 Ux2MjFPMFIYpm98m+ltjthjKipvqDmC9FV+ja3puSS6Sdoz1hOOuvetJ9vNbiJndwo
	 Mcl5fd4TEVgV0Jqo6mGsnomJXYBK1eSS7+GVSVmxk2NBDk4vrZgCUTVDFVHNyRr6JB
	 Q+HRTygGbYH40VsBXDu9AYXEz4mHGtLWfY+trUzfrFJRnuUQvfGHx8PiDqwWy9HZjL
	 Zf/lUICltolJ/L912hUBy2kacw7j+URpFo+uuZuAv+UQS+FVgv0oizHIUONapN91MW
	 dagWHMtF62C4g==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 19/67] xfs: remove unused fields from struct xbtree_ifakeroot
Date: Mon, 22 Apr 2024 18:25:41 +0200
Message-ID: <20240422163832.858420-21-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 4c8ecd1cfdd01fb727121035014d9f654a30bdf2

Remove these unused fields since nobody uses them.  They should have
been removed years ago in a different cleanup series from Christoph
Hellwig.

Fixes: daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
Fixes: f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_staging.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index f0d297605..5f638f711 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -37,12 +37,6 @@ struct xbtree_ifakeroot {
 
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
-
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */
-- 
2.44.0

