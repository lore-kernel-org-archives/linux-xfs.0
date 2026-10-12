Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB12D2DB7B8;
	Mon, 12 Oct 2026 05:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784717; cv=none; b=LCPcHvfJqcj68cbXc3/Jh1PBXsx1qjHOjSzbpy1bDBqX2/AFn7YuaxGFsTW5rD9ajnLkpDo4cmj1xmfQLU3L53BgVUkqjnIJfbgP9PPch2c4duIc8+GabCeFa+n6Y7NPVnCM+4wtVT+s57ATk+loUSNdnnarNl6uKWJ+nM6aUA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784717; c=relaxed/simple;
	bh=/X4cHAfb8SnHY5J9Xzdi3AaYB8adDP3MrgPPc1dKgV4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQgDvMRCEay0m+E5iBTkrBO879+5wa+qS/FLf/VQEgw1iN7V7mUf6wYZiIX8BRUxDnNTq/wES6qb9HsddKh7odd1PNyeakgwB1ZWi2/1prS4UDvHcENFpR0EJpGF7iuB1FyC//KqmcKhLvh7U1g3L7rhyvdRkSJ3DriSiex6dzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bywe7g3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bywe7g3e"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6FFD61F0089B;
	Mon, 12 Oct 2026 05:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784716;
	bh=udiihpFDD/I70RMQxQevxk3v++NAQA/BFg45LO6F6dc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bywe7g3eVzhn6V2O+HBydG40/EFPHT828LDGXvLfcdBoEbADOrvRHY4HHvWtz7PO6
	 XIQBUtsYpGj5dkM8Et0mVSNBzTVE/bNQ+gxHWMEWapB2r0bpz/KtDjYlvzMj17f89t
	 ESeJw+DRNpaznMB09dmPPblX48j9enQSu1x5iz1cDyxeO3EDq9S5w8bibef9dpsgTA
	 TFzaT5q4ky/B0QR1G47TEB0BAk98yCPnrAtrqV/z/K6alma4o7ZU5gJI+TOQ7fAFAM
	 osFsjnwTBpt1oOky/AfzZtyfuhkg3DO05sttjtLWX34e5iPgvxWLjFd9lx3SW8ZQVP
	 iq7w63lL8UEjw==
Date: Sun, 11 Oct 2026 22:58:36 -0700
Subject: [PATCH 11/12] xfs: always report scrub errors in tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065432.1058326.16069797217698789453.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/btree.c   |    8 +++++++-
 fs/xfs/scrub/common.c  |    7 +++++--
 fs/xfs/scrub/dabtree.c |    6 +++++-
 3 files changed, 17 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 43b81432640777..ce8c9c1aaa3102 100644
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

