Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2637F188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992189; cv=none; b=LwModrY8Wdz8xKhXfFPEHVurwoIMqEs6DLNZGE4mnwD45qlOzu7jPV226B85bCVwqjHFmtPhj/5MUfsycjGTDpJH5fB5ht1T/0poksfV2TKzOaQiTieSo8eFKML2holbbScUZKflgiYWtY5Gu0ScqjQuwAPEJXISFX3wNOW9R5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992189; c=relaxed/simple;
	bh=jxQnoZdK4wjGokTLSZ64zljYKGtQmXdGS/Dluj3pl7A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+SZP89zELgULLZvetKnbcJ/pny8/7cokIvX4gXGlr5g9utIbOwc1XWhp5mIpKQqqmKzYxVZqXqMrEMI5XaQ0gkqHgMGfAeUh0ttkfj1/B1MqbL6T8jd2+G+C+HYK+XdavDI80QZvbYVUJSN2hO+M5bmESoDF2sYxp0i+4oMIDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2rn3y7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2rn3y7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F41C4CED3;
	Mon, 23 Dec 2024 22:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992187;
	bh=jxQnoZdK4wjGokTLSZ64zljYKGtQmXdGS/Dluj3pl7A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U2rn3y7nIuloZoh0ljZGBjISzblN6J8dtXRuPnbl33WcR0ipwK3yAGfbU3tEQoxPz
	 6GmUdbMhDKbjsMdTi+sT1mn4h41H8xeKyg29Erv6TNsoF22O7XlGjdVVeQLFvMgUrp
	 bcSjegETiiifH04/bdKsIeApkgPQc7mOVj595gB6vBbi7EnmwZKwZsLiPV/kD7Us4W
	 0BJWK1VsnRHJHLTxOOFGsjjiesXesoZoub3VX/TWq/tpjVZdGrblEc4fYH8vlTQPv+
	 GF/j/edaZQIa2/XJq5UFyrj4HvtElu0qa5t92U11K03e7nhNOig3hf6BBDhnMBlOPU
	 Per3PRngN0rMA==
Date: Mon, 23 Dec 2024 14:16:27 -0800
Subject: [PATCH 18/51] xfs_repair: simplify rt_lock handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944080.2297565.1420503238702137131.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

No need to cacheline align rt_lock if we move it next to the data
it protects.  Also reduce the critical section to just where those
data structures are accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c  |    6 +++---
 repair/globals.c |    1 -
 repair/globals.h |    2 +-
 repair/incore.c  |    8 ++++----
 4 files changed, 8 insertions(+), 9 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 56c7257d3766f1..8c593da545cd7f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -304,7 +304,7 @@ process_rt_rec(
 	bool			zap_metadata)
 {
 	xfs_fsblock_t		lastb;
-	int			bad;
+	int			bad = 0;
 
 	/*
 	 * check numeric validity of the extent
@@ -338,10 +338,12 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 		return 1;
 	}
 
+	pthread_mutex_lock(&rt_lock);
 	if (check_dups)
 		bad = process_rt_rec_dups(mp, ino, irec);
 	else
 		bad = process_rt_rec_state(mp, ino, zap_metadata, irec);
+	pthread_mutex_unlock(&rt_lock);
 	if (bad)
 		return bad;
 
@@ -451,10 +453,8 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 		}
 
 		if (type == XR_INO_RTDATA && whichfork == XFS_DATA_FORK) {
-			pthread_mutex_lock(&rt_lock.lock);
 			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups,
 					zap_metadata);
-			pthread_mutex_unlock(&rt_lock.lock);
 			if (error2)
 				return error2;
 
diff --git a/repair/globals.c b/repair/globals.c
index bd07a9656d193b..d97e2a8d2d6d9b 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -112,7 +112,6 @@ uint32_t	sb_unit;
 uint32_t	sb_width;
 
 struct aglock	*ag_locks;
-struct aglock	rt_lock;
 
 time_t		report_interval;
 uint64_t	*prog_rpt_done;
diff --git a/repair/globals.h b/repair/globals.h
index ebe8d5ee132b8d..db8afabd9f0fc9 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -156,7 +156,7 @@ struct aglock {
 	pthread_mutex_t	lock __attribute__((__aligned__(64)));
 };
 extern struct aglock	*ag_locks;
-extern struct aglock	rt_lock;
+extern pthread_mutex_t	rt_lock;
 
 extern time_t		report_interval;
 extern uint64_t		*prog_rpt_done;
diff --git a/repair/incore.c b/repair/incore.c
index 06edaf0d605262..21f5b05d3e93e4 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -166,6 +166,7 @@ get_bmap_ext(
 
 static uint64_t		*rt_bmap;
 static size_t		rt_bmap_size;
+pthread_mutex_t		rt_lock;
 
 /* block records fit into uint64_t's units */
 #define XR_BB_UNIT	64			/* number of bits/unit */
@@ -209,6 +210,7 @@ init_rt_bmap(
 	if (mp->m_sb.sb_rextents == 0)
 		return;
 
+	pthread_mutex_init(&rt_lock, NULL);
 	rt_bmap_size = roundup(howmany(mp->m_sb.sb_rextents, (NBBY / XR_BB)),
 			       sizeof(uint64_t));
 
@@ -226,8 +228,9 @@ free_rt_bmap(xfs_mount_t *mp)
 {
 	free(rt_bmap);
 	rt_bmap = NULL;
-}
+	pthread_mutex_destroy(&rt_lock);
 
+}
 
 void
 reset_bmaps(xfs_mount_t *mp)
@@ -290,7 +293,6 @@ init_bmaps(xfs_mount_t *mp)
 		btree_init(&ag_bmap[i]);
 		pthread_mutex_init(&ag_locks[i].lock, NULL);
 	}
-	pthread_mutex_init(&rt_lock.lock, NULL);
 
 	init_rt_bmap(mp);
 	reset_bmaps(mp);
@@ -301,8 +303,6 @@ free_bmaps(xfs_mount_t *mp)
 {
 	xfs_agnumber_t i;
 
-	pthread_mutex_destroy(&rt_lock.lock);
-
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		pthread_mutex_destroy(&ag_locks[i].lock);
 

