Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630535;
	b=TRMda9/ANPp/Q/vKH94fspkvOYNy4s6+cysP539XycQeUSFAi57kA9ssc9TwxpFkS1Zm
	 j+X4jRBC6JbJ4rxfFTFrl/K5e4snp22RA2zq6xs34um6dX1ZeUv4VsRW/tlzmlKIxYA9v
	 c6Zzdxz+tXXW02m4Mnw6i7jFwDumSKfU9E4N2jJeu95hZj9pWSJm1mHh0Abu4hFGoM9cX
	 hbSrQ3Ms6+KY3cVl0j8T2/06iRIuVhnuehY8YW7fCkzybuJRtmLPK+20QpPAht+Wru1/r
	 ohvF8oBi6dFnyJNAWPIdBQdGT+irvfzLGHO2P66WlCIbQrpaqKGXGPDiS6UDeYdHRpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9o0TueZaf5/WtzPFlKPlIHylSzXJjwUNn37myBZsZCk=;
	b=1P1ltId4qoy8KejJ1BpzDCZO7UwBNBfwJuumVDl+hoDGPWBrz+A4UBWENUcKYQhpA+t8
	 F8dabrqg5jYTu/Ju/qzetbiphm7FYTlv7Zgi5lVw30r9O6AA8VOjbkkQNJfuuoRRRZR6B
	 tdsWNtO4i3WginuoHi0dVxNxY4mQ6sW1WvV02vcxFG9agAObhzOJuIIjQqEeCBiofONm0
	 GNfVqKKZUlycSzAZmPFJ4ClapJyCEmWSzHK/8hzYbtn0pc42MOJ5npCc2z/hsPy6S5iYY
	 nMxkUXYhyrLAUb1nt2+YLlbWEttCWlTOpCzIbuGG/UdQko4dor5G8gPHahEN2mUZAGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XOXkAr0f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39153606FB4E;
	Mon,  2 Nov 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XOXkAr0f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02E81F00A16;
	Mon,  2 Nov 2026 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630534;
	bh=9o0TueZaf5/WtzPFlKPlIHylSzXJjwUNn37myBZsZCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOXkAr0fD5b1yoPYjYF+J4y0fDMCRb1YAJxKDSn1VaXAh1Qdnzgf4XjeV8gBlF1bJ
	 i46SkFw33VIEAsWFkKfeGKi2E0ZEEM6XR0QdzREffuO4smJ9Wz1jnGCdO69li7e1pq
	 me3MLLliV724wEYxjnbKhcCJpntq8f6LHjjzAP0tiMiZcBAlu8miWbwL8GFC/Xh7cF
	 ek95vCmpxe2B+jS53yreu/0zMiEpP1HWhJA7u70gV0G7Ie07UpN395gZubKSIOUmXH
	 DABRXZhCUtbMlOelpS02WST+crO37jWameeW2nkT/rqjcLahbK9ChfzNzMy4nmBcaE
	 N9x28c77HMUXQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 02/15] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Mon,  2 Nov 2026 15:41:32 +0100
Message-ID: <20261102144147.2393369-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
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

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 3f8b8f79a4db..b25a0c2fbd2a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1387,6 +1387,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.54.0

