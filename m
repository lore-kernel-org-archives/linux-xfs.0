Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627009;
	b=wclGbyoFIeooCCjJnTadIxb+Q2oS49DTZz3rOlUCymNQzsov/UxRRTL7Rheor21wJ+x5
	 n/1Ibevz80nM57i/i9NTNnvwuFm9NqEi7ATI0scHbjVfZ2AsSZ6zBDhL2WzDFlsyonsqB
	 id9YbtIQ2gq0FCvVdlXULvwEPMVE34B2anuLzKUNZZ8XkSpciQ1blxUmYEAe1kjFzBwhk
	 caF2xb8HW7JdAlKnHEsbDfZQ0lUYeQ/4iWCJKr0XVLM/wjHMRtS9Ex/rWcYmRt9uR53S+
	 b6v0X7EjiXdmM75F+P5AItaNPcYbyItqGG/RDDtxlz0nqs0AG0AxzGpsTQKgborjdAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627009;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=2VL8p+wO3EDdLMj/N5K7ogE28YqrNLq/yB+/wt+3ugM=;
	b=hRHAzBmEVml9eCkbhw+IEGgjPFkumUJHORae+63kCD3Rwl4uwu+hSKB0UTt45HIIT4LD
	 3L8vEC0T+SRRqz0oCBx0wIHn2ScLvRI22zkFzk05YN2+ZK9KsWYYKzgRDAYBgge1Pw+IO
	 TZPAOu5yo+s+tKCrJWf18Zi2lzaWlV5v3l6NIZajBhQW1saDsHgV/AJg+z75JkEvXpb7w
	 b3YnCnUmZwNR64+D72D2zW6vRpJ5RPi8WzYCfku3GguuRghtk43xT+DyMErsOOp0uXRbl
	 KYu47qdkoHtJHph5o2pRVlrb+xZakXTXMX14wXB3J2aNjaDf9oDtqsQXidID1Mc8DwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iResz1UE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B18A606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iResz1UE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1AD1F000D1;
	Wed, 25 Nov 2026 17:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795627008;
	bh=2VL8p+wO3EDdLMj/N5K7ogE28YqrNLq/yB+/wt+3ugM=;
	h=Date:From:To:Cc:Subject;
	b=iResz1UEAD8H88jSeFGNwP+160iWIfYxM+fZlNNGiWeaRzk2SLwx8VwSAwp9cv+Mc
	 umcJyDqMpaUlJDYHRmav6BqVDrU+fPh3gyRDb87/7L/YMCfsV1Lo8Dp/ijPkCfMp/Q
	 WwAGFbYA8HGF6CS+YytcbjExC1aqy8PgSPggZYeY08KIRRr4g9r648VzpCkyCOPAtk
	 7n9QmvpNUkpIge9SKU4RUeJufu6V2SkQXjDgDVLKD4psZumGtFELXuf3jqpnZ0guUO
	 VKgxabf19QmzcKb3RtLVSOhmcYfQOMNNAP25SmdCqtdodOCb0sOHEDKUwB+YgPYMv8
	 BQyWzb6Q3/diA==
Date: Wed, 25 Nov 2026 18:16:45 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3hucz25qyjijg45t"
Content-Disposition: inline


--3hucz25qyjijg45t
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
MIME-Version: 1.0

We want to pass the character array, not a pointer to it.

This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
"xfs: start creating infrastructure for health monitoring").

Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 fs/xfs/xfs_healthmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 2bdd747f1ead..56d19ffb02b3 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -1061,7 +1061,7 @@ xfs_healthmon_validate(
 		return false;
 	if (hmo->format !=3D XFS_HEALTH_MONITOR_FMT_V0)
 		return false;
-	if (memchr_inv(&hmo->pad, 0, sizeof(hmo->pad)))
+	if (memchr_inv(hmo->pad, 0, sizeof(hmo->pad)))
 		return false;
 	return true;
 }
--=20
2.55.0


--3hucz25qyjijg45t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmsHF/wACgkQ64mZXMKQ
wqmJ4A/9EfaR9quQnr1aW9SCXB3LkWZTBIRgARB3q5N8crZW77EvIKTQBngYgqt5
TpSI8s9Ae8oa58bQ641g9DbEMQo4uOr+6u8kiwBQInSFHjSaAgguWeCpM9bvRdre
FeIdZUpGRJGYvHtKQkfbLC/FRF43iTKD+G4r6fDACPEmxlYFtwmyT32BR7KnAAGA
QRs7UeqRzzesJmrTRlpLWZGGRHbzo9o1vbB4uoOBlkAbUmzUuiRBZXv654qtJyCU
Ll9rW6BOpuOi7wnmU0VRRkV0eWvv7EYc53jp+E1w7QzMLwFAGBK4svGrJxo2iUDF
3W8RnQ+OxfpWhuIAIU8JI2yIjN63/PqR22+JtUJXMEZ0bRgqz+7riyCRzxJKVslr
9F6pIufNMFtN99RuGAqStYv9a/Lj1xGxA5Pu3otqDJRyF0NomJvZb1z6Et8BgNCw
Oy6QlNiuVt3da2CXTWvs0gSjgo8Kv+YOJ6NdwZ/VWlIjhglp3BnhHk9TPynqDIjS
41jAmjac/VDfmXL/rfow0OvGgN2tbi4w/C4Exgda0eNtlTs0skUxRqHGXiUIACK3
LYYevavSSEcxUtuB2puiG7v3qzkdEtMwaqub2mVMtDi7sorOc2FICm6E9aBuUlu6
IsZX43uVB5JcmAprysSRq8myuj6bifhPTWieGUbhQFoIm0OjPcM=
=LSO4
-----END PGP SIGNATURE-----

--3hucz25qyjijg45t--
