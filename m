Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794914162;
	b=dmEad1cWyNkESYYUPojg8XOV6Zgtc9/9AGOYkMOP8eqd6M5fZVk487GvqgO//cy/6CBV
	 ljE0/y61zNaKytpDV33VU1hgCzjMVOG8EsWfiCNMZKiFxmGPOtCueNgqdNqBloxExc96o
	 a7atRhVZUCdE32aGZYNbros1lpmLDMe1XJSKQQwonoI+GXg55m4xpIf44O23MKNnkMaYh
	 bRU6ZLKL7nlfOuOPUgH4KpcMiRNVbe8mgseGrV/rBXHZoUzFCWBYis22EnQCIhXpP3LTf
	 xZx8v/Fe0S5BnIGTfAxkiZqtXWyTqAL4Xplwzp1Q51iXIIcoP3ewvLxhV276EUGESow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794914162;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=bfBKw5Dqe7/QCgl28CEIM4EiUR1wvD/Rw1mMg1W1wSQ=;
	b=FEbBI+v3xWkdOl+f4Lo3gaUgI1p0BdWhmnEsMojoLx+pKvU++sTeR3eYP99nwp2Uh4IC
	 0eP1e8GGhdZ1QTfk0cjdNhFF/UXGnE/KvqoCfRv5yAllJ3czHK0V3oOmuBKylTnFkZtLL
	 R1KNf6BoCM9uahwsxk68EaJZVM1HNJaihFSpi56f2nSIpNmTdPfsbx61DCB6QXQg3uIxp
	 RFAPBqOuZbY70CnuAJXg+jnIZDSMPvgDt5IIhZLkHm4Pu4GyJePnToTFST2XH6HcDdI36
	 WM8u5Ms6lp8/fWtSCtiPKIwD20rHiTrMYpOQ1GYduA2PKT1o1L9nFm9fotj6ppXRU4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlkbXgUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3E606A338
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 11:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlkbXgUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E1E1F000C9
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 11:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794914161;
	bh=bfBKw5Dqe7/QCgl28CEIM4EiUR1wvD/Rw1mMg1W1wSQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YlkbXgUUQRhyrxgpsJ7Qvml07CSWbgUu8B9MBcv6Rb7T7SWdq8Aq1SQrmZk4EnAhp
	 TcmeQ1ddK4h+Pu6rPK+bVxj9nTENOoMDtpxr/d7pzn6PP0stPZXXTCeTk/x9BdxWok
	 By92sXJDNTF9T+YZxDMLuMMgthIA0MZbqwOtlsHUtiyjq7qF12Dwctp5QuSSU1oZ62
	 3mIGTmaU9HYjlOR/Mw83mXoVkeR8viHwpqjJvVoFTQ+3NlPR3N4Vfq12juTxVu4Kvy
	 pNy7xoR8tcMopGP9TY5NVo+AKp8eALuZYTDKFnCrTCR9bJzmyt4brkpbKPdrhEUdpo
	 BZpOOnX6mFrCA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c45551fa84eso843263366b.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 03:16:01 -0800 (PST)
X-Gm-Message-State: APuU4Z+lAqKa6OLAst5JigMdM5hUjdXbLekiN19h2UeB5CtViSYkGdrK
	bMowkMraEREFV3REtDRUNWl6VhQaEMxvrITZQmL0L98UXRlGHz9MHQnJ5YxWDZzm4VbBJgR80dV
	/p7b7hEky/r/v7EphbB3XB79xOlZ2ptA=
X-Received: by 2002:a17:907:3e9e:b0:c40:4848:f7fa with SMTP id
 a640c23a62f3a-c50965421ebmr1168834366b.44.1794914160376; Tue, 17 Nov 2026
 03:16:00 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116085752.3908082-1-chizhiling@163.com> <20261116085752.3908082-2-chizhiling@163.com>
In-Reply-To: <20261116085752.3908082-2-chizhiling@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 17 Nov 2026 20:15:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_wMVWSp1OZox-dF+G9x3seF1pTe436Y5dhR8LAqjtPdA@mail.gmail.com>
X-Gm-Features: AclHuK_g651WVLWBvZ3JkfDxJ0juXOGnsif_vLCZ2PuPoqhZPKjOh8aIm_6kPfQ
Message-ID: <CAKYAXd_wMVWSp1OZox-dF+G9x3seF1pTe436Y5dhR8LAqjtPdA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] iomap: export iomap_bio_read_folio_range_sync()
To: Chi Zhiling <chizhiling@163.com>, Christian Brauner <brauner@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	exfat@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Chi Zhiling <chizhiling@kylinos.cn>, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 5:59=E2=80=AFPM Chi Zhiling <chizhiling@163.com> wr=
ote:
>
> From: Chi Zhiling <chizhiling@kylinos.cn>
>
> Filesystems that provide a buffered write ->read_folio_range handler
> need to perform the same synchronous bio read as the default handler.
> Move the declaration of iomap_bio_read_folio_range_sync() from the
> internal header to <linux/iomap.h>, together with the !CONFIG_BLOCK
> fallback, and export it so that modular filesystems can call it.
>
> exfat will call it from its own ->read_folio_range handler to zero
> the stale bytes between valid_size and the end of the block under
> the folio lock during buffered writes.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Christian, if you apply this patch(1/5) to the iomap tree, I will
apply the remaining patches (2-5) into the exFAT tree.
Thanks!
