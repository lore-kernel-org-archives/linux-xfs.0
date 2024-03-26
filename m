Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3383B21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424849; cv=none; b=n+tKhXoLej+xEW/J3634Wt4Zy/8ND/Gm4ti7tYkFMZWFH05Do2RNyicDpjKRDB4wAETJOnJckEVIq35LLlXb6hyWdvlw71Ejrb9EzSBOkgOZs650Az6prj7si9L1AGfan8C1Qjxzxr9F/8gZgg6rioAw9s+KNrfVdBa3sKBRuXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424849; c=relaxed/simple;
	bh=gMvXZhH8t3J+/KIExTeShkgnsP65xQoa5wC5JjOsh6w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YcfZ5FpAExoD69Uao4VO2G4U78G6hhwBvKf4DDP/dH2rAwb3R0hCmKcJ17PF2dbhGOdibYlhSuP3qZNcvHW/3/EFZHez9kvoMnk6gPkqQRm0N6vOMRYgAz+Untwzal4nlYAiCU/PtDLqTyFSV9/Pzx9oF4AmDrDaTqck9wi5i2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyIgM9aD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyIgM9aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F392C433C7;
	Tue, 26 Mar 2024 03:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424848;
	bh=gMvXZhH8t3J+/KIExTeShkgnsP65xQoa5wC5JjOsh6w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NyIgM9aDWTQFjnfJqLEXfepW3N1bQ71HW8Uazgh3FyL+n8/T/8fn9RJugkSfEvFjU
	 hID1Rap7ba2IPMAgeEC0aDV+CONGUZoFaX4GguEYJwsG22Je+UpKnztnwaRqFa6wie
	 uRQwBCxmMvPq40TSVgc7llagrRM1rIS5j7vvFOeeJDx0D8Ud8dasIkF9pxcbXGuSUQ
	 aSLPOTdQVcnuvoMXdf7htJFaEdpQlqFMnU6i4uV6MLfGH61EbXlGiLhYDrAIi9ZXWW
	 rl7tdaM0U9Zf2RCELGtFEzW/9xcY5D2kOXoHgHVgneuHOm/lEKjPYrcWCEUSbnP39I
	 lVflPhNqCCvGQ==
Date: Mon, 25 Mar 2024 20:47:28 -0700
Subject: [PATCH 073/110] xfs: pass a 'bool is_finobt' to xfs_inobt_insert
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132432.2215168.14371580213121517268.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_ialloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 37d014713db1..296548bc1d45 100644
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

