Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269089;
	b=UVFLjNivcvT8R7Q6u63HBgzWwPkxvFwvrmipFLceWFX2qNnmH/WsBhe6oh/mO3T+tQBm
	 OTEqGWwxr7ZVM8YDltx/MKrMV02+uiTWvfWQHwpLz+NZrEpPJz+PHavHTA+/JOc9bX+8K
	 1CGr0KacuCKaXxEjt72zpk0PIRYinuRhelF/cu/96/FawvT9NqMhkowE/rZMfJ4PF5ecz
	 RNQUYYO0VA6UVgX2D2izsgX4dSmS94yNzJ4ynK+plWNr5tZlhGi3HQdGg51ghZvE3HH0I
	 P0iucZMMTK5ryYQKPyUFcvE5QHOeBjxFMyWdIVP/1hPf9nwXWcPXvJROxNycrp6DaVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=cqOWRrXU376torPTkOYcHiJyXHp86pQQj2Hzf0MqcnQ=;
	b=H8eJXkOGQvZVEcs10h2gBLvZVym0ruGrv1FBqU7MAsBT4CpMUxjQPMp3A8aOfRrrQx5s
	 nFkD+G7yRvmOOApMmjtZOvgLQ8j+vnoMW9rAmSaFN+3U3LxbvvANfX6uVODFRcvxz6AAN
	 EOSIoHK672BbNK7t4qJa7+q71F7gFwx1ivifwP5zwTUNJwEKUYMzHCbzAC+bY+JvifGyd
	 ZTg082ygWsfL7jODJXeaC957ceqcCnE8HpPwkTMd7/ZHvV8nzcT+XcncIJToNgtEFEFUS
	 SvVkhXFtSVnOG2t92ysRIllOt4YszMlTTf2vBK+h1pkuqCJl5WJMXYQO4gqhSJj1kmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dhBl7csw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34DA606A325;
	Tue, 10 Nov 2026 00:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dhBl7csw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFE11F0089F;
	Tue, 10 Nov 2026 00:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269088;
	bh=cqOWRrXU376torPTkOYcHiJyXHp86pQQj2Hzf0MqcnQ=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=dhBl7cswycNc37tP8PpCpGsIyE1B2vUpgCxOhJ1o3VslEPxE8T1q3BT1qrmt41RrH
	 XFCW39KpNAPQkn1ZTrQqoX8bhZ+EyMSyiLDJaMvZ7nGgYLYGvh3fwib1t/x089f+38
	 z3rrz64utwN80ez7q1n3xnZ+fg/ug6pwWPbOViCS4nkLM7UwyJOGLbVzvtHFXARPai
	 NIumCvxH3cWhWRstyWica45RdweXffW9XOtgVeRqEyuoo2FtjYsu74cD19LbL9Gty5
	 3g+HmRhNIQg8Q7TBGEOg3UWU6I5FjK0oTJ3JFvAAkCsGfIYFdLrZlxDOGSEJrMu/id
	 L2sfqCqpEmDjg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: don't skip free extents in later batches of a whole-AG FITRIM" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:04:46 -0500
Message-ID: <20261110000446.3482030-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: don't skip free extents in later batches of a whole-AG FITRIM

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-don-t-skip-free-extents-in-later-batches-of-a-wh.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 99644ccad84bf44a5bd697d1029fd69558daabac
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Mon Oct 26 10:54:05 2026 +0900

    xfs: don't skip free extents in later batches of a whole-AG FITRIM
    
    [ Upstream commit 595e67d7261673d03c96950ffbb2e545c00376ed ]
    
    A whole-device FITRIM walks every AG but the last by length, in
    batches. xfs_trim_gather_extents() saves the record to restart from in
    tcur->start. But tcur->start is also the start of the range to trim.
    Later batches therefore never discard the free extents below that
    block.
    
    Save the restart record in a new restart_bno field.
    
    Cc: stable@vger.kernel.org # v6.10
    Fixes: b0ffe661fab4 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 906221ffe9ba8..8120f136af931 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -155,6 +155,8 @@ struct xfs_trim_cur {
 	xfs_agblock_t	end;
 	xfs_extlen_t	minlen;
 	bool		by_bno;
+	/* restart point (with count) for the by-length walk */
+	xfs_agblock_t	restart_bno;
 };
 
 static int
@@ -198,14 +200,15 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->start == 0) {
+	} else if (tcur->restart_bno == NULLAGBLOCK) {
 		/* first time through a by-len starts with max length */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
 		/* nth time through a by-len starts where we left off */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
+		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
+					    tcur->count, &i);
 	}
 	if (error)
 		goto out_del_cursor;
@@ -235,9 +238,15 @@ xfs_trim_gather_extents(
 		if (--batch <= 0) {
 			/*
 			 * Update the cursor to point at this extent so we
-			 * restart the next batch from this extent.
+			 * restart the next batch from this extent. The
+			 * by-length walk does not visit extents in block
+			 * order, so it must keep the start of the range and
+			 * restart from restart_bno instead.
 			 */
-			tcur->start = fbno;
+			if (tcur->by_bno)
+				tcur->start = fbno;
+			else
+				tcur->restart_bno = fbno;
 			tcur->count = flen;
 			break;
 		}
@@ -340,6 +349,7 @@ xfs_trim_perag_extents(
 		.start		= start,
 		.end		= end,
 		.minlen		= minlen,
+		.restart_bno	= NULLAGBLOCK,
 	};
 	int			error = 0;
 
