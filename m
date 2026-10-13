Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943AA4915AE;
	Tue, 13 Oct 2026 06:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871639; cv=none; b=UeiyP+jWYQbrmwYEfGv3HCYQxl1si1FOm+oZ0ikKnf+okapFAB4V7Tm028n1GXodxrDWtXXJbeu/KVlFsFxY/uAfiTHzhXfQyfAQ525alasswJm1bT/YDGEcrKNDFpFM2V3Ue80/kh4XFTQpAkKCkE5W2A2xXPgdapIP5FIk2os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871639; c=relaxed/simple;
	bh=plS8QoIrmTiTkdtIzojdlXWFxVdh4XCwZwPOrihbxj8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6UzxI0j1ZSrmhAMr8PUMSXS1lZvGZNL8+t2V4JmIJAAEkJSDcKM7rPlM/cmuqGgXWGDLPuUuEjUouldaICBeXi76klePXOuSdddtBh979HSQk7smsg+4zpgOJzuCe0wlKeStWcKh6YW5n4E+bEWaIsPUzMtA6pl/hRfapFE+lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsUsSfdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsUsSfdv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 174131F008A5;
	Tue, 13 Oct 2026 06:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871638;
	bh=X+WdAgSHx39rJODPGvnPEN+8iQ9pyPVKoo8BCHLTZrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XsUsSfdvHWCoLcupZWq+oCakD0ZBvUi/iKWXdhiwGoR+EONNRuaVkE1bv6/4fy3Eo
	 oydCvjvBsJ2X++Rmi2jzpLzqgy7jPG9cMNghtWBJl80NsVl7PppWL7kRXDqEroTb/g
	 BduxJkRtK3ajh8WW0f0NaJNbZlmtPFEE9H9zfOjtgJQiu5ua3FeCBJ+uUjK35QjViz
	 Mx2edG/VlF/GLKU4mpEFpi6XmWhBHvSlQCcb0l+Zm+r1e7v520eib6FkAiZvw/e5rK
	 +M706CHUEh/Gofu8RGXO25oiR2cL8CygKkicIFMtAEcEH4vnfXmlxMBeVS+LXXO28X
	 RJKGCCi/JvKSA==
Date: Mon, 12 Oct 2026 23:07:17 -0700
Subject: [PATCH 08/12] xfs: don't clear COWEXTSIZE on directories on reflink
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107311.1898400.13638917082115866545.stgit@frogsfrogsfrogs>
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

LOLLM noticed that xrep_dinode_flags clears the COWEXTSIZE flag
unnecessarily on directories on reflink filesystems.  Directories just
pass the hint along to new children, so it's valid to leave the flag
set.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 89cbf599795b2f..4b719ad64ace8c 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -565,6 +565,8 @@ xrep_dinode_flags(
 	 */
 	if (xfs_has_reflink(mp) && S_ISREG(mode))
 		flags2 |= XFS_DIFLAG2_REFLINK;
+	else if (xfs_has_reflink(mp) && S_ISDIR(mode))
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
 	if (!xfs_has_bigtime(mp))

