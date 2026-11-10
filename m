Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269908;
	b=AEZvXa08a3bkESd0L/VGESrj8QNMyiESgZqbgYBPZHPhu467tfPSlk2eG1+IxyqCUxH9
	 IYbvljBB1VYJdVC2k0Efm+1QiofFmsIQTzIwhw2IOFPCGijxkohogJ6cR6w07V9aLXMiy
	 nVq+bBEIug8I+/t+nIYTFcRci3BAyaNRhLqUD6WcurWV04YoX4+2aH0AN8RIuU4mkMIeX
	 inKvK1pEDImD71IBOKb82c4BBqpefyLnUmpD4tQjQafBFANS3E4jy4Z8vPObyM24IciVf
	 HhHOt2/HfJJ5aOPnwc4Gj+K9v3t1u3MrEFMY6ms8nA8FYQ8Zse6DXjJv05lJLeA+9uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=6QjvyYfu9C5p57G3ULHEMrVhdI4s7dG+TuRtuJktbWA=;
	b=ihmzYARO3wlWahuE3od6w9rGjrWTKshwPP63/mqE5TYJ/QjeGOSmU7ay+Q+HPJ+Yo8M6
	 GRe+7aFw3L72FRL9UgMGscxa1As6f2UTqHHcJtT3LJDLMs3kFGcIxCRcj9+wFRHXauiUE
	 M21e+VPixTiNlK9THGQyZC4kvc9lWxjFQ9gUncyt2QoA9Nq4tVAS4WJQsS14xGqilppQT
	 WvCbLMiEnIXAhy3IpMKvv56Usq14+WEaq93FKR+7RTuLCw+5fh79eLvCO1d7Exb4tMvK1
	 9EmxKCScPwMJ0RXRe/k60vhZascmjzDidCCutb+7P4jcfRKe9V2hh3AMlDYCd57ZRHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kh/MrdiK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F492606A325;
	Tue, 10 Nov 2026 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kh/MrdiK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0B61F0089F;
	Tue, 10 Nov 2026 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269908;
	bh=6QjvyYfu9C5p57G3ULHEMrVhdI4s7dG+TuRtuJktbWA=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=kh/MrdiKZWFkjfGNYpq0k/HfToee/5aILL1jR/O9BKY2AnsNPzDODQCdNZtwq6NcO
	 tDcgGsOEk6rUuLaEv4aQxm3klcQP09qWWQa5Zffox0dlHG9hwfKlAJlJC29HoVtV1c
	 0A8CYurUxke76d/gNXHaOkF8R4UoGfr69rSFGgmJQjFKd+hhX6p2nr3+7LoMGRiZrb
	 yufXIAEg6NAWH3jLgWZLXoG36DJigOMm7TjPF+S4aG2g7+vdDH1K2tQE5F37p3h3LF
	 CFyg5TRNJ6yxv2rwS9DB74dpjOvl16HjT6Wax/yeHzCCOmdyGQAPrdYMgg34jZ4bcZ
	 ulvsvzUW2lMpA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: don't skip free extents of the longest length in a whole-AG FITRIM" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:18:26 -0500
Message-ID: <20261110001826.3500454-1-sashal@kernel.org>
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

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-don-t-skip-free-extents-of-the-longest-length-in.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 59387a8a121ce83c9ea70547a4a988aa126dc364
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
index b866329c7a28d..98933c1725214 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -211,12 +211,12 @@ xfs_trim_gather_extents(
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
