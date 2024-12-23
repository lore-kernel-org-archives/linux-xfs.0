Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DEBEAF6
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992266; cv=none; b=Q3RxkPLFpIUhxVbPv4Oo5Q5+mO1NTuUY88Du1cOl2R5fjqmz3pZKFBGeP8sNXi55Ss/Z5J647pWEmw2xV83z4TDjqfxbvJzNzEH3wVsiHn7yGsUQu7ANT03Qgcl6WMWTgxAEXS8V0uizuujjzr6dveetFJqov7cHcr4v6fOOnAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992266; c=relaxed/simple;
	bh=C9c54xMZS4RDFq0QErlWbWEj/pgtz1IP0Z+ESBVZSKQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAhcn49h4lrcHGj7Y3VW+251n9Z//4lnQANHA977DfedXxobgE9wXXtK8OvyMjRhjGk7ddJaiPrCYPax7Wz8CUpdfev4ATTg1HxvGoaw4Vb16G7pjxJ9AW9+IFR1I2/sKLcaIj00RKKQ76IefRNj9PDe9p6wXK/L7AFUsg7jei0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYHhPPKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYHhPPKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE443C4CED3;
	Mon, 23 Dec 2024 22:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992265;
	bh=C9c54xMZS4RDFq0QErlWbWEj/pgtz1IP0Z+ESBVZSKQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FYHhPPKBY4B8Bxlth1TPzEinEEKxuLy272l0VCpbThym7P80YQ4d7fnEjU4SKHjG0
	 xCNPKGiSnfuqIy9/Z+X1Fhrm+CBXRPBb4DFNcGL6TW5rPNwZ2PF6Rz2fFH9KAT5HeR
	 Is/Pp1/EDXnmmbDlZo5k0vcf3XvPlrufGOmOPd2wNNcHLAhsvvMOqr0HxdeXsxhHPT
	 NgtasTuDUab32gN3rsn9KxJ5fZ00j14Pz80JphGQqHhjYAS80OaZ7gB3Hb4Dw97Ufy
	 eGXFdOYg6OicRBbPBhlK9sYM6szd1JOkBkNTnzb/FXN0MBZXb7ZEAfQ5m5qzrkRbdw
	 Y29k99vXennOg==
Date: Mon, 23 Dec 2024 14:17:45 -0800
Subject: [PATCH 23/51] xfs_repair: repair rtbitmap and rtsummary block headers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944156.2297565.15780880230505091475.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check and repair the new block headers attached to rtbitmap and
rtsummary blocks.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/rt.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/repair/rt.c b/repair/rt.c
index 102baa1d5d6186..5ba04919bc3ccf 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -237,6 +237,7 @@ check_rtfile_contents(
 	while (bno < filelen)  {
 		struct xfs_bmbt_irec	map;
 		struct xfs_buf		*bp;
+		unsigned int		offset = 0;
 		int			nmap = 1;
 
 		error = -libxfs_bmapi_read(ip, bno, 1, &map, &nmap, 0);
@@ -262,7 +263,19 @@ check_rtfile_contents(
 			break;
 		}
 
-		check_rtwords(rtg, filename, bno, bp->b_addr, buf);
+		if (xfs_has_rtgroups(mp)) {
+			struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+			if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+				do_warn(
+ _("corrupt owner in %s at dblock 0x%llx\n"),
+					filename, (unsigned long long)bno);
+			}
+
+			offset = sizeof(*hdr);
+		}
+
+		check_rtwords(rtg, filename, bno, bp->b_addr + offset, buf);
 
 		buf += mp->m_blockwsize << XFS_WORDLOG;
 		bno++;

