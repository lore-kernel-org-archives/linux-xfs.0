Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9183921D8;
	Wed, 23 Sep 2026 06:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143293; cv=none; b=qICnoTeJZB1bvgQ0/Jf+VTv6Ntr+N75EmB50aKhvTWIe1+y4ZMO6Phb8swPB/cgI/ugAaxT5UoY7m1FB2wJRcuCZdcKrvi3nuZO/PgpphQ5MCkRu8pCJbsRLFCCoRjH2yV7478bWUQir6K8d47RQxQyfs7UjEaWiT3ekuLjzBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143293; c=relaxed/simple;
	bh=sov7UFdNGy7ABSzU/IXOLOAiVTwAzhgUWBnWex5BmiY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/ttVX1VObN6wzmuJfN0MDMIALjKnIQuYPt7b5COUNDIxqzZhfLpA4+y3QHEf/3IJlwNeVoXFSrGOWbZcrdVTmEE7adXV/z9HGEz/3ACfeMCVE79npx8pa3fc/KQXkKrPXUPIzyqUnWRmXh7I7D+YcB15bhMqtHJuFpaxnb+ePI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oglug6sq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oglug6sq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 23C3F1F000FF;
	Wed, 23 Sep 2026 06:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143292;
	bh=wgRVOkST1vEaKK9CLCIe2zQdpbfGhK8cfpyuNa05zY4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Oglug6sqDTyNRGIFeXNXcZOixeECJiSoFwmatbMzTxG6UX3rxjdSsxYC430iXR1ym
	 5IJjv9nEzxdqsDLJN2Uod1/P6rgtN7J85tqekgC0eLZZc9/mgDgB/TMsL1o7fPBG9C
	 jgBJ2V21QpdoSzBybdo5/qBALk0BSZwq0lDUS75cgtpqCfp1H1dAgWmyx5UxkV/97c
	 BCrVXAtWWFwTfPhs/VMWRth9V3Besv0Ci47XzaBu+4Pj5BpxKldp9reM00w/6XgdCk
	 0+LW9X5nAe3qctIPd7kuDZBLYacpJYJtYirV+UiiLYira40ZRpDmWureZpnvLRinT0
	 oBFC0dtfIDscA==
Date: Tue, 22 Sep 2026 23:01:31 -0700
Subject: [PATCH 03/12] xfs: clear the symlink zapped flag if inline symlink is
 ok
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159607.1875436.4270560289215383490.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we fail to clear the SYMLINK_ZAPPED flag if an inline
symlink checks out ok, even after a repair.  Fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: d9041681dd2f53 ("xfs: set inode sick state flags when we zap either ondisk fork")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/symlink.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 91d40b9fb5c6d2..ed9ca7f737c3cc 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -70,21 +70,20 @@ xchk_symlink(
 		return 0;
 	}
 
-	/* Inline symlink? */
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
+		/* Inline symlink? */
 		if (len > xfs_inode_data_fork_size(ip) ||
 		    len > strnlen(ifp->if_data, xfs_inode_data_fork_size(ip)))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		return 0;
+	} else {
+		/* Remote symlink; must read the contents. */
+		error = xfs_symlink_remote_read(sc->ip, sc->buf);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+			return error;
+		if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	}
 
-	/* Remote symlink; must read the contents. */
-	error = xfs_symlink_remote_read(sc->ip, sc->buf);
-	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		return error;
-	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-
 	/* If a remote symlink is clean, it is clearly not zapped. */
 	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_SYMLINK_ZAPPED);
 	return 0;

