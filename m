Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992334;
	b=goFKybYXi6UQipB1jEqwNRKANcgDk3NwUd5qPI4R+ukoKuryLTYQ4M9ZfXxiObuJHxog
	 L7PKW9p1S0ZZqChb2k8BUaVNIQ2kAu6XYMcfeRy5S1xyACocfjVV63T9KS88EiVi2GHQ8
	 bznEzuolVD+jPatKGjbBkwwLsyD15qej5Me3c+wCAWL6ONOJenWjli8XqaWw8CfRHGTnb
	 SZ+P3EyLXV51QmBhS1pqcom5rnKMbTF3sJwa7rJ6tIdlyIlheuPY2F+m7aiQs+8eVhBpM
	 4V9SX5kbhA/y9/qYWk01/QFvriJzhb0AVSIZ2eWDjAoF09NaLZxIC3zI9PQQSKOlEjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992334;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=XtAiizFNPZX1yW14JcAmupOVKAb7p+j5iTw0z219uvA=;
	b=yiAIuR+/HWW/7EVjgvosOHR3tdslzusu7x7lFOkmF42mdg7zsDUzrx3M/jnKeGGgtV60
	 knzp8hPTRNoOQ9gV4jUtVRQ3QU14NRcpx533daBHVUaGYfSS5bkC+ZGWesUS7pNVszoZ4
	 ByaEblZWyCjxO47IhetrFZFEKM8+MY5UCuyvDqde3VAwhVWnsAELrK8G8kw7N3fj/muwy
	 BcXdJpmpaUvUTnW/jdC6rjgETrJG7LKg6jLX49U3lmZ5NcYcDBfiDEqSfO2Qg6ZorI+Rh
	 3a2ouMGQq6JcblY6NypXLpuL5grApjJ0CoFm8YsG1JQCkPK4dZCOJA/YPdqluvApkcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="m8U/R7Ee";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA502606A337
	for <linux-xfs@vger.kernel.org>; Wed, 18 Nov 2026 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8U/R7Ee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47651F000CA;
	Wed, 18 Nov 2026 08:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992333;
	bh=XtAiizFNPZX1yW14JcAmupOVKAb7p+j5iTw0z219uvA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=m8U/R7EedcS3MjyaCPkSog4u1G/hFXNEOQaYwhEIDanLElpQ8fi7juF2fBTuUbMOL
	 G2j8urGiVpn4kqTsYyqAWebc06e+wDkfzyJgyxBPJqsN1abY9t0kfXB20mio4EV10Y
	 omg6rkvLnU/HBLEcXcz6WrNtMJL3BBJqt+ik3Rz4PaXDKQK2Xkswzrv5EoIcWmkskC
	 4aFr0IcUm9T6TGorApN+p7I750NLNmVjuTR0ZcReWqUIJXqgMFcnFmYCvSEHxj0Y6j
	 LOljzKi08wFjlPcMLtv39cTVgUWWi1GEaSNd5Tor/My5tRu6I4BDAytYK9nIYm6A5t
	 Bh7haFCw48ExQ==
From: Carlos Maiolino <cem@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
In-Reply-To: <20261109102507.262283-1-cem@kernel.org>
References: <20261109102507.262283-1-cem@kernel.org>
Subject: Re: [PATCH] xfs: remove redundant extra assert from
 xfs_zone_gc_query
Message-Id: <179499233263.5574.4971950907568766789.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:58:52 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 09 Nov 2026 11:25:01 +0100, cem@kernel.org wrote:
> We initially assert that iter->next_startblock is lower or equal
> than the total blocks in the rtg.  If we are in the later case
> (next_startblock being equal to blocks in rtg) the conditional
> right after the first assert, will jump out of the function.
> After the conditional, the only remaining case is next_startblock
> being lower than the rtg block count.  So the second assert seems
> redundant to me.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove redundant extra assert from xfs_zone_gc_query
      commit: e5d3bcc6897a30d4a47e0332bc86a7c2bd44a6c8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

