Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660511C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422358; cv=none; b=r9HamtuXOLFBxGkyj3m1DCyyVxG5/7sEdjDnzzQHu49zMnX/UdOpcuYg7XLBL9WfL0wVq9gHsrDn4jOinqfcGiw6BZ2OUWcskVRkCt/FDjStYppfVVthp2sS54XFNxVlbpOdN8PgaLJ2zHTEnDSQpDVqr8C/vI4F1t5o5HhSXJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422358; c=relaxed/simple;
	bh=i/kvh14IhRgXAFXZAz2yd6Mi0s50tf+vSLMeUfv2Xpw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Us7i9TqAbQ1cvrYLAHr+cSTo14iBGCk8sdSzrE/Hiaj4hxbmBbEocZTY9n7wL/espycZhcQ/SCXLbuI3cArEuiN8iNbQuY3LHJPS0yL0AobI1y3+4i8T07M+Dmd5E3sRvfv84gtixRUIRy92ymiKtxHJzmxgvHd3b9kKu7EG4h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vk9B0bi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vk9B0bi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF66C433C7;
	Tue, 26 Mar 2024 03:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422358;
	bh=i/kvh14IhRgXAFXZAz2yd6Mi0s50tf+vSLMeUfv2Xpw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vk9B0bi6681MEv1yDYOBb0pwPsYmh08U8LUjQfQZw9YqQsDNhdE+PwSpe0jSMEIJ7
	 FtNrqmC5SR9lB8QhcgOA/3X+qZGs/3iMM2onKjYOUNbsqvTGYJmnAK6ggns42vReuN
	 imJRivR5N71BCudaudfZO2P5Mf6deaFXLD8tA6JJAXBijpUu27VVVn6iS37L7JedPo
	 j24A3Gf9z+0UnKemKwA459k1MKCoeVzPz6T3H5ZPFZgMxt7a8MkKFjZWeFiIWXVLYO
	 CgzArKBZFAw8r1C0W5YZFPjtK1oMd/7Jt50O8upKp636wNYCyQA4U6cfLmMoO3tvis
	 lPfDUCnKkx6zQ==
Date: Mon, 25 Mar 2024 20:05:57 -0700
Subject: [PATCH 12/67] xfs: fix 32-bit truncation in xfs_compute_rextslog
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127136.2212320.5925831602467629783.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: cf8f0e6c1429be7652869059ea44696b72d5b726

It's quite reasonable that some customer somewhere will want to
configure a realtime volume with more than 2^32 extents.  If they try to
do this, the highbit32() call will truncate the upper bits of the
xfs_rtbxlen_t and produce the wrong value for rextslog.  This in turn
causes the rsumlevels to be wrong, which results in a realtime summary
file that is the wrong length.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_rtbitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 90fe9028887a..726543abb51a 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1130,14 +1130,16 @@ xfs_rtbitmap_blockcount(
 
 /*
  * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
- * prohibits correct use of rt volumes with more than 2^32 extents.
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
  */
 uint8_t
 xfs_compute_rextslog(
 	xfs_rtbxlen_t		rtextents)
 {
-	return rtextents ? xfs_highbit32(rtextents) : 0;
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
 }
 
 /*

