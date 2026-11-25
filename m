Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628774;
	b=lhcRdPbrk4OCQYMqeomVZ5KCyRm13FAoPB8TMz4IV/5SojzUjlyW+K8aSR5W35Qywlyw
	 BofMj7/1ZblmSe2NCaXPF8+klxvmBc8iUHnJJe98BmdiTK15DO1pgG6F8gL8lT8Wi6YeT
	 jM8X1hPwmawesEe1ZxP5pVGGSzrotyaStZs3AsDpGNOVkiVfXtQ/EqF5qVVl+9Gta98As
	 bZMnZp5vnk36J7a4c2xCUp9hBv9XPj8GGthf9Yl9AxDsJOeppUtyE6dijBMFlNn8kJeu9
	 UWdv0diwBGz9z5NrzrNRRLY9/ieA8d0KrABB3SNtsz13Dmhiyq7bIkro5CDQSOt3JYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/HyfK/KP0/SkhjOZAbAgu8KNf4U3wGlmxdByE77aW8=;
	b=ADkK2ccdzHLfV1xM/6F+DIOUJvr2j+iR2z8OU5TyLsK6vGEgABJORVteIgc5HIq7VShJ
	 CDphYK6BEcegOWWtGlF+ELlGKBaewlzqLZtrer6i0GV569TmHCp4+yH2EDMyfr8UheJQy
	 UY3Ek27nDLkiyIS+x6JIKJ83Pzjo3/KijUud2VSTzEWlfhSZy9CY/lS+MZdkvP0YUcVTu
	 fgcDEcR41KvQX1SPY5bnjR2ky1tBQHyAiFnBsK7+LeHafK7bGS0zWncIE9/zsK+BUiyiv
	 geWzX3tEKHadedrOumfT0lF7ePyhNzONko4LW2jJXjv66BEBdRpdMlgkbuwIJeri0sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwXNkH4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE4E606A31E;
	Wed, 25 Nov 2026 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwXNkH4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4921F000C4;
	Wed, 25 Nov 2026 17:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795628774;
	bh=H/HyfK/KP0/SkhjOZAbAgu8KNf4U3wGlmxdByE77aW8=;
	h=From:To:Cc:Subject:Date;
	b=jwXNkH4yBC4C8lhLQkv8F86tg/E1b2yaPVsu3rZYX5ZDi6KATDNICEDMCsYBO+FNK
	 v+tBJMFi9o3OYVuDupiLXqnPZFtTN6wb/MgrFG4ZdeBItQj8ozlwoSs0sEQ1VmCG9y
	 1TNX+IIvR+3moO2A+Ggk9zCGBE1a2cwIQ5GOfdXgt/B8CQvgIdL5I5f9gX5MPSekYG
	 geLGe6wGsjgJfacaBXBB7rmfJA2EXCNbZpvt0XTH/g0OV/t7BFByQGP0fD63smwmbb
	 2amC2l9K5IMdt3LMxrqaOnuwVYsmxUQ1g1PxvfH4EjfZ8b2vlHg6oS6EkoURTo0IJo
	 PvDcoygqmCn1Q==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	sandeen@sandeen.net,
	dgc@kernel.org,
	aalbersh@kernel.org,
	bfoster@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH v3 0/2] xfs: force all shared extent swap to use rmap shared path
Date: Wed, 25 Nov 2026 18:45:58 +0100
Message-ID: <20261125174607.135959-1-cem@kernel.org>
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

Sorry, yet another new version because I forgot to remove redundand
code... Hopefully I didn't forget anything this time...

This is a new version of this series which takes a different approach by
forcing a log transaction if we need to set reflink flags to inodes.
This should close any possible gap left by setting the flags in-memory
only. Will see what Sashiko finds next...

Carlos Maiolino (2):
  xfs: move _right_neighbor_result trace before erroring out
  xfs: force all shared extent swap to use rmap shared path

 fs/xfs/libxfs/xfs_rmap.c | 14 ++++++----
 fs/xfs/xfs_bmap_util.c   | 60 ++++++++++++++++++++++++++--------------
 2 files changed, 47 insertions(+), 27 deletions(-)

-- 
2.56.1

