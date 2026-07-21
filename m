Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0D778F26;
	Tue, 21 Jul 2026 03:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604415; cv=none; b=eMgl/81SA43hokpnKEHR6c7v976BUdy/jhzIgbLhx5Y1Qv9uvbgOPdY7AGLeRseXWARD30vXC7ujpcGg2uKBTKBTZ6ZPkcp7UZ/ppnJtoKimMrsnwMPRXg/qJmg0eRzQlqusNBU0L7UwAeko3oTZcVO5l6c/Ncs271q1dcydbRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604415; c=relaxed/simple;
	bh=k+0EWdxrWKUumq59eiHusSnrZAkgqrDse4s1s/KCaSU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AoVtbVzejv6joNIRQv7N3kGo+tMw4y2r2OWNznZ08dO3ashZ0KqmlwKStfnTwXe2Xzh1L7IyDZpV7mV1zQxLFGZ3dUgn/hAHZXNcewehk84HW7opiFfBfZlpzCQ/cRdJp1c/b+oI2/nZuuV9XGfJKdohQJ8v6XnL0eHJRmMHZa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNBAqjZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNBAqjZW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 042B21F000E9;
	Tue, 21 Jul 2026 03:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604414;
	bh=sOKnQG5IYa/civR5PY8coMx0TyGGL9SsLSAIPWpO5I4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GNBAqjZWokhQMLW8XuJzEfTC/VB3DbLrtO1nevUsH2tXIZOSTq50LHqPTs/ED7zoB
	 xTby68Z6vEcVzmdMID/e5W2/Z0D0sChgE72vSdzzADTtZhvswLHHBjbJkByGhxFZ/5
	 ZN1GbEAr7y6k47/xeOj6K2CyYCMpH2IUkOGFvPOcunLx6AHI2Cy6iSuQtu0ccsoR54
	 pf8i/BzJ7zoErY+mV5qlK/3CwmgMw/shqHhGV4SGO5TBYxw6YL7jscCSo1ASTeUfK0
	 wbYiXgmnrjdIUTs1AnSWtPmoqk+/K78BfRrdW1IooTv2jo59zy2s3eEpuEnjfFP565
	 MCix1xi9WHMPg==
Date: Mon, 20 Jul 2026 20:26:53 -0700
Subject: [PATCH 8/9] xfs: fix another iunlink infinite loop bug in online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419658.830862.2707474521987278261.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xrep_iunlink_resolve_bucket is supposed to reconstruct as much of the
incore prev and next unlinked list pointers based on what it finds on
disk and in memory before we move on to relinking the truly lost inodes
back into the unlinked list.  However, it's still vulnerable to infinite
loops that come in via the next_unlinked pointers.

Fix this problem by checking iunlink_bmp, which at that point in
execution represents truly unlinked inodes that haven't yet been
processed.  If a bit is already unset, either this is a loop or the
inode has nonzero link count.  We'll deal with the second case in a
subsequent patch.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h           |    1 +
 fs/xfs/scrub/agheader_repair.c |   10 ++++++++++
 2 files changed, 11 insertions(+)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 00fbe1b9c2354f..14aa0ec1f09e4a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3538,6 +3538,7 @@ DEFINE_EVENT(xrep_iunlink_resolve_class, name, \
 	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket, \
 		 xfs_agino_t prev_agino, xfs_agino_t next_agino), \
 	TP_ARGS(pag, bucket, prev_agino, next_agino))
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_infinite_loop);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index edd406a97b7ce9..da2265678d17f5 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1355,6 +1355,8 @@ xrep_iunlink_resolve_bucket(
 	int			error = 0;
 
 	while (next_agino != NULLAGINO) {
+		unsigned int len = 1;
+
 		if (xchk_should_terminate(ragi->sc, &error))
 			return error;
 
@@ -1417,6 +1419,14 @@ xrep_iunlink_resolve_bucket(
 			continue;
 		}
 
+		/* Inode already seen?  We're stuck in a loop */
+		if (!xagino_bitmap_test(&ragi->iunlink_bmp, next_agino, &len)) {
+			trace_xrep_iunlink_resolve_infinite_loop(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+			next_agino = NULLAGINO;
+			break;
+		}
+
 		trace_xrep_iunlink_resolve_ok(sc->sa.pag, bucket, prev_agino,
 				next_agino);
 

