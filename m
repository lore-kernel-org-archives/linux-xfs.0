Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3541D48EC62;
	Tue, 13 Oct 2026 06:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871592; cv=none; b=UhU3+YGp2MYWLsLTgIXs+TNie40eSWundz/bbgSuxkExudG2sJjpEFVYc/IcUBuf54BXGSeeFHF6pC7z7+EbcJUszRkNTLELmngZGf6ZmQL0a/xyIacnVbVPST/QUAA+sw6/+bc2pQKREu45w0sXJQrQicJpayBKyKDkveRyy7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871592; c=relaxed/simple;
	bh=0L0uCL15mNtKPSW3nswZ3Lhy8T+cRnP1uwdCB4GZwsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GNeAhKrwxUib1k9m2LLZk8FHQQwGZZo6488w6feIPduZTlFXmcGnO+zmzuXCdowA2EjVtuI1Hvo+Tdp988nvSI3CYDYORc9syQ0tch3oeffrkRJ74SNJZFJTg+bpfn8ib6tVIUplnojgUk0orWZY7v0x+0fBM7B1dBfxfWNn8go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CyaYYKuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CyaYYKuL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0C28A1F000FF;
	Tue, 13 Oct 2026 06:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871591;
	bh=FdfFcGzS0YPYAqSXGLwLmMKGP9uMW6W6WIAv/4YuLg8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CyaYYKuLX/R35PWfQKQiwc5v37NxSr81tRVv8Z57NB5Z7ws6zBXpjP/B6fmCdH11L
	 sGuvFMXxVQzf7pO//wLeOhwFF/hn3Lqs1ppovkjx1P8ZfyIQJE1GGgrCP/InTPzSIM
	 mIwtiDKpX3lZJibfJswWmQN4Kyl5oBupii1lrxIDCkvOX22844lTsWb8Kinvg4Idun
	 g/g7PKq0H3LYUCtEq5p+IstakuHnJfyT5ZP2Y10ueQhux8OhjqUylWsyO9jiUkUk/+
	 DxutnHC1NkWxKAbHEngj7yd6uZf3WUNZbcUxubfUUXZtIs5M0LI7a5ITVEsh8pXsNz
	 jkqJS2glLSFyg==
Date: Mon, 12 Oct 2026 23:06:30 -0700
Subject: [PATCH 05/12] xfs: don't queue rmap update twice when reaping a fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107246.1898400.4017190160808965345.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

