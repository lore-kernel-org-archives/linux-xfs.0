Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A0D1ADC6D;
	Tue, 14 Jan 2025 22:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736894900; cv=none; b=uZKOMVbdBvW/O1qmPqC8NMLS/YcvOx77mDdbVrzoU9+6CgsYv9Zs9M+EbFBtDgvia148GuqCrxBLwgJS+WOyXE3EHBUpHuPO4wYj6emWppbsrmy+poc7AjLoKmZgdUmr1U+mxmaFNOq5kXaAFnp2T4WyTDTvTnDz51+wiqf12bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736894900; c=relaxed/simple;
	bh=F4hIGq+99afypTKwg0moyFekGE3NC4ugD6/jXTXWilk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FnFQx+ryGARyF+xtYPGXq5491kC2u9EGYB8g22QFxbZKS5ACB33ausRGVeLRrhPtZwMXwn0d5vK/mkdvNqQOG6uxIlfHWeKZIqAJKPgdqjQgz/GLx8MV+xOvLrCumi3o/d1ZlwSYwfBEDK127HP1c7Bbiny1R7Xl0jDBVVtwE3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijcpZcMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijcpZcMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF3FC4CEDD;
	Tue, 14 Jan 2025 22:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736894900;
	bh=F4hIGq+99afypTKwg0moyFekGE3NC4ugD6/jXTXWilk=;
	h=Date:From:To:Cc:Subject:From;
	b=ijcpZcMM6NlCLJqmGPrnUW1dbV7aVDXZawD2biur9u/0EZof1wmDlh+63wZuoVDmN
	 oq5Mg8wmZq2L9h6LkND251wLNuYdC9gNpTmTjUYDuFwPrTQUfUYGUiKCi3s4wZAh4y
	 LZwyt6ssq0+dyMH2JD6WflggXIpjScJ0CN27v4LzkCN0ChSjcyf3I48ZvRKFgIpITz
	 F2LgK82OQsXthMcEx57tG05AmeLcnRbk6HmPXmlGUT6ANdGb8G1zDprujsRy8Cj/0d
	 y+9W/O9wBKBl3bWG4Spkn6yxM50eOo6MvK+pFM7kg94efJ33bnHPCL5QMONeZDKH6/
	 RkeZ4MCZ4K0hQ==
Date: Tue, 14 Jan 2025 14:48:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de,
	xfs-stable <xfs-stable@lists.linux.dev>, stable@vger.kernel.org,
	david.flynn@oracle.com
Subject: [PATCH] xfs: fix online repair probing when
 CONFIG_XFS_ONLINE_REPAIR=n
Message-ID: <20250114224819.GD2103004@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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

So.  Fix xchk_probe to trigger xrep_probe, then fix all the other helper
predicates in scrub.h so that we always point to xrep_attempt, even if
online repair is disabled.  Commit 48a72 is tagged here because the
scrub code prior to LTS 6.12 are incomplete and not worth patching.

Reported-by: David Flynn <david.flynn@oracle.com>
Cc: <stable@vger.kernel.org> # v6.8
Fixes: 48a72f60861f79 ("xfs: don't complain about unfixed metadata when repairs were injected")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/common.h |    5 -----
 fs/xfs/scrub/repair.h |   11 ++++++++++-
 fs/xfs/scrub/scrub.c  |    9 +++++++++
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index eecb6d54c0f953..53a6b34ce54271 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -212,7 +212,6 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 bool xchk_dir_looks_zapped(struct xfs_inode *dp);
 bool xchk_pptr_looks_zapped(struct xfs_inode *ip);
 
-#ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
 {
@@ -232,10 +231,6 @@ static inline bool xchk_could_repair(const struct xfs_scrub *sc)
 	return (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
 		!(sc->flags & XREP_ALREADY_FIXED);
 }
-#else
-# define xchk_needs_repair(sc)		(false)
-# define xchk_could_repair(sc)		(false)
-#endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index b649da1a93eb8c..b3b1fe62814e7b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -173,7 +173,16 @@ bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
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
index 950f5a58dcd967..09468f50781b24 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -149,6 +149,15 @@ xchk_probe(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	/*
+	 * If the caller is probing to see if repair works, set the CORRUPT
+	 * flag (without any of the usual tracing/logging) to force us into
+	 * the repair codepaths.  If repair is compiled into the kernel, we'll
+	 * call xrep_probe and simulate a repair; otherwise, the repair
+	 * codepaths return EOPNOTSUPP.
+	 */
+	if (xchk_could_repair(sc))
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	return 0;
 }
 
