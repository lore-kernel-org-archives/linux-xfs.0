Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B332D31F9BC;
	Mon, 27 Jul 2026 05:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129905; cv=none; b=jq86k2geyfRedbB2ljjXgrnx/AKLDPEDwuFd5jINmX9NvNeuy9q9fkR8b/AZdRJTbzWZxGRgsukNDZW+STNsXwsl6LTtzDL1Yq4rizhZIauhN/6umcmklhJuOmqHNSkX+dzBjURhdJxoCg8cejwtUMUnr1/R4lXHcNEeIKDqKIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129905; c=relaxed/simple;
	bh=AKRET1zDfCN91HEJR0fO7h2j+zTKs6/PvJUl5+NtJKE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uLfKh+EbkFyhX+KZYDX0p5nG1SB0qs8B0Xz39J593UgOwo5i4TlYdydFZ7xGqWV44WFddvk+tVWJxEntt6CGMkGyL7MwXVwXNJRx0MpuETL5SYp71BJ0YLbuzVc8B/N1NTtmCI8035qNG/4+WXfqP1gjw6HInjTjd2zB0+aa9so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OsOkS6RM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OsOkS6RM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8BA4C1F000E9;
	Mon, 27 Jul 2026 05:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129904;
	bh=Uim7n0QwjvCuqqk7fuOwMH+KWxxilmdxHdHWLeWeBqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=OsOkS6RMzkpEAHaaH6IyF3P1GuY6RePjreRs3MkzboIA0QQdljr+SG5jGExN/82cL
	 vrE50qhbAtW2F3pmqHeOQ4+ea8Jj+gpCkQ9O2PmAy7vFcpbQjX4ELOzBaWMCoHvkwR
	 a7RTrl4D1BakarmQKQOMO1zGw6CMK9a9Nc4OfdbVdL9O8OXY8dy1i6a0Se+McNuFXe
	 6lQGIAMqHFxRKxid0ODLa0GruZoshJf8rADCPHtvrE9QT4XjXPNrPaBxb3AaZBuUAf
	 /6dVN1Mpo3/aF4aVvrEWFeyZSIQ3xGBBPfF4UsNWfimEadvBE0fOd5MivFBY0E4liy
	 VaZC0FrA0NpMQ==
Date: Sun, 26 Jul 2026 22:25:04 -0700
Subject: [PATCH 03/10] xfs: don't walk off the end of a null sc->sa.agi_bp in
 AGI repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389660.1495075.9090296623201887316.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed a longstanding bug where xrep_iunlink_walk_ondisk_bucket
tries to walk ragi->sc->sa.agi_bp to rebuild the unlinked inode lists.
Unfortunately, it's possible for agi_bp to be null if the buffer
verifier fails, so we have to use ragi->agi_bp (which skips verifier
checks) instead.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 13074d5e319cc0..39468b8fa9863d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1082,7 +1082,7 @@ xrep_iunlink_walk_ondisk_bucket(
 {
 	struct xagino_bitmap	seen;
 	struct xfs_scrub	*sc = ragi->sc;
-	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
+	struct xfs_agi		*agi = ragi->agi_bp->b_addr;
 	xfs_agino_t		prev_agino = NULLAGINO;
 	xfs_agino_t		next_agino;
 	int			error = 0;

