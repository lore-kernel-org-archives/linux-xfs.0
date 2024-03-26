Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA057314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423282; cv=none; b=m8PykgDDTZvTRxm8MrczkRmjbgXN6jKigowkIjYAPq3yRYXfoDsaLmoDx9JwVZEciJR8/OOw1kHGOt/mWkRpcQN+4CJnETovI+x/XIMhEijWWILMmnD9/KBMJulwiNGrwK7o1Voi+Tkbkp1k2aa4b6q+d9CHp/kTrqI7sJ6stTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423282; c=relaxed/simple;
	bh=A99JDx4QgR/3W02wXHYxe8MkecrSaw1/RS5vSTBfhvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JupW350B86K2//VXpDmEphCD7YVoIxQpg47eF3aLMPV7LeUbGTD9m7h8P/dbFEP6U1uF+PHrYzs5A3tFkaiIGgGXUBqprB3gKEffTPdnEG9Z5B5Km2DatLFpipa9b9HxixEbsTsDRVNvcWpj3IctFF6OByNW7FIGAbF7kfvFjQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvB24104; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvB24104"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512D2C43390;
	Tue, 26 Mar 2024 03:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423282;
	bh=A99JDx4QgR/3W02wXHYxe8MkecrSaw1/RS5vSTBfhvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jvB24104b0Rw6M8iP0yoZGLbD+C/tLJL2Wgv5gecuRypC3xViWeNVb4XuwL40WByu
	 q4RNJE2T9203xqlTUMhWsyWpi8JUGFD+nVieHVtxzzJ5gwLytoNsmiMFRCEZ8n+oJe
	 3t+ABpekW2iGBKxwM+zeSNIR2xQ56M/vTd2aG5djsgkgCHO8oHMDS1aN+iV/7mGJnD
	 RoFgfbIVwvgS75q7/ut5at/UX0UGQ6Z9JgVfEYiIIPZgjQUv9WwGey5ZJ6aZR0VhXw
	 rp/iWkbXyD79vNVf7zQhADSUyWy3t+D4r062xmdQoou7hhtZKrMODCR5QdsYqgBLjO
	 p80/LjmAoGW/w==
Date: Mon, 25 Mar 2024 20:21:21 -0700
Subject: [PATCH 2/5] xfs_db: fix alignment checks in getbitval
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142128594.2214086.10085503198183787124.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
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
bit by bit if it's not aligned to a 16-byte boundary.  Modern day
systems only seem to require N-byte alignment for an N-byte quantity, so
let's do that instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bit.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/db/bit.c b/db/bit.c
index c9bfd2eb025f..42ea8daf814a 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -62,24 +62,24 @@ getbitval(
 	p = (char *)obj + byteize(bitoff);
 	bit = bitoffs(bitoff);
 	signext = (flags & BVSIGNED) != 0;
-	z4 = ((intptr_t)p & 0xf) == 0 && bit == 0;
+	z4 = ((intptr_t)p & (sizeof(uint64_t) - 1)) == 0 && bit == 0;
 	if (nbits == 64 && z4)
 		return be64_to_cpu(*(__be64 *)p);
-	z3 = ((intptr_t)p & 0x7) == 0 && bit == 0;
+	z3 = ((intptr_t)p & (sizeof(uint32_t) - 1)) == 0 && bit == 0;
 	if (nbits == 32 && z3) {
 		if (signext)
 			return (__s32)be32_to_cpu(*(__be32 *)p);
 		else
 			return (__u32)be32_to_cpu(*(__be32 *)p);
 	}
-	z2 = ((intptr_t)p & 0x3) == 0 && bit == 0;
+	z2 = ((intptr_t)p & (sizeof(uint16_t) - 1)) == 0 && bit == 0;
 	if (nbits == 16 && z2) {
 		if (signext)
 			return (__s16)be16_to_cpu(*(__be16 *)p);
 		else
 			return (__u16)be16_to_cpu(*(__be16 *)p);
 	}
-	z1 = ((intptr_t)p & 0x1) == 0 && bit == 0;
+	z1 = bit == 0;
 	if (nbits == 8 && z1) {
 		if (signext)
 			return *(__s8 *)p;
@@ -87,7 +87,6 @@ getbitval(
 			return *(__u8 *)p;
 	}
 
-
 	for (i = 0, rval = 0LL; i < nbits; i++) {
 		if (getbit_l(p, bit + i)) {
 			/* If the last bit is on and we care about sign

