Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1A1198A05
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216925; cv=none; b=kIalXoea+CKWPAXkiUhClJFBoYBPvcLCwe2pIKhqlnubspEyeDJQODKEPMPQVF4W5bRI0l5Ef1mNATnmdqsw50y0JFgmi87ejoMw3OWZm9vsF6sbxZh2hiEAGtTfzHSShbZ6lxV6ih12XA3/4MkvX1aXgM7HLRMhEPlZSj70Gy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216925; c=relaxed/simple;
	bh=2xYMwkmibIPSZE3hDgfZElun/UslUCuuyF7HCb441to=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=svr9GeQcdAwe/zK6aSmDSH0yws9MoW4Bk15J9Xn5zo+F0wSWCJ9J7CKCXF2VzdpoCjEa2yHcT3fiNgwCx3BJQVcrjpAa9DhdUsNtcgzST/G55WG6IfUwnprzPRxH2HilV7vJTEWK5zLAwa53RZ0mh8lJ3bfMCJqSMjWhZgeNVXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NI1lZ07b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NI1lZ07b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A312C4CECD;
	Tue, 29 Oct 2024 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216925;
	bh=2xYMwkmibIPSZE3hDgfZElun/UslUCuuyF7HCb441to=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NI1lZ07bz0FW4SsafXfQhKZw/pIXC+cgtP32FJbwRtAsJu9jmCznmWAEgYFfV8lRe
	 +IlcQmg1jG15hrCPbVx0wJ8dRVTW+iHHTgtKvhU1rJTJ61Ugs8/5vV2OFX9oM5dJL+
	 dB+UX2Yr0cN+LGhyJL4DnU3uINwEQPCUivvr2ejhAxMrdufxwmK9Z95jUC7xoYjRGJ
	 j7/tiy+yKaHChmYByML8H8jwlir8iih0t6lEtv23weDcFaxKTysqvwbX844XWV/Awk
	 4emSHA9B7ajNPGFapRyPIhBaji9z5C5hl6iEobKi9Dj+NZFCpaXuHt5YhZKZEQzCJK
	 Js1BdN7qvVABQ==
Date: Tue, 29 Oct 2024 08:48:44 -0700
Subject: [PATCH 4/8] xfs_db: access realtime file blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173021673296.3128727.1175236924173292657.stgit@frogsfrogsfrogs>
In-Reply-To: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
References: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the ability to point the io cursor at the realtime
device, let's make it so that the "dblock" command can walk the contents
of realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |   17 +++++++++++++++--
 db/block.h |   20 ++++++++++++++++++++
 db/faddr.c |    5 ++++-
 3 files changed, 39 insertions(+), 3 deletions(-)


diff --git a/db/block.c b/db/block.c
index 6ad9f038c6da67..87118a4751ef94 100644
--- a/db/block.c
+++ b/db/block.c
@@ -196,6 +196,13 @@ dblock_help(void)
 ));
 }
 
+static inline bool
+is_rtfile(
+	struct xfs_dinode	*dip)
+{
+	return dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+}
+
 static int
 dblock_f(
 	int		argc,
@@ -235,8 +242,14 @@ dblock_f(
 	ASSERT(typtab[type].typnm == type);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
-		nb * blkbb, DB_RING_ADD, nex > 1 ? &bbmap : NULL);
+	if (is_rtfile(iocur_top->data))
+		set_rt_cur(&typtab[type], xfs_rtb_to_daddr(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
+	else
+		set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+				nb * blkbb, DB_RING_ADD,
+				nex > 1 ? &bbmap : NULL);
 	free(bmp);
 	return 0;
 }
diff --git a/db/block.h b/db/block.h
index 7c4e8cb2acb051..55843a6b521393 100644
--- a/db/block.h
+++ b/db/block.h
@@ -3,8 +3,28 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#ifndef __XFS_DB_BLOCK_H
+#define __XFS_DB_BLOCK_H
 
 struct field;
 
 extern void	block_init(void);
 extern void	print_block(const struct field *fields, int argc, char **argv);
+
+static inline xfs_daddr_t
+xfs_rtb_to_daddr(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtb)
+{
+	return rtb << mp->m_blkbb_log;
+}
+
+static inline xfs_rtblock_t
+xfs_daddr_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	return daddr >> mp->m_blkbb_log;
+}
+
+#endif /* __XFS_DB_BLOCK_H */
diff --git a/db/faddr.c b/db/faddr.c
index ec4aae68bb5a81..e2f9587da0a67c 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -15,6 +15,7 @@
 #include "bmap.h"
 #include "output.h"
 #include "init.h"
+#include "block.h"
 
 void
 fa_agblock(
@@ -323,7 +324,9 @@ fa_drtbno(
 		dbprintf(_("null block number, cannot set new addr\n"));
 		return;
 	}
-	/* need set_cur to understand rt subvolume */
+
+	set_rt_cur(&typtab[next], xfs_rtb_to_daddr(mp, bno), blkbb,
+			DB_RING_ADD, NULL);
 }
 
 /*ARGSUSED*/

