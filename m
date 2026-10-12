Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58697345CCE;
	Mon, 12 Oct 2026 05:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784577; cv=none; b=FvpMgWHwiNNh13YMwBykOPr0MOEE+41xvjF9qGfTru6cdtsaXqhCOXjE0sMu9PMXC67gUwudR+6ERO3R8hhitdbpvDxmomsyES/BCWIbDzbiFL5rcZxR1CibOdCKtOZjWsKM5Rw6bq5O3mW4oiLusNRwQhUh24mwFspjj01LX8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784577; c=relaxed/simple;
	bh=ik6Wplp/miRsN5iEc7OJN2vQ1GAPYJGj4ZaT72zbBEI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G4NGgH9hCKijVSA5WYgOV6wZRSmff+jrE0x+l+7wRnaWCb1K0EmL+NFR/AJKhf9IwxufpOe6xoXYPHAHwlfAlc7SXHZL/LnxvAymOMOzXrWJoODkF8RYV15UQgINl70c9XLODEgmY+wXy05J0oY3iDvp0v5XOl1rHFO172rHzDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvj3N4np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvj3N4np"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EAE681F0089B;
	Mon, 12 Oct 2026 05:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784576;
	bh=EPIN9fgZnFIk0yJYGUwNkKbXvu3mp5CyMhlBpPA0ugg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mvj3N4npEM6sq6LBryFpF6iEMkWqLELwP/UjLRse0lqMHLB1GcNeVu8+RagG555j2
	 IO3ti97HwjLKfakvMNrRDA68RiSo0rGfO4FWhOUItAwc/2wH+hJjq5aolp1VbERE67
	 ZhfTFnKdYaKr00yYl9R9rWkzOEp5b+T+0axLJsNWTtVA+c4STNkXkiiaFUFOgt3rn7
	 UJ2ZksSSJsZZE6yT5wqT/IXfC2/Wmz2V+c6URHj1qCAEvz6poyBm/odochMkSuTdSH
	 TpnOcCXFMVMHed0YSCPkeVdPGnXH+y3/wa+L/2wZWgj02/F4zJCof4pIlkh1rqjpGY
	 zm0KUHvQ+TzsQ==
Date: Sun, 11 Oct 2026 22:56:15 -0700
Subject: [PATCH 02/12] xfs: fix data fork block count check in
 xrep_inode_blockcounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065237.1058326.4317771576749891941.stgit@frogsfrogsfrogs>
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

LOLLM notices that for non-reflink realtime files, the @count output of
xchk_inode_count_blocks includes both the file blocks on the realtime
volume and the bmap btree blocks on the data volume.  Therefore, we must
compare this value to rblocks + dblocks to avoid unnecessary failure.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index de3c915984290b..89cbf599795b2f 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1719,7 +1719,7 @@ xrep_inode_blockcounts(
 		 */
 		;
 	} else if (XFS_IS_REALTIME_INODE(sc->ip)) {
-		if (count >= sc->mp->m_sb.sb_rblocks)
+		if (count >= sc->mp->m_sb.sb_rblocks + sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 	} else {
 		if (count >= sc->mp->m_sb.sb_dblocks)

