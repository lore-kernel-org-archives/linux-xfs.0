Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794153270;
	b=E2e4Q3QI9ChnB2zcio+b8dGrmuUT+4Z6DUFfrZlaaVIAZJmobHr/AmL6VPDqo0NkkKTJ
	 L3aQ7X3EZv1xuVk+Mhq8tyIo0vbOFvOradtgvnMmLoNB6BJLWqtnKgMl31vwSyffdI9B0
	 FelcFnhgH96ju+mcz0I3Q+7E8lcFGM4tQQTNWFXOnkTPXttDpLjLuON5e/UXuVg3UHA9K
	 l7B/NyRlclBDDRsU8jwogDN7NDX6SloDGE0H0bLnDcICTOS8ugkynqgz+rj+l6L++tBqH
	 ZaVWcldNRp3vYftKSiLVU0zg/nzQE6oOJl6zubTuabZexi1NRiybs3ZKSOB86XIB6tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794153270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5GBHjUTFcUUKHRDe6Uz5ToMncS7KWKXWOvxbmPEhwVE=;
	b=ulv9bpskAkhsJnq5Ac9ya+hT/GQ5w6ybCqglLj8tcWdSvapag17WLfuRK9mFDdYMQipv
	 eAoSQDYuKThdJ822icqaKJAexVLpAQ7VGwSSx2j+m7+L0Db/0qG/t5G4pn8unv4tJDOwR
	 leoLhQNJphQlIo9Hg79P+HOs1hBBB/8Z5hF/sRGUuUQPTnM2aMlj+5OQMbdZBCBD/zfPT
	 +rAbfacCzwkBPCpWWMFJen8spjiFsHbf7GCYymJCAfBVFr+7bMs2RaA6h7kZiZsCM51J/
	 HP9AC6FVdS2asPJFaPyyzU3t7DNxBvvfCJ5nGajGaL7HEopDi/HHt+G+fZRLT6usrNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZJmK8oUf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C817606A31C;
	Sun,  8 Nov 2026 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZJmK8oUf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041841F0089F;
	Sun,  8 Nov 2026 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794153270;
	bh=5GBHjUTFcUUKHRDe6Uz5ToMncS7KWKXWOvxbmPEhwVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJmK8oUfB5GK4SbMw3dQ4gH4wjlNa4ufA6yaxygD3Pbs5aQPHdlk4heug6b52tepR
	 HDxpJJlU8tRKZUgzaTxtMt5yfwa6BJUtuObFCmPlQp5ro1G/aANuVZyCqpQyvuACBd
	 xQCn+U+Ijo6zuGkJ2P84IAnkz63BANh0VFfve8TpGzqv/J3WeIZpC75uiyvmv2YXa8
	 TsQJxAJxz8iLLP+w6S1PYYF6XGDXOJq7Yspz2c9uANiujJOPDZ53koYaa7XAmvDESh
	 qfV16MLzWmPUrgefTB0jcFCI8f2brVRUadBdyxsFQ5aUyC1DtJHF8qO9VpNcFrUyj0
	 FSoBfoNzq3IQw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/869] 6.18.63-rc1 review
Date: Sun,  8 Nov 2026 16:54:16 +0100
Message-ID: <20261108155416.119775-1-ojeda@kernel.org>
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

On Sat, 07 Nov 2026 08:44:42 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.63 release.
> There are 869 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

In loongarch64, I am seeing again the XFS issue:

  https://lore.kernel.org/stable/20261106071743.90363-1-ojeda@kernel.org/

Cc: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev

For completeness, for UML I have been seeing (I will skip reporting these):

  arch/um/drivers/ubd_kern.c:780:13: warning: stack frame size (1480) exceeds limit (1024) in 'ubd_device_release' [-Wframe-larger-than]

  lib/kunit/test.c:684:5: warning: stack frame size (1208) exceeds limit (1024) in 'kunit_run_tests' [-Wframe-larger-than]

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org

Thanks!

Cheers,
Miguel
