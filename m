Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269906;
	b=tCZwWEiAPTi1QMzaA8g6kFE/HoyMWnpZSpWfUQko0PbiMPL7amJOe5iQumcOgo+dBE/u
	 ZnZgN6rlHlDghFSEunXil1iK57ufLY7P1D+eQR5vrZOMzcfiWr+FjnXetq0wTiQqDTid5
	 AyR7B+vGy46c78ClQmaBRB2Fk2yq81MxJMPkGmNL1EEqMfv20EQ/nEFK9r0ADPGte/YIN
	 wSs40aSxQkwnNx4GRGmccS2t+kZk/i1vWTwSvgrSBpum3/DttXk75Kkd8um0E9+MmOraQ
	 6/35oGYc+m7+C1o9pHxQffylFdxV89j2SrEBDuX4Tx2A/84dPQxe+oc6IM8eVsXTFoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=fiY2sB1IOr2iySZqxjOngrbq3cfFmzx94xF8g0iDh98=;
	b=sCs2rBtIctabHwwlUqB1UVhwx84chnZQNwyB1yM6PJ5c9qRm2dAKJ0A83CWammvCIWMH
	 UgaPuZrvvQFq8Zglyulq9pWV24STs6ryepoIFF9a2T1rq7kAZQdiqN0H+mqrgHdFrW4+Q
	 SbiZNUuOv0llrcjY/1+A7bdvU14+WWho7zhv51fig9GuFBHbQCUbtBr5iHm2hRit4S063
	 ARl0oikjtvseb5S1HHQUDbuFl85ZublPe7YbMUQA7f50UbM2cZPxYDPIuEd4LzW7sZppf
	 V6KMKF1oYizKuFi4xMBugMVdOJeTyRrmcgrFw1j8WNcbyAKjY2GkeAVrloq9R3aPW2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKfdEqGQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31031606A326;
	Tue, 10 Nov 2026 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKfdEqGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE1B1F0089F;
	Tue, 10 Nov 2026 00:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269906;
	bh=fiY2sB1IOr2iySZqxjOngrbq3cfFmzx94xF8g0iDh98=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=JKfdEqGQO77jmdK2avRKNtgVrTEvb6eV19p9hpFKJoLBtwM+BocyGhpHo5qTsGbR/
	 R7isairPzA2sQs/U9V60ZDAnZ0c95mLwDj/ZREBJtA6D8IHNkK7KAnarCupVj+YrYV
	 ywz3yaeokPz41MXNo3reydDAlcueSVS+wjh65ictpdMUltx3MNad1+Gjs6W3u4kHuj
	 l9DStzv4wLUZVnv7rX0F6KwfGsZxSB+TP4AI0O+7YK6UJgU+cD+5YB0aCLdZShcb11
	 ou4yU7yGdqo2zWEj6zhxUcGU7fZxidiuRualO84y+CHTCL+8rtn5GV9VfkgSkYTHu5
	 a8pdOLuP+2PkA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: don't skip free extents in later batches of a whole-AG FITRIM" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:18:24 -0500
Message-ID: <20261110001824.3500405-1-sashal@kernel.org>
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

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-don-t-skip-free-extents-in-later-batches-of-a-wh.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 3d6528182f89f799a7ef2acc95fc7c1bf20a7835
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
index 6917de8321915..b866329c7a28d 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -166,6 +166,8 @@ struct xfs_trim_cur {
 	xfs_agblock_t	end;
 	xfs_extlen_t	minlen;
 	bool		by_bno;
+	/* restart point (with count) for the by-length walk */
+	xfs_agblock_t	restart_bno;
 };
 
 static int
@@ -209,14 +211,15 @@ xfs_trim_gather_extents(
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
@@ -246,9 +249,15 @@ xfs_trim_gather_extents(
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
@@ -351,6 +360,7 @@ xfs_trim_perag_extents(
 		.start		= start,
 		.end		= end,
 		.minlen		= minlen,
+		.restart_bno	= NULLAGBLOCK,
 	};
 	int			error = 0;
 
