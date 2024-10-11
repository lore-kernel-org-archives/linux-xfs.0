Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E30FFBF0
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610156; cv=none; b=FjN4Ew51/5BkhWYaWgHO1HQf9bv60SCfKSSHIXk+23SgHisoXP9bmZJvwSeeHeQI+gXWb7FWb2QiH9s/RENqhVE0PUFVsNTW7flMhjm2UcFQVuNVdHhpJq8ekX1/lWmrS0CIJVk3W2DYI+MQW7rZ+D4uya+OZGydIJCESxFbtX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610156; c=relaxed/simple;
	bh=xisEZMr+PsB3Pp3JjrTMOUJ6uzs81WJra3MhWl2q7Mw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p30j0/gIMO4gaylAmqyEmJtEwNAUI9V6wjka5v5+MiL/3mJ5T1k/gA+W82/O3Jb3japt80Mudgh2OaZ+N1xOS6GINX7SLPUn1kPwAn44M6cXl4zwJd+GAWxSZDljJsDh0zfweW/urWJxw87rOjfRT/Q5VRnmhQKRmPvpJoWDVvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GM622dww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GM622dww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A45C4CEC5;
	Fri, 11 Oct 2024 01:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610156;
	bh=xisEZMr+PsB3Pp3JjrTMOUJ6uzs81WJra3MhWl2q7Mw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GM622dwwUfPNxWN1BYfecCKhFvV/xpUKr12EoI8/BCkElQ+NYHSy2Qw/sr6txOiD/
	 8ICj/lRZvzTSCxu0UpUXqZE+ZFxGXJTlmEc9jmDqRutvoBmsAxNpuzRLB/KPpgna4r
	 7HmrcPo9V6qEPBSDD4ahrDiuRrOvh7luWMFngkBATDmMZAD8be54DWmhvOhD+Ri5y8
	 e7F1+5QwjyCHEmct/aYJ0SVo0WkqQG/MYCYfpoJcceTko//dpG5+WD1XtQA2BFmClu
	 XPtMHbGD8Rp5sQFe6l9OHtP+ToKLVj83KMYuIre/qVyAQeFfTTBsKwQY8ywKmjH/Ju
	 lmXqBX88a89gA==
Date: Thu, 10 Oct 2024 18:29:15 -0700
Subject: [PATCH 18/43] xfs_repair: repair rtbitmap and rtsummary block headers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655643.4184637.15421149966849753789.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

