Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269091;
	b=R+P0lCqCNuYZ4X/qGBibbh3v0Xc5uv6pMqd6AG81giTVff0sb5Oub1M8l+hxpVtzY2/6
	 /4s7Kxhx9nxsODY8P4Ax66H0FZ1CnHswX7vwZ797egrvIDZV6R1hCZK1/u0DzfPPmP0mQ
	 AyCQF8mFqYktdOhpNPdNxJUrCgDIujvklAvL0QLuzK3eFOX6Y/kG+/tQGkvCNaTE9b8HH
	 KTgZ7PocM6bI6ZFUiiv/jmPujNVbVcU8anOpj1LwsYvejWa8zo2JNKV2k9w8cheL/6aBR
	 lmIrMQvENLBch4ImgeAut3G4tnSjAQbEyOPExSzhvpnqqJsApKfJjYQtEil6H4Gc0Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=CZ7vuem9HsYeIcJa3YdOJQU6PgXlPc2dtCa17qxXdBQ=;
	b=VZIQec3zA0lAdtG/bOcucIapB3wMSaNqdzgDR80FrqOjQOXGeVw9WLGs3qyE3oeUCPcR
	 wY7EodK0KHuyYK1x6DgeNZ1ISnKtQzPSbGh9WharPd9R306ZOJrC2EkZLJmjf2kODZ46f
	 H81efJaaRDA10pXn7iKivqVTCnJCLr36p6xpHJroXoikxNFoBgO4tLUvDzruntjwgjAlq
	 zhKkz/mIfaDTeuMz/OsbUF1G/j2sAKyq7klSbMWHyl7K3lZ4XdRb26znPCbuSOuqO7mas
	 PSeTEfjGYYoTuO/Dki7Lk48mxhrPC4EQAaP8YOWRHMJAM6axHQVgPuBF5vpZIt6aVTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4Jx1nq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD0E606A31C;
	Tue, 10 Nov 2026 00:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q4Jx1nq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373641F0089F;
	Tue, 10 Nov 2026 00:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269090;
	bh=CZ7vuem9HsYeIcJa3YdOJQU6PgXlPc2dtCa17qxXdBQ=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=Q4Jx1nq0gAOiImEE50AScp+J4+d0J9u1NurqRjXnibZgArtKXW0q72EGH5LEwve5d
	 nYzXSHlEZt5gGlbRJQZMfy3v/xfVhsOIfQrRUHQ5yu3W/ePCEC4XxBq0i/s8IygRLd
	 Rtgajov6HVVhQ0RKA9/oK8LnYQd0TqxY4RpDQuqxi4Dv50Unq5oK0t7fpJNzI1/0uL
	 G9qnQaYGnmNpRuYwvvgCM1QV5rvLZOeU1lrOauvFzm5lH3rnSfpjon2VthvF4CJpdu
	 m5yHMXSIj3kY7YnLi7DhvOdicsFZQmTi2faeTgeJutH/F2cXWCIhiN3Se8hEndwwbW
	 BZW4+16O/ISdA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: don't skip free extents of the longest length in a whole-AG FITRIM" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:04:49 -0500
Message-ID: <20261110000449.3482084-1-sashal@kernel.org>
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

    xfs: don't skip free extents of the longest length in a whole-AG FITRIM

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-don-t-skip-free-extents-of-the-longest-length-in.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 9661004d580814f4be2838b1020ab0123f4da2b4
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Mon Oct 26 10:54:06 2026 +0900

    xfs: don't skip free extents of the longest length in a whole-AG FITRIM
    
    [ Upstream commit 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99 ]
    
    Since commit a66d636385d6 ("xfs: fix fstrim offset calculations"), the
    by-length walk of an AG in FITRIM starts with
    xfs_alloc_lookup_ge(cur, 0, pagf_longest) and walks down. The lookup
    lands on the longest free extent with the lowest block number. The
    other free extents of that length sort after it and are never
    discarded.
    
    Start every by-length batch with xfs_alloc_lookup_le() at restart_bno.
    
    Suggested-by: Dave Chinner <dgc@kernel.org>
    Link: https://lore.kernel.org/r/ZgiJWxVcVwag0fIP@dread.disaster.area
    Cc: stable@vger.kernel.org
    Fixes: a66d636385d6 ("xfs: fix fstrim offset calculations")
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8120f136af931..cdf660344c281 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -200,12 +200,12 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->restart_bno == NULLAGBLOCK) {
-		/* first time through a by-len starts with max length */
-		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
-		/* nth time through a by-len starts where we left off */
+		/*
+		 * A by-len walk starts at the last record of the longest
+		 * length (restart_bno is NULLAGBLOCK until the first batch
+		 * ends) and then where the previous batch stopped.
+		 */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
 					    tcur->count, &i);
