Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4411D1FF7B0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738621845; cv=none; b=VyUPwByp5kvuRAL7lwlueGAAgfKrFrCVf1ceTujwTlnilrR+QUWkgglbMssZ7mMb6i03L4wKdZiY8BANWZq6sZT8Mu6VXKsP0fQTgDniQffsdNIIY/8fzQR+LQLAAWil58myRI0nU0TH8Sp2D8/0d6+EQIZnsrEFKNsJ3oRspHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738621845; c=relaxed/simple;
	bh=pIsCw+wfk8QZHlBRJe7uJ9kRI+J3BnnvxUz8naTsSQk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vw1Lk1qzUUB0YCShzQR5UP/B0gyZcsACf+VIZHtIRieUXOY+rXz8efLP+hz+i3p0iUPYm7chDxvXCg/VjcZ4okvkJWdGmYIiZ8UmJBsxwYDjbLvjCByQl5xP7mJM7QQt3/TRTZ8PbZqxMQFsAvZTbcojPQ5oXbobeWbxyZ1SZ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgIgHp6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgIgHp6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C7FC4CEE4;
	Mon,  3 Feb 2025 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738621844;
	bh=pIsCw+wfk8QZHlBRJe7uJ9kRI+J3BnnvxUz8naTsSQk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KgIgHp6KEbtMgGKzY/BSc0PBpFNWjcqdW4bKHORCyt79JJPbNwsvi/Oi7lMUbnLe1
	 +hI3KVW7tffM1qD/h/Rm8eh/Meb12eQHw26SJFU8Y4SKDWLexb3Z6XNYz/f8oUDv0R
	 Z8v/98nrZxZct/rXlSsm+noxWA58uuucEvlxcLRz7HNGRP9w+J1mz0IFD0G9wB4wVR
	 s3PuleOpXHcYRt2LBmPh7a+QPxbk5SF5+14YL2MDL4dhV1ht8AreIj9iL6UhVzJjCT
	 Adyf9bxXSnHGcHX2reRv80VjYWvzlDG0DtlXr9f8D3bxxR/NWCEuoVmGl2lc4UYUq4
	 VmSTOxZkC/f1Q==
Date: Mon, 03 Feb 2025 14:30:44 -0800
Subject: [PATCH 1/2] xfs: fix online repair probing when
 CONFIG_XFS_ONLINE_REPAIR=n
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: david.flynn@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173862180309.2446958.6313766537382975638.stgit@frogsfrogsfrogs>
In-Reply-To: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
References: <173862180286.2446958.14882849425955853980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

I received a report from the release engineering side of the house that
xfs_scrub without the -n flag (aka fix it mode) would try to fix a
broken filesystem even on a kernel that doesn't have online repair built
into it:

 # xfs_scrub -dTvn /mnt/test
 EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
 Phase 1: Find filesystem geometry.
 /mnt/test: using 1 threads to scrub.
 Phase 1: Memory used: 132k/0k (108k/25k), time:  0.00/ 0.00/ 0.00s
 <snip>
 Phase 4: Repair filesystem.
 <snip>
 Info: /mnt/test/some/victimdir directory entries: Attempting repair. (repair.c line 351)
 Corruption: /mnt/test/some/victimdir directory entries: Repair unsuccessful; offline repair required. (repair.c line 204)

Source: https://blogs.oracle.com/linux/post/xfs-online-filesystem-repair

It is strange that xfs_scrub doesn't refuse to run, because the kernel
is supposed to return EOPNOTSUPP if we actually needed to run a repair,
and xfs_io's repair subcommand will perror that.  And yet:

 # xfs_io -x -c 'repair probe' /mnt/test
 #

The first problem is commit dcb660f9222fd9 (4.15) which should have had
xchk_probe set the CORRUPT OFLAG so that any of the repair machinery
will get called at all.

It turns out that some refactoring that happened in the 6.6-6.8 era
broke the operation of this corner case.  What we *really* want to
happen is that all the predicates that would steer xfs_scrub_metadata()
towards calling xrep_attempt() should function the same way that they do
when repair is compiled in; and then xrep_attempt gets to return the
fatal EOPNOTSUPP error code that causes the probe to fail.

Instead, commit 8336a64eb75cba (6.6) started the failwhale swimming by
hoisting OFLAG checking logic into a helper whose non-repair stub always
returns false, causing scrub to return "repair not needed" when in fact
the repair is not supported.  Prior to that commit, the oflag checking
that was open-coded in scrub.c worked correctly.

Similarly, in commit 4bdfd7d15747b1 (6.8) we hoisted the IFLAG_REPAIR
and ALREADY_FIXED logic into a helper whose non-repair stub always
returns false, so we never enter the if test body that would have called
xrep_attempt, let alone fail to decode the OFLAGs correctly.

The final insult (yes, we're doing The Naked Gun now) is commit
48a72f60861f79 (6.8) in which we hoisted the "are we going to try a
repair?" predicate into yet another function with a non-repair stub
always returns false.

Fix xchk_probe to trigger xrep_probe if repair is enabled, or return
EOPNOTSUPP directly if it is not.  For all the other scrub types, we
need to fix the header predicates so that the ->repair functions (which
are all xrep_notsupported) get called to return EOPNOTSUPP.  Commit
48a72 is tagged here because the scrub code prior to LTS 6.12 are
incomplete and not worth patching.

Reported-by: David Flynn <david.flynn@oracle.com>
Cc: <stable@vger.kernel.org> # v6.8
Fixes: 48a72f60861f79 ("xfs: don't complain about unfixed metadata when repairs were injected")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.h |    5 -----
 fs/xfs/scrub/repair.h |   11 ++++++++++-
 fs/xfs/scrub/scrub.c  |   12 ++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index bdcd40f0ec742c..19877d99f255b5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -224,7 +224,6 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 bool xchk_dir_looks_zapped(struct xfs_inode *dp);
 bool xchk_pptr_looks_zapped(struct xfs_inode *ip);
 
-#ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
 {
@@ -244,10 +243,6 @@ static inline bool xchk_could_repair(const struct xfs_scrub *sc)
 	return (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
 		!(sc->flags & XREP_ALREADY_FIXED);
 }
-#else
-# define xchk_needs_repair(sc)		(false)
-# define xchk_could_repair(sc)		(false)
-#endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 823c00d1a50262..af0a3a9e5ed978 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -191,7 +191,16 @@ int xrep_reset_metafile_resv(struct xfs_scrub *sc);
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
-#define xrep_will_attempt(sc)	(false)
+
+/*
+ * When online repair is not built into the kernel, we still want to attempt
+ * the repair so that the stub xrep_attempt below will return EOPNOTSUPP.
+ */
+static inline bool xrep_will_attempt(const struct xfs_scrub *sc)
+{
+	return (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
+		xchk_needs_repair(sc->sm);
+}
 
 static inline int
 xrep_attempt(
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7567dd5cad14f4..6fa9e3e5bab7b0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -149,6 +149,18 @@ xchk_probe(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	/*
+	 * If the caller is probing to see if repair works but repair isn't
+	 * built into the kernel, return EOPNOTSUPP because that's the signal
+	 * that userspace expects.  If online repair is built in, set the
+	 * CORRUPT flag (without any of the usual tracing/logging) to force us
+	 * into xrep_probe.
+	 */
+	if (xchk_could_repair(sc)) {
+		if (!IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR))
+			return -EOPNOTSUPP;
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	}
 	return 0;
 }
 

