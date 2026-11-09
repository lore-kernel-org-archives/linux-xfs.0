Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794211476;
	b=fUSIZL6YggJDsBxQmN4O6nrwiP5nykQ23cSCqupjR/NaumpTruLEYFFv2FXK3YLwFDeD
	 7du4ACbWxwaBwOO8sImCWM7mF2Ya817w+H1il/cuYaTa4rNPRKVy3iOKnsPXPkbVgdtJF
	 ZzdA31hCu/4/W81T8oRIz6cWKVTrjYdRryhO5IOVL/ERzelm4sbnUgeHNTqnDHhRuX1bQ
	 pMkJ+sw5jktrzlQqtiF07zWkEtNbIXxNtPJR9NAom16CBWX+467AnhQ5wGfm1E/gMB1cl
	 QNxzDfLA/wOozyoRO7k0P4TJn/lSNB1TVmmrMPOJ1yOh0RdAlvJXla/Hj2o7/EiGk2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794211476;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=ZgE5vAdHmdmi+V3tVtwwyycKJw0+JH7M7fEcp2dUTyA=;
	b=3aNdU7tDs+JuncvcLuwGcnZ9ri4FV1B8cOPD6XaJsEKHvGnyY/f1/WoeyJPNbxM/wjeV
	 UQRP8Md+uzyU48AELxMhkYqUoyORToJzYKpd5hIvh1Tn2jWZVouAqQQUAvqZ8ct233xSa
	 qJpCorYkroeovczhN45W8U5LRr9D+DmVidJVzXektxIeLpDF4hGE7I6IKYCFe08bZ5x0p
	 sSxPvxkPomVezn0kJj1lcqaFmqwzkdHblBEhL7qr6Ozks9+67EWh0L2alTgL6g0zbTHEP
	 0JQnSUdKZDSNrx+70hJeQsVjMt99qOcIH6YZ2nZgNtdSwyIJijDOVlzOGih1l/axKbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIj0h676;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5C8606A322;
	Mon,  9 Nov 2026 08:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIj0h676
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FE01F008A1;
	Mon,  9 Nov 2026 08:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794211475;
	bh=ZgE5vAdHmdmi+V3tVtwwyycKJw0+JH7M7fEcp2dUTyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MIj0h676V3n1/gIYspsLTvTqa23Wg1mD6vM/d9duTgJLjjZ9u8EMepBi+TmhJ5gpN
	 8lwNbbF/8F97ytnjACnVNUsDfdLCOiemw4++tGhZp7NCM1y1M6AjRDnQBPO0eOavcG
	 C6bGobrlxZRkn5OBkJ5TFqRQ1XjcYpjW6X0RlVD5I6P8QK8PardtiOinq23ad9VSN3
	 jYT3IqLSIV3AxTkXnC4VqhZvqgfh+r8BFUTdFZhwaOYETroSVVsAtfLiG+EDL0HvRL
	 thESWG6pjjaPuISHS3iqEECTqsgInaR9OXKWqTLnRj/l8a8wVweAGBEdwtcFsMG0PY
	 7snGDLBafvg9w==
From: Carlos Maiolino <cem@kernel.org>
To: linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, kernel-team@meta.com, 
 Christian Andres Saide <csaide@meta.com>
In-Reply-To: <20261104100115.36bf7d28@fangorn>
References: <20261104100115.36bf7d28@fangorn>
Subject: Re: [PATCH] xfs: keep successful near rt allocations
Message-Id: <179421147385.7895.10966034450342887239.b4-ty@kernel.org>
Date: Mon, 09 Nov 2026 09:04:33 +0100
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

On Wed, 04 Nov 2026 10:01:15 -0500, Rik van Riel wrote:
> XFS realtime allocations first attempt to allocate space near where
> other parts of a file already are. If that allocation succeeds, it
> does not have to do a global search for free space.
> 
> Unfortunately, a code cleanup a while ago causes xfs_rtallocate_rtg
> to unconditionally do the global search, even when the search for a
> nearby extent has succeeded.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: keep successful near rt allocations
      commit: 0a2b9af9bd5f2f3be9d4339205d62616c0e0eb08

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

