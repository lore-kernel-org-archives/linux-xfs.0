Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DB85915F
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797421; cv=none; b=DgVApazC1ZFw+CDivWTY4wPWo0mtVjq5kaRrpxy7cDxyWecHpUfdyOSWHHN9sFV09Z6zcO6gZGULEZbh5Of8vqek7hQoYEbHPfpPht/IlgZtx6XmKjSG5575g+h3tQaxR8FAyRaBbp+vwjXpsrroTZc8h0328iUwXAzebD2/WVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797421; c=relaxed/simple;
	bh=A99JDx4QgR/3W02wXHYxe8MkecrSaw1/RS5vSTBfhvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgUi3WntVez7Z7mL6ua46RtCEQio4Rj2ZAVnoPLMM+C8oVy0r0loDq/o1AmSW1Pq5rGtdySH6M1+MLyqLDZBC5Rfwb+MrABfNnjupeg05y6je1gSsX+QK6KNwx7zD8DocJc8xpOt76caN1Jh18p+n+95wkjNs1Ir6/sgBX+cl9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/BixPWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/BixPWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD46BC43394;
	Mon, 18 Mar 2024 21:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710797420;
	bh=A99JDx4QgR/3W02wXHYxe8MkecrSaw1/RS5vSTBfhvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f/BixPWipsmb8XvpxnW35MClPqsQUy7Ta+0hCuAofMgnp+rokeU7MHcEqQuNu53AR
	 ajHV+b9grtotAN9vxdj9YB3R7isdP+4QvGEHSN+nQq9LnHMmc57iNgXIYHwaPC5R2J
	 7bxpZPKbud8pOo3pFM8nbkoRckFW87x356oMcM9kIZnhhTp2thpbMLNRrfpvEkczyU
	 iGxo0G233rBqmDQcF8x11QdO7ZtDqbgz0NtdBWkVX3RNXKBvL//HhL5WRREUKv/zlG
	 Lz5fJccPPjdcntbCM1pkeaU6SQSJ++ayL3A6UNpSsof7+pSbghLInW1z2ujkCAu/Gm
	 1kfc0eqk1rVxQ==
Date: Mon, 18 Mar 2024 14:30:20 -0700
Subject: [PATCH 1/4] xfs_db: fix alignment checks in getbitval
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171079732990.3790235.13146250511500557326.stgit@frogsfrogsfrogs>
In-Reply-To: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
References: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
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

