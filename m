Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196C23C17
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298980; cv=none; b=QNcVzjmQPTFn6Y47KfYOTz72boawIQQ5vJ22hy3fvDbAIG4ZyBIBDeJB00nvWfSjSPhtaAg+1FoMtExmg6I+YsbDzhul0/TIKsKbJAH8+8bPTYCT8Pyaa4zQ8sD5QS16mTfdf4Q0gNDth08AQTQiU1AQPSluajuwltFDekvRbug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298980; c=relaxed/simple;
	bh=BFt/Lx5049mr0gIjreHS6l3PbVSWTG5r6GK+9tP/GBw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlYEehyFcacUQhEzICQpzZIWv5Zz0gnl1YAgF0Zff6/xAAOEHTGp7MwjEMcPORHnttpurzuU8hq3M8Hj465wZx/vwIQEOTpXq4QyDnb5HZG59ylPGyUPWjUPOH6ZPSOFaUTgWDJZb+cW6qHhh8KTyXPWUaa8CYdLxivDKAe4J+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tvl0QGNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tvl0QGNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA6DC32786;
	Tue, 30 Jul 2024 00:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298979;
	bh=BFt/Lx5049mr0gIjreHS6l3PbVSWTG5r6GK+9tP/GBw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tvl0QGNsp0g/Gk1bH4pyvMBOQEloJf8EneAoWq0cAF5Ga1fAOlp3DVlqM6CqIaPz/
	 fGvQJa+yc9EGRidploxgZjBLIKLIOEZQXee+J6P2U3t8zjBFD++Rm4x8Ur5I93CR0O
	 BeZAz5rZmGD5nr3i2K+aVWzf5jEZTK8K668acKGtGfP7zZP1kPT6XvOaPurXQNVSXo
	 hT4aoXdphtvoVKcObKSzPQ6ljcuLHPBNAewTMZO7TAg9kb7+/okrKO3rkIS1YeSm15
	 Da8iVCH9NmHaOea7a8IOUG9/SPx1rsfbW9svX6+VNmVBiSBqCc4FdJwG0bRd/slL58
	 j1nbeyVwtFC3g==
Date: Mon, 29 Jul 2024 17:22:59 -0700
Subject: [PATCH 2/5] repair: btree blocks are never on the RT subvolume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229841907.1338302.6256302271948089489.stgit@frogsfrogsfrogs>
In-Reply-To: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
References: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

scan_bmapbt tries to track btree blocks in the RT duplicate extent
AVL tree if the inode has the realtime flag set.  Given that the
RT subvolume is only ever used for file data this is incorrect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 338308ef8..8352b3ccf 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -390,22 +390,11 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 			break;
 		}
 		pthread_mutex_unlock(&ag_locks[agno].lock);
-	} else  {
-		/*
-		 * attribute fork for realtime files is in the regular
-		 * filesystem
-		 */
-		if (type != XR_INO_RTDATA || whichfork != XFS_DATA_FORK)  {
-			if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
-					XFS_FSB_TO_AGBNO(mp, bno),
-					XFS_FSB_TO_AGBNO(mp, bno) + 1))
-				return(1);
-		} else  {
-			xfs_rtxnum_t	ext = xfs_rtb_to_rtx(mp, bno);
-
-			if (search_rt_dup_extent(mp, ext))
-				return 1;
-		}
+	} else {
+		if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
+				XFS_FSB_TO_AGBNO(mp, bno),
+				XFS_FSB_TO_AGBNO(mp, bno) + 1))
+			return 1;
 	}
 	(*tot)++;
 	numrecs = be16_to_cpu(block->bb_numrecs);

