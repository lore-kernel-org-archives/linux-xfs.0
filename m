Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343EE2BAE2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390019; cv=none; b=tF0B0VNn1aIyHdqcI7CpCqj7JYWU2sXOw7SloyY9BRtoBOQQtddBQbGRdEv3qi6hvZYz/BTjz3KVpWg6pzODq8231b5lYFB5m+yq/56boP+oIpohjrdSpMGEnmBAO/iB0wde7WmUJ6VUvaf7BZ31OS98sZc/Xc2SlTKRlaJbSgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390019; c=relaxed/simple;
	bh=nKINfQjIBvYvXJ9KasYywQZ0dEsCjqlEK21IHApGVSA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COAZU4s6gj/5qBkkwK9PFsi576s7Y1MyUa9oZSfGfLvma38UwwlWP0R23YmCfUbGYkIZEIxVxanesCvOjNcYjo0C7rpq/Ef0c8bkEjPBX7WlGMfJ/tQV6aa2PdQYjfAU5ugn2sdtu/b1RaqS6VfZgq64/ZP0DK2B7ohJdn2DHqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNNyutnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNNyutnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C262AC072AA;
	Wed, 17 Apr 2024 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390018;
	bh=nKINfQjIBvYvXJ9KasYywQZ0dEsCjqlEK21IHApGVSA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CNNyutnCcBqTSa8JZeQWQUXmYR+PBRD8J94hwurbNEcnspucruzvBxqd+O58ssHzF
	 IZRKNOjzbx21D1BivHi6I7fjvyGmH7cV4Tt6jhLYCjMpyIL+wiGA/Tp/INwA2AKkka
	 LAAN7maVjA0oF6pz72ytMaCwKXBfQXrfQ9v/tnIB3jnM2+7q8bGCrgntXaLSIvY9ez
	 TpzkNg/FQa/UZYDfZW3PDCYqwVeCZTp2VlMsApeR26muafl2KHZ9HGwGqKZzotV8EZ
	 z9BObPNr5Z5FRxOdCPnu4SZI9/4xRAojL8HspUWnVIZBYoDU/Hm3+hQvXuYt5KVJJO
	 Mfag+XGuOEO2A==
Date: Wed, 17 Apr 2024 14:40:18 -0700
Subject: [PATCH 2/5] xfs_db: improve number extraction in getbitval
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338844009.1855783.3559063058372490721.stgit@frogsfrogsfrogs>
In-Reply-To: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
References: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/bit.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)


diff --git a/db/bit.c b/db/bit.c
index c9bfd2eb0..1b9ca054f 100644
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

