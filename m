Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950A58BE5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610062; cv=none; b=fdw1HjN2TvtqY9YjrFnWrI0h0M75/o79rE9CBNaBYWx6YF5702ZDYnMsHfIqolDbLQsaiEDye4I5p+PdnaKScEh3wEzQbZyzbeEmYFaLLBjE48aBKHX6ZlLWWZH3P2GOAKsAxBLrd9iUu9z+cOQlx2n7ARJolbGTe/HAg0Ap52M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610062; c=relaxed/simple;
	bh=+N5z241/h6zIkFzbFkzPw7B+CMjzxext2SO/FAD7Ih0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=er0JtAHzhR4Hq7b1xe/wqruGzFBHHf4iZY2QRc0FmTpx6PBCh4RUFg98H9eWGLdbtSBfuoRJUxwuf+a4zjA3cpxnSKlEzKqAAKN6KErAGlgjFCWb3SkvWFNw8CaXjaLoS6/L/2ovNvVZh9WY2P+EUMvCI55FBKa3LKhiol6Y2aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSMHxmnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSMHxmnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19801C4CEC5;
	Fri, 11 Oct 2024 01:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610062;
	bh=+N5z241/h6zIkFzbFkzPw7B+CMjzxext2SO/FAD7Ih0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oSMHxmnMTJwa1PSL7I1qgdVweW14xaQo0iIPCqt087DHwKpQXQHt5RQuV5Un56MJu
	 TaET5dscisgoQPCzSyH9PIldtTIDqNIT7fYziLC2Mhp5acEMW2iXRnWV7V04f+VtYg
	 maqPC49eEftml5CLIEzCoqogkHr612OCnBfPIT+ucYxE+1vNVg1YbPw/d6o+oYsDBX
	 bfmInaqSUdC6CgZOR8MT/yHr3foXtBTsB9+CauNTg5IpItwYwDNvtlDJNMM25Z7oCZ
	 WpxPE9Tp3Mjqh8j4FebgXEv6t5LFQYgM1bxvIYCUN+CcajALvqIE8zHavob7LjJh4f
	 sSDoK1B9lsEmg==
Date: Thu, 10 Oct 2024 18:27:41 -0700
Subject: [PATCH 12/43] xfs_repair: simplify rt_lock handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655550.4184637.1700399432316813680.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

No need to cacheline align rt_lock if we move it next to the data
it protects.  Also reduce the critical section to just where those
data structures are accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c  |    6 +++---
 repair/globals.c |    1 -
 repair/globals.h |    2 +-
 repair/incore.c  |    8 ++++----
 4 files changed, 8 insertions(+), 9 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index e59d358e8439a2..5046a5ed6dcc31 100644
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
 

