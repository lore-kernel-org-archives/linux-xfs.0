Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795627473;
	b=5Lkn9ljW5QQFAku4V62h8rREUaVeyYwK0Al2YmxhnG4s9Fel+Bdo6ltgtIjURPdKinDr
	 xRtj4+sNg1MHQzi28O598H9qPM56WJTSh+lMHgZSHXb/eq7sBQb9tyB0I9etcz2wu879O
	 VQjiQ+MgX+oNTn10Jw3LlHiNSiPFIKnbDLHgqbYnaDOsUVsg7hqoSRxyjbeinPT/WRwyY
	 mMhjysAZSmtR9Hzgq9dytWXTjkmz8AVocRQ2n3FPRfLtxvPFzNd8ZfIuXoA+0d6bEvMY+
	 E+rraEz9RngahYlOvS036/Kt8h40L+8VUt5NPgiyybQ8znIiQoovUE5ZbrlOPuc3BAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795627473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BibWv6FeXZRuVqDtU2nW+o/0RMUxuUoW4T8GR6qons=;
	b=XQdDZzQjyqh0ggiRVqOSKN7EuhRdq2oKgVG8a2GWr/DzJ32k8kE7ttRhTlujmsi83a3P
	 VXPPBDTPy9s0Ru9FwDR/9sOeYUURNdKgewM9lJAZeOV4CwqW82WsTD5zUoZYTwlm5DpEa
	 dH2FA6KYSnIsnaQ8tiRs/wC+MHlMw305nEOwHVetmN2sYuxLRj7WMpZ03W9CcOzq2u4ZM
	 sqrhc66Z3TEou3concRK+4UppKt1zu2oSRYZalSxVBb/X7TqAV42feNP2KNho+5nfc8Zl
	 UB7Jg9kuSs3zjEbAkTT2Hspu8iZM4mqd/3jizI+nXq8+C9MeZsWjj17nMhblZmKa/OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JFjS1IEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC6A606A31E;
	Wed, 25 Nov 2026 17:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JFjS1IEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069D71F000C4;
	Wed, 25 Nov 2026 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795627473;
	bh=0BibWv6FeXZRuVqDtU2nW+o/0RMUxuUoW4T8GR6qons=;
	h=From:To:Cc:Subject:Date;
	b=JFjS1IEkE4mKGBveHBXCZkTghzPDn9o5ZUHLrMekboW4sB75ocUaf0iq9S4xYbaEJ
	 WgsE7g+HchHEevs7PH/HDtdItcooiqGgad4RtgnSMQ6gDMBndWEPRmtbuSDwOQ2aug
	 rXilhsUIPfHhz62O1XnjXo/Q9BHcR1HX74dYrpGYu94wwcAA+lEqoTcVBxuhijEuEs
	 h8YeCNtmzug9S9eqHvWfps2lQ/3dfDL1fwll8kHUz+t9wHU7mRijxsQsgU1p6cQU9T
	 ChKjgXt3Bx22HT2gY76/ZWWnqlrDx9T7PoEzciWpaFRyokSKy6o1ZI4p286ass9zC8
	 fBJS6Yfc82v2g==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: force all shared extent swap to use rmap shared path
Date: Wed, 25 Nov 2026 18:24:19 +0100
Message-ID: <20261125172426.132084-1-cem@kernel.org>
X-Mailer: git-send-email 2.56.1
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

This is a new version of this series which takes a different approach by
forcing a log transaction if we need to set reflink flags to inodes.
This should close any possible gap left by setting the flags in-memory
only. Will see what Sashiko finds next...

Carlos Maiolino (2):
  xfs: move _right_neighbor_result trace before erroring out
  xfs: force all shared extent swap to use rmap shared path

 fs/xfs/libxfs/xfs_rmap.c | 14 ++++++-----
 fs/xfs/xfs_bmap_util.c   | 52 ++++++++++++++++++++++++++++++----------
 2 files changed, 47 insertions(+), 19 deletions(-)

-- 
2.56.1

