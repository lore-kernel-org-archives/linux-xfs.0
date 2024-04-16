Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6350F3D7A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229146; cv=none; b=RFeKQwiJPfci+8HwEGUfAsh+eZ2Wbg9ZMpKv1nJSX8pABMcgTvBNhJIGdRBVWArtCVJoZRyjO+8wCE3bWcRCzihzvQlvfhfETt1XKkWCBbkmXxO6m4E3dan3l+sgJmLgiqnXyt5CHfjj7A8XfO00fF1kXOW0wvtEtWlX+mScFns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229146; c=relaxed/simple;
	bh=ALtMPjER6NZRFXNZRanYmio5DePN9PyVwNRnPsT+Q0c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/gpRM/jvKAf6Qq01w4gfItU1KJKa17Yl3VVK2cE4thaER0WcIz4pFmi2ZCtbgP32E+QWJ4sPbYE0mD00P/wRPb5To8LSm3Hz5OUn1OtqDKhJBYKrTkWnAx2qA/gnARoiykSbWNPOp4X4HPF4ySCH8cqyOgcvc/f5DT59kCRKQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lp7tdVmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lp7tdVmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5B8C113CC;
	Tue, 16 Apr 2024 00:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229146;
	bh=ALtMPjER6NZRFXNZRanYmio5DePN9PyVwNRnPsT+Q0c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lp7tdVmyvCDNpI8EuH5tlyos3zeRXJmXlUc+Y7mAaLPkV1iO0nD2vy07hSuFEbqfn
	 PvzeUZFxb+bZS2Pm2yqHGU5uq6Wa/pJYJCHKgEaY1xWKmiPrNysdMmN5QLZ9lcpuRY
	 Q7DvRmOnZ5XmZFTTPl46vzbGYOr17MACz4HKU+JyO2lNtZTJiINspa56L37jXexyo6
	 kLwUDhlvaC1yBvexQ/Z/4J2g1yVjca80sqS4rVRp4jMZyQIUHFHanaRx52LVWzGmFE
	 gq6Q67JI/mL2CrajXCr2L4lzjKMumWSvnB+p7ScS3HWbVQGz8Jd2a2xQs/psaf7OIY
	 bSqhmt+Zw3Tgg==
Date: Mon, 15 Apr 2024 17:59:05 -0700
Subject: [PATCH 2/5] xfs_db: improve number extraction in getbitval
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322881835.210882.6715743182101731750.stgit@frogsfrogsfrogs>
In-Reply-To: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
References: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
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

For some reason, getbitval insists upon collecting a u64 from a pointer
bit by bit if it's not aligned to a 16-byte boundary.  If not, then it
resorts to scraping bits individually.  I don't know of any platform
where we require 16-byte alignment for a 8-byte access, or why we'd care
now that we have things like get_unaligned_beXX.

Rework this function to detect either naturally aligned accesses and use
the regular beXX_to_cpu functions; or byte-aligned accesses and use the
get_unaligned_beXX functions.  Only fall back to the bit scraping
algorithm for the really weird cases.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bit.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)


diff --git a/db/bit.c b/db/bit.c
index c9bfd2eb025f..1b9ca054f3b1 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -55,39 +55,34 @@ getbitval(
 	char		*p;
 	int64_t		rval;
 	int		signext;
-	int		z1, z2, z3, z4;
 
 	ASSERT(nbits<=64);
 
 	p = (char *)obj + byteize(bitoff);
 	bit = bitoffs(bitoff);
 	signext = (flags & BVSIGNED) != 0;
-	z4 = ((intptr_t)p & 0xf) == 0 && bit == 0;
-	if (nbits == 64 && z4)
-		return be64_to_cpu(*(__be64 *)p);
-	z3 = ((intptr_t)p & 0x7) == 0 && bit == 0;
-	if (nbits == 32 && z3) {
+
+	if (bit != 0)
+		goto scrape_bits;
+
+	switch (nbits) {
+	case 64:
+		return get_unaligned_be64(p);
+	case 32:
 		if (signext)
-			return (__s32)be32_to_cpu(*(__be32 *)p);
-		else
-			return (__u32)be32_to_cpu(*(__be32 *)p);
-	}
-	z2 = ((intptr_t)p & 0x3) == 0 && bit == 0;
-	if (nbits == 16 && z2) {
+			return (__s32)get_unaligned_be32(p);
+		return (__u32)get_unaligned_be32(p);
+	case 16:
 		if (signext)
-			return (__s16)be16_to_cpu(*(__be16 *)p);
-		else
-			return (__u16)be16_to_cpu(*(__be16 *)p);
-	}
-	z1 = ((intptr_t)p & 0x1) == 0 && bit == 0;
-	if (nbits == 8 && z1) {
+			return (__s16)get_unaligned_be16(p);
+		return (__u16)get_unaligned_be16(p);
+	case 8:
 		if (signext)
 			return *(__s8 *)p;
-		else
-			return *(__u8 *)p;
+		return *(__u8 *)p;
 	}
 
-
+scrape_bits:
 	for (i = 0, rval = 0LL; i < nbits; i++) {
 		if (getbit_l(p, bit + i)) {
 			/* If the last bit is on and we care about sign

