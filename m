Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700971;
	b=tyqLz5WxJXOmURpwB4dTE4jBcXzrDD+LcqtSABgRuR99ORNDG8IYwS5HTwIYu1rsxALY
	 QS8xyqItLJmnMElFU9N00YQRbo4abWohWodIhPs1mRJwyN9RszbIT152xBmuheOZhqasN
	 jhSGXYejnGUXr1omcbvbbPOxaTrCEYCJSha1wPPwPzN+PrGbZGVZh0ScgWnWXtjrsktIx
	 OWk/FD/nwZzJh5iG736kxLCiJgqpvUmugSGk/OO96Osf6os2t4pHbrfGr6NAhN9ZiFd2Q
	 hfJ4EHDMJuVDC9DXb5C+MxXLUuFQv08RWCliZEpDjlsR6tqhxhym1oCQHad8luu86Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700971;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=cZa+Z1tCrM4PZ6fLd0V3NwOQh4P/kdjolZsmSO1TQFY=;
	b=fQJDSV3CUfrRRS9zyUDO9TimmwpH8nhsYV2iGw4ExKAXvtkuFvuj+ZauIKjSb+vSZVy/
	 WnutbMMCGLCvotIRjxJzpXs+TcKiXEDgLW+DASiEo5G3t5YG0LqgKA7X/iv9O33NIQqxH
	 Gm7rpQLv+jTkE9LXEZlNu3aLQmS1jbtm896GR1deOTF+cKihUXTH5nzNhM2HB/0hcjcbE
	 Uwb83YXgw1KFMPJBxZEGdLzJfPkJyid3pblwYcVPsfFmD9tP7syRa8qY3ttsKKLt6qVeI
	 ZrUkSlqAw7diDIdFyqED1vmetWZV80cZGTCPfMLtSBWhL3iQI/37K17JNLunK99dRAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TWhy6SJk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7221606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TWhy6SJk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4651F000C6;
	Thu, 26 Nov 2026 13:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700971;
	bh=cZa+Z1tCrM4PZ6fLd0V3NwOQh4P/kdjolZsmSO1TQFY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TWhy6SJkk/OpF/Pbdfpeh/rNz41SwbrRUX6Yqn/HwNpXedw53jUdh03pzg8motu7T
	 LdZsAich+MB4XQ70zv5ergKMqXmmbd4AgR1Oa0mQJz9CMvOznNlKxx14kfBYpbDcPm
	 Tna9HcPDeyiYDuCJREq9FpEOEi/bt6xV8xzXl/No5Tw20Bgr/btTgmrRnJKTnvmmDq
	 9znV7McnHgbY1KriQ7wlo4wxdCx+miugcmTlvjWsifCzTKBHiTkCocHqhh8qSJHV6R
	 LKtK3YvbaiAR+EtqhtZXUH2nO0kJ1U6Hd/eo8yAlNxepuPUvBnphu+pxIwusKivnUh
	 zQlTf5256gatQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Alejandro Colomar <alx@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
Message-Id: <179570096988.157938.13140152686998128500.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 14:49:29 +0100
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

On Wed, 25 Nov 2026 18:16:45 +0100, Alejandro Colomar wrote:
> We want to pass the character array, not a pointer to it.
> 
> This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
> "xfs: start creating infrastructure for health monitoring").
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Remove incorrect use of '&'
      commit: 58de428557082dabdeaa1e1809766236f8e9d6c3

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

