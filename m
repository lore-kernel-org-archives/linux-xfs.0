Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E3048EC62;
	Tue, 13 Oct 2026 06:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871686; cv=none; b=D7JyXoIwYG+HrmNxFhGCdpBMPeEJWLOhCAwpp+VHZ3IFO8DpZRnb+5CqmE/OyHfC+TG2MELTe2Cm0QbHfd0jZhlV0oapEH9Y/ynVveoNH8NSy0n8UNPA5LgO5QNM8GJx59CuDF2nNDoo7ZIbwyIw0Az3sFImdfxITO2fWoIr4SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871686; c=relaxed/simple;
	bh=aW/m1tW1FGQh8g7oejfDroYhRyPcJ6MVymnVrA7BUro=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tqsau/4i1V+F3GgULnRC8u23LVNuZ4dExqkFvwu6iukS+px0XBShe0X7lI4bviCMkxERfhsn7odypreZJmAT5dCrjC/5NDV0BmQCWgrCpe7dwpSRHNJ81gbxr7Ktes38DS0DPL2jPwUZvjdu3vmA97nIDHGoi9t/wdLWfahcCMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIbELYUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIbELYUR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14CCF1F000FF;
	Tue, 13 Oct 2026 06:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871685;
	bh=YW0qbHJw4cSBpWAbjSsi3dWpu3LY5ob7qywBIbMdwB4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EIbELYURGf4dij8O7zV2H4i6P78KuMPKn1PvzUZ6TZie27Kz2DdUdiBMTXD2Vev3S
	 YXriaAWUr7SbiRHPot3B44bgSG+qLngeAgSf5AN+GqmwcXkfBXEV0FLQsnvHWD+ut3
	 TiHTVCzNbxCNjk3NdzHEMcnnyUp09g39t2nYRTTvUbHGRUiRGJn4UOOebs3Cj2pSWw
	 WxESWylWo0nVpFbE5i6by6vgDPgJXE7YHzQaEDJd3sVQXvmKpqcN40IIfaTMdv9wix
	 E4lh+W1UdvOkM1B/16oTk1QfqdLzjm5fxt8FrNLiatk5nKchR8yhIY9ghnqosA7Ll4
	 s22Gp2Pr5Z8Jw==
Date: Mon, 12 Oct 2026 23:08:04 -0700
Subject: [PATCH 11/12] xfs: always report scrub errors in tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107376.1898400.9851336979877114708.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that the error processing functions in scrub will
sometimes zero out *error before recording a tracepoint.  This makes
diagnosing problems harder, so let's fix that.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 4700d22980d459 ("xfs: create helpers to record and deal with scrub problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/btree.c   |    8 +++++++-
 fs/xfs/scrub/common.c  |    7 +++++--
 fs/xfs/scrub/dabtree.c |    6 +++++-
 3 files changed, 17 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 17bd8505be0411..43a7ea7308eea9 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -46,8 +46,14 @@ __xchk_btree_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
+			trace_xchk_ifork_btree_op_error(sc, cur, level,
+					*error, ret_ip);
+		else
+			trace_xchk_btree_op_error(sc, cur, level,
+					*error, ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e5233e31abb750..a61895872072d1 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -107,8 +107,9 @@ __xchk_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		break;
@@ -183,8 +184,10 @@ __xchk_fblock_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		trace_xchk_file_op_error(sc, whichfork, offset, *error,
+				ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index bbf6ece58828ca..02c8544d891861 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -49,8 +49,12 @@ xchk_da_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
+				xfs_dir2_da_to_db(ds->dargs.geo,
+					ds->state->path.blk[level].blkno),
+				*error, __return_address);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,

