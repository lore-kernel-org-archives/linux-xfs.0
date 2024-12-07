Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3F2CAB
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530256; cv=none; b=UMiPJ+RLlAP1Oz7MR/Ef8wv+bHqxW3b6TB3+8prVfzwSwiW6B8011NuUPkc6uiuK+B8UnpfwfDTBq6VpC56klmwcrI3ykhwmjrFax1MrE3XDuh+pG4t9HJsxmGZXTHmpGdSKkzatsehptIwGcu9FULRFGQRPkdBi7eNlmMOXYeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530256; c=relaxed/simple;
	bh=dhl8u/opL6FLMrT1ONqoSb5eZOtIG0eLIZw5Z1izmmg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYi8YFzX321+St5ojqlBxslKi2ihr/OxZwQcAxRRPhqV109nAgE9jexkEfFtoxVLnQmq8MJK8ZyHaxWqZSVDoqefkeq4OQUNE+xBUTXOzy7/qqllTngxz/5Cjng79l2NfbYy2J7BGJZlRMRKQ0Algt9m6yAVZuOz3r+WNSDYSH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPDZ+j2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPDZ+j2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3145C4CED1;
	Sat,  7 Dec 2024 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530256;
	bh=dhl8u/opL6FLMrT1ONqoSb5eZOtIG0eLIZw5Z1izmmg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OPDZ+j2F7pEusQ0AU3SvSNCXP2iHeOMMMmoDRTQhtff58VTtYBPi7i3CTUAfnkF20
	 RIvFBijAy5olV1UNLwUy9mIf50t3WFoQ34aIg+o4qhpxpj/Yt4uax05Kryko8hawtA
	 38CXDVF1lNbZt/TMa6upA8Rw1M8UzhgwzHy54patsVGh7UdsYkMG02ZCYRfLfxvURi
	 eVwKVEShb/B6L3fx0+kGu5/33A4q9j9ny92ZoNoaNaxQzqI5lVFdp+88Uw+auYR/W2
	 9Qz2ImE9i126iZzMjEbN7Iug5wzDlBjVhkX3VY4rMu0IeMm7QNZpvlCwAMRjIV0Fa1
	 frk4fLATX8Ljw==
Date: Fri, 06 Dec 2024 16:10:55 -0800
Subject: [PATCH 23/50] xfs_repair: repair rtbitmap and rtsummary block headers
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752296.126362.12671784441675621141.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

