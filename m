Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613533;
	b=cfJdhml5RFXl180fzwsfKwWIQM6pqiPOBsqMDrWmL1JnWBnfA0YN98xdCVgKoLGVJejR
	 5O56/sPAwcnJuyUxTV/lI0wWc3I2/el+qUFCAAJd/pR/DHLDO1S2ED79K6qp6c1xAesxJ
	 /VaYgECEcwuRghaEOXjmWrKTRFXjBg4SDu6tHF094/ttFacy1NtFoZVPRKHtpPS3LUfBu
	 bdBGoOCbBPvk8FR9uGcZHRp/D47XQ0QS0VDMB8vkS5tze5zS9I/PxwVmkdcYJ5vtg1hme
	 KyVDWIP295AUZACEWINfneJacn4UaM4ReAGmrUZe3zTz0BB52JnM/QUoYyhFGg9aq9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PCdnJD0xJk+LrDGLHGrRYeT85fqOhY1wR1tEr8GB5+M=;
	b=n4KnZX364zHn9KAeZpF+neS8yEab5zI1bVeuUaBF9AMRWFqySIVtUg5ebJoMqiJWda9Q
	 yAFJCKGgpHzkX8W+8T0djf6Fw3azHfjQQp1/f/5qpeXePN+HVxS+9sbKAjOz1UURbLcBH
	 rlaFFtex+Uv6Bhd5hM7WPFiUW6twyb/0kal1lKReKmxjgZDrGkCvEigPMBXNjf3yTHbny
	 0z1j0gNZzx92b4Z69+QsUbLrhbocRnLIJHGvFjfWXp06s9DhAe7/feEP+VBneMlYxoNOf
	 7sRhCZnA8UES7HYWbRGrLRpzlSkKMTWop1bCdVzwKtoi5bPbrZzbOIOhy10I1EjHwVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwhC1eqX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E93606A323;
	Wed, 25 Nov 2026 13:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwhC1eqX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71981F000E1;
	Wed, 25 Nov 2026 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613532;
	bh=PCdnJD0xJk+LrDGLHGrRYeT85fqOhY1wR1tEr8GB5+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwhC1eqXt4NdcZpKEqS4JSaT/7rQRkOHPWLLrcgXTCf3Ms+et9Vpt2Bc0rWKenrpp
	 2lhYmaPDc7jgZ4VsiHEpFm4k2LrytDu5/XyKAFHwh6hkTdNZ7Y7z7r/leHII0mfREe
	 Ap8oB9Jwsq2Nvd9hzSxrxLlWR+sDatHW2KYcGz+0+PIhuTlXpSIkMGMVzq3aIfRBk7
	 4XptY+0FRmJUWAkj3zsiqanSoHsr/2SB6QdErDLzkNbXr+26rMnht2erqGfJxknj44
	 G6fyBVzqVTNr2mqGpyFIem5Or4DPLMue4hbmgqR4kqxS8u6gO20/KavIujHLyHyn/j
	 Y4rdmbGC7a6Ng==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] xfs: move _right_neighbor_result trace before erroring out
Date: Wed, 25 Nov 2026 14:31:46 +0100
Message-ID: <20261125133204.113558-2-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125133204.113558-1-cem@kernel.org>
References: <20261125133204.113558-1-cem@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

The tracepoint doesn't help much if we find an invalid right record.
Move it before we validate the record so it can still be printed even
if we end up jumping to the error label.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 14aef87837a9..5f88aa9f12cb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1082,6 +1082,12 @@ xfs_rmap_map(
 		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
 		if (error)
 			goto out_error;
+
+		trace_xfs_rmap_find_right_neighbor_result(cur,
+				gtrec.rm_startblock, gtrec.rm_blockcount,
+				gtrec.rm_owner, gtrec.rm_offset,
+				gtrec.rm_flags);
+
 		if (XFS_IS_CORRUPT(mp, have_gt != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
@@ -1092,10 +1098,6 @@ xfs_rmap_map(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		trace_xfs_rmap_find_right_neighbor_result(cur,
-				gtrec.rm_startblock, gtrec.rm_blockcount,
-				gtrec.rm_owner, gtrec.rm_offset,
-				gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
 			have_gt = 0;
 	}
-- 
2.56.1

