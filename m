Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405A72264CA;
	Mon, 12 Oct 2026 05:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784624; cv=none; b=PIDfZfpyHk0wQkp2BAmRKiOG8bE1kEiqViqVNcTcFQ7Pd50JXJDRD82egETRsWqRQX5sZVczBlda5k+TXL4OsWSUmzzw8cib5aTKHmI3eDnP9jFV3N4NuSDw79HVfOsGjwMJqowdHxVN3uR59OWfsWVdeEOR1IrYLW6xPOMw5D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784624; c=relaxed/simple;
	bh=R7T3PVnffNbEOF0XpxVVGjtn0/7G9CFFss2O603CffI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GaFIUWiYM3w7cz2KLFggJAw9EuivMtUX2gh+bn+Zggh0intyLVT1vVNbtbfFjjs6M+7Sv0iqVBFcCaHFRR/lmUAvjfruebWqIJZnZwE61PEWQJfwIXeL357T/jLY9TcNL21bRJjq5M7FhrviWV+nfPw1il6zfoNAC2YZk5+p2dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxWQ35v+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxWQ35v+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C26D21F0089B;
	Mon, 12 Oct 2026 05:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784622;
	bh=QMPnxZaoLb6Xqt1SpLG2GLJdZQEOeq71hWNuBct3LFg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mxWQ35v+kILrKXSATWSvcUA1XCXK8q/dOJqvqzH2wjbXr17VHC6v77bx/SrZX2zJC
	 zmfD9KmfYrE+1RYg+3BK9a5IzSGV2kUPWWZ0TUO3//S+/P3JAqSZVMD3+cd7r0MD34
	 +1JP1rZr/GFZkhR6LRP45QbxKuDsq+VURUv0s16GsA5LPojxcRWfepOqRJf5q+x62O
	 yFm7pAiUO/+0BlGIXIj6P5F7rNE4uiOgr68Ok6uVNGkzuZiO1ZzAP8XpYgfF3KFLUA
	 GwNmz+CPvlbliZIuwPRfFn142elQPIwes/s3JV+idZKdQdYkdK+GooMTVGieG2lZvc
	 +gnQsBkMr9QsQ==
Date: Sun, 11 Oct 2026 22:57:02 -0700
Subject: [PATCH 05/12] xfs: don't queue rmap update twice when reaping a fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065302.1058326.9913406199036939572.stgit@frogsfrogsfrogs>
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

LOLLM noticed that xrep_reap_bmapi_iter calls xfs_bmap_unmap_extent and
xfs_rmap_unmap_extent to remove a mapping from a file fork and its
reverse mapping.  However, xfs_bmap_del_extent_real also queues a
deferred rmap removal log item, which means that we incorrectly queue
two rmap removal operations.  Fix that by removing the extra call and
updating the comment to mention this subtlety that I forgot, having
written the code. :P

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/reap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 528f5ef033d608..9377d687d0cc55 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1492,12 +1492,12 @@ xrep_reap_bmapi_iter(
 		/*
 		 * t0: Schedule removal of the mapping from the fork.  We use
 		 * deferred log intents in this function to control the exact
-		 * sequence of metadata updates.
+		 * sequence of metadata updates.  The BUI queues a RUI to
+		 * remove the reverse mapping.
 		 */
 		xfs_bmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
 		xfs_trans_mod_dquot_byino(sc->tp, rs->ip, XFS_TRANS_DQ_BCOUNT,
 				-(int64_t)imap->br_blockcount);
-		xfs_rmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
 		return 0;
 	}
 

