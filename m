Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABEB13A252
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441865; cv=none; b=PlkAYEYSn7mJSPo3DLFLmr5nwhQ2psVFR0DuaNMx/BJ7IfAMWF7FUGCcZMOh5eNQogolR3AX22sZW17BEw07/7eGQWC4y8Gfs7ApViaVuQO0eHAY7rf+D2NkcEYDCJ9fJfi2c5QAmdMMfaUHAt8UN8XgukzStc10YvxgXxuXZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441865; c=relaxed/simple;
	bh=uwsEuaap/8WGSdctihycgb5GNwRXRHBWFqT6HdBoxIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nHP9roa1dVceOM8usIR1889jZr8eY9tB0B4bbXNst8HGTStfzxAek5/PtU8hljXLvoVi+SvqtrCxUTSUu25r3Y7/nRqgG0zIkyuZROpRe+fV18lM91bJQ8X/sUNQWI3zqEC3fVnBp8uupVAiOVXaExvAa+lpL3ww8Chv1vEvDBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kI2d4FsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kI2d4FsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E802C2BD10;
	Mon,  3 Jun 2024 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441865;
	bh=uwsEuaap/8WGSdctihycgb5GNwRXRHBWFqT6HdBoxIs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kI2d4FsHm41wfkgS4+SN8Jbpn0qvP7Nc/TKVU2SQt7B5gHa0CDVBxmBYgHuF4Lxog
	 Ydi63bAoOXtGjYTMsAMNDJJZN5yy4TiZxii+JGXilnZ3EHOyUSqeowdxOaPFE87jxV
	 fKF8gMXcHJQhP0ovNoH5E0xupJxN7IL4bf2hJY2XYjVMQXKIKadcM53Mp4t8mtbjOa
	 WGOlrNJCkSojpC9YnHw/XSEE746pIoI0OB7Uh4xxylmAivzRwEyKFZ05PhU8GcJKxz
	 UUQ3W+Wkl99gu9NbaajdKHrm33M35GNh69kbd4tvf7gaQ15I1SaNNN4TyFgqa/txWR
	 15N1AItA7sRLA==
Date: Mon, 03 Jun 2024 12:11:05 -0700
Subject: [PATCH 073/111] xfs: pass a 'bool is_finobt' to xfs_inobt_insert
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040471.1443973.9597080958593394823.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: fbeef4e061ab28bf556af4ee2a5a9848dc4616c5

This is one of the last users of xfs_btnum_t and can only designate
either the inobt or finobt.  Replace it with a simple bool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_ialloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 37d014713..296548bc1 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -201,14 +201,14 @@ xfs_inobt_insert(
 	struct xfs_buf		*agbp,
 	xfs_agino_t		newino,
 	xfs_agino_t		newlen,
-	xfs_btnum_t		btnum)
+	bool			is_finobt)
 {
 	struct xfs_btree_cur	*cur;
 	xfs_agino_t		thisino;
 	int			i;
 	int			error;
 
-	if (btnum == XFS_BTNUM_FINO)
+	if (is_finobt)
 		cur = xfs_finobt_init_cursor(pag, tp, agbp);
 	else
 		cur = xfs_inobt_init_cursor(pag, tp, agbp);
@@ -936,14 +936,13 @@ xfs_ialloc_ag_alloc(
 		}
 	} else {
 		/* full chunk - insert new records to both btrees */
-		error = xfs_inobt_insert(pag, tp, agbp, newino, newlen,
-					 XFS_BTNUM_INO);
+		error = xfs_inobt_insert(pag, tp, agbp, newino, newlen, false);
 		if (error)
 			return error;
 
 		if (xfs_has_finobt(args.mp)) {
 			error = xfs_inobt_insert(pag, tp, agbp, newino,
-						 newlen, XFS_BTNUM_FINO);
+						 newlen, true);
 			if (error)
 				return error;
 		}

