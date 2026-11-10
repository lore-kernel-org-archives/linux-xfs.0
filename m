Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270520;
	b=fBYQS8ZpolMLpR93UHjJvhLgiTrIB7qNsCvWaFIXYKFZrfELovghMRrnv319xHZeWSUk
	 xzXC/gkX1wtBrl0IdMJtPaX/EK2p0vYR+CAV3QFxzDI1OAbz0WX7zDPyg5jCuiurwdpVL
	 IelxRkP4wdQoMvQwyyb6vhI0nbo1JSriqaVsv0mwdaYK/M+KjCGRyv1CIi4P78KfoCwLI
	 qUfnuj70OIcXKQ23XK/25CJJP7APhf9FO05JrttqQjAdjNHyBqNco+NkRYtRiLWwLSJR1
	 3SUk0d11j36asUKDVl+3Hof/uEBEqcf0wQevfOoLeh41D7sEQQZE198FE/YBq1uQsjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=cbWhCw4MSbEj7fbH8aVJEoHPZVzgRitxkQhCHI24H9U=;
	b=SxV40CGOjLYp7LtsIcY1lQilZHy67bmLcmmzTPb3Bd/abXdoj08RBBza4tH+ks3t++0b
	 /mD/LeMVyXbtNa+K/9cnuV1TcFt81GKV8RkBgTNuxX+66E0SCWkts4F8v4767vC8bCTET
	 1uHGecRu2u9RpP1XKNEzuJ3x04FG4u7zcpSex62iQ2cGkotqAyfGjP8AMXuL3SdkwJbVi
	 usFxc3Ytz7UpCJTiEtdRW5vMU4Cb7fqY2IYdFieT+qNJLdsZ5p4BFZtrA+hK+6dpe9oip
	 sVh+LGLC2E4WZ0jw9YiLcn/8xeolMQLdZzXFpITGv8VrvKnb8sTKdlRSL/8BFL6TUXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OL9bZlLJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A652606A31C;
	Tue, 10 Nov 2026 00:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OL9bZlLJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85E81F0089F;
	Tue, 10 Nov 2026 00:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270520;
	bh=cbWhCw4MSbEj7fbH8aVJEoHPZVzgRitxkQhCHI24H9U=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=OL9bZlLJAFjmPszaRBBWcd4kxRKG5UipqdvlMsuy6B7eaXWu95Hr+dLPPNG0CUWYD
	 buEsUTKsMunKWN9xIszW/BnzGhzJGJLWcuCPWaFcgRvpADN3H7OFwE9cltBnNwSJOF
	 yzKUhLi1kPKEs/rpZlukrWh1dcMqlPF7dGo48MDNW0lRxi0PY5qPx+okD7oUZoF3EQ
	 XpYEQT/X2Xogvo0um0Ts5Z3UL6y/TyoBGSJm1Z11hKxuvjA91I2FIowgvKGIMRjBBQ
	 BYQBuD09lIyDIOVVvV8/SSNVO2mV5mrLQKElzOy7RDZ/j8ockQfWUgGfZIlsPychNU
	 69ZimkYy3zFiA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: don't skip free extents in later batches of a whole-AG FITRIM" has been added to the 6.12-stable tree
Date: Mon,  9 Nov 2026 19:28:38 -0500
Message-ID: <20261110002838.3514608-1-sashal@kernel.org>
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

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-don-t-skip-free-extents-in-later-batches-of-a-wh.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit cbf1a0a054e5241dba78a8b69911a0928a5abdad
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
index 0b343776da8c3..9ad0d653f266b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -160,6 +160,8 @@ struct xfs_trim_cur {
 	xfs_agblock_t	end;
 	xfs_extlen_t	minlen;
 	bool		by_bno;
+	/* restart point (with count) for the by-length walk */
+	xfs_agblock_t	restart_bno;
 };
 
 static int
@@ -205,14 +207,15 @@ xfs_trim_gather_extents(
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
@@ -242,9 +245,15 @@ xfs_trim_gather_extents(
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
@@ -347,6 +356,7 @@ xfs_trim_perag_extents(
 		.start		= start,
 		.end		= end,
 		.minlen		= minlen,
+		.restart_bno	= NULLAGBLOCK,
 	};
 	int			error = 0;
 
