Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B163388893;
	Thu, 16 Jul 2026 06:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784181984; cv=none; b=eFUT78fNUy+z0R1FNOjP6h7VoJdwOwQpjcEEMX84ITFysHKw7WzGj6lrcPBG74VUvJjSV0rDzmCC+clYbTnYI1BvAFy4F5tPNWw7rk8pH5XU/rdBbfpYKZrWTyhClCbdieh9Kobwq30Uzc4htRxl1M851cbLlP+29DFhA5EerVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784181984; c=relaxed/simple;
	bh=qipjDGyEsjX+g19E2JivBIZz87wYHqdASVcvVduwYlM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Arh4Xwrj73wjgRkpoxLZBpD/6As91fq9gz/fZ8qn/HQ/1en9D1bQTEdezcW+hg2V0NvsAnyZN0ehfV/y5NDC8HPVvT7tE3vDzKi0qGZQ7JHX4RCSHFWBsd85PgZX0ugMB4jwWZUdwqE2PvtpgLgu+pDX6UsUq8RdrI+hnCinV7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEQ4dsOG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEQ4dsOG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 038C71F000E9;
	Thu, 16 Jul 2026 06:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784181983;
	bh=Vs4LCFxDpToIZBAXxJbm8s2FNXDQdGXOuhIqedwojz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AEQ4dsOG8L7+Gyou22kk7nzRtaQ6cMuZ+vacYOA05e8WYvtNfRi5CqdmK3lPWPHTl
	 23zxy/z9Ksel9QhvsJhcgoeXINlPwa4LjpFe1cXkxIIcQAVwE1EfJ6fWfCk6npG1ED
	 UdKNVW1T/ONDcR/UbrlQ4oAUAYP7e5wlUKbKHZa9PaBEPwbx1xGzYDchJYKH01Iiy3
	 oyQKw6gmJPiddumuenSEskPwpZduquNctyMU2RrA/9AMH4QPNyjxCVMwHxpFJgZs36
	 3PShZ2xWwjLCevETQeoiPr3t3PbgnpjsbFqBjibjWoP54uOZB2aUTmP0ku8Ca83SF7
	 KJmBVgDQcX4Ow==
Date: Wed, 15 Jul 2026 23:06:22 -0700
Subject: [PATCH 1/6] xfs: check cowextsize in xrep_inode_cowextsize
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178416797381.2008054.6629007049464918838.stgit@frogsfrogsfrogs>
In-Reply-To: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that the function that corrects cowextsize should check
i_cowextsize, not i_extsize.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: a9600db96f74af ("xfs: detect and repair misaligned rtinherit directory cowextsize hints")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 3ec41c19835116..b88427a4460cba 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1960,7 +1960,7 @@ xrep_inode_cowextsize(
 	/* Fix misaligned CoW extent size hints on a directory. */
 	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (sc->ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+	    xfs_extlen_to_rtxmod(sc->mp, sc->ip->i_cowextsize) > 0) {
 		sc->ip->i_cowextsize = 0;
 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 	}

