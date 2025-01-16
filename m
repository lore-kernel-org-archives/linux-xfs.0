Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5646BAD23;
	Thu, 16 Jan 2025 00:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987727; cv=none; b=jmqZRNT6tixrSe3bc5vKAvmfSvRcOWueQ5njBreGVaQ2XL/HzGSxyhcvwuAq9TQnMcdeun8ca3qyKCEiOxqbGYmvEKzL4/xsdNs/XpkhR9DoScM0ycVxsthCXUhb2GmzsTWWKgMVkB5Mc8pAZiJK8LYuoZGVbg0lMTkeB3Qgmr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987727; c=relaxed/simple;
	bh=BBa8VxfeD4axvKZyATn6Z7TsOR2lON5GH2Td1tKbhMY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OUsjQgPwvHF2BcNYq1KYf9KrynxXVsLaOZSzh4br1X6Gy+JT8Zk6A/OmEpBcA5kAP088dCD6scS1fd8zZcUcwR5fOhyaeLJ4Vli9xmqNfXdilsHoB0jQVEINd9e85SoxV/gVim/j2adcmERbmIj9E9rQ+eKHF873FeIpVA5ham8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HT1Kqsn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HT1Kqsn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BDFC4CED1;
	Thu, 16 Jan 2025 00:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736987727;
	bh=BBa8VxfeD4axvKZyATn6Z7TsOR2lON5GH2Td1tKbhMY=;
	h=Date:From:To:Cc:Subject:From;
	b=HT1Kqsn4c2e222Xi/tm/2jglKA+5M0Za3rPrBQOr2gI+sa3LOWi4vidWmI6xBvR1o
	 WjuCv0uQ/plGzELP510AlFvB7eSPts4yk7ohN3jpIcHzixPWcguhWwF7PJzZPukao+
	 vgP4NJSXOzQm3lImUchTL8A9+WRxUHgfWjxbTuYj13/Q7QepvaxK7AfXpqvIicsBkY
	 6FUHvS+L1t10njgvpR/0NV1u4yF6bsPwcX2sa7vgNNzCtHapi1iVxQM797rwJmqa7Y
	 ilLa+AhR6wPNLSpRsQDdz3jcHuEwSaub2entRtI694gu2s+ccm6+eBcRTO0WqTx2tV
	 gpx8L70RRCnPA==
Date: Wed, 15 Jan 2025 16:35:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de,
	xfs-stable <xfs-stable@lists.linux.dev>, stable@vger.kernel.org,
	david.flynn@oracle.com
Subject: [PATCH v2] xfs: fix online repair probing when
 CONFIG_XFS_ONLINE_REPAIR=n
Message-ID: <20250116003526.GE3566461@frogsfrogsfrogs>
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
index 546be550b221b6..4722cb51fd1522 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -225,7 +225,6 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 bool xchk_dir_looks_zapped(struct xfs_inode *dp);
 bool xchk_pptr_looks_zapped(struct xfs_inode *ip);
 
-#ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
 {
@@ -245,10 +244,6 @@ static inline bool xchk_could_repair(const struct xfs_scrub *sc)
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
index d3a4ddd918f621..01fdbbc7adf30e 100644
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
 
