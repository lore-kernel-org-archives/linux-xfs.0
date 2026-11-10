Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349966;
	b=kfcg18JM6qlrBxhuZaxztJnPGSN2swNOKLOM4mtrgJtjZa949pcsUdoqfYUanlV9behe
	 BEdw+2F3+j/a7+xMNvxXfmDDVKWbFZxXX73yzaf0hJd2ESrYNAklIOVo08aePKcr4NCYP
	 pF1BUvl1o53JeT0753bfdhwlCJA2RsPxfU650KRkl8Ut84TJ5xQSobScP7FNPds7pU+0D
	 aZN6b6TvvgRWvD2lISYcn45V938vs9rV/C+RPeV5nTyMLb9tNK4lUf+bzCjK91uyzZQxf
	 JymysBfbkd6liwvyVYwLzkVffE78Hd6HsH6V/a9+LmcTxLy3GvARxlYhDq/vNdFgu7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349966;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HQ7x/TllQKscfko1enh7ZEudM21vFfhSSI8zpxm9WxU=;
	b=Qd1YSopRV81/T0nK7B51k0/Qf/Rs/otdeZBxR0LfnpSe6IAOu/Vmm/u881e00Uzev5yj
	 hFGIN9AypDfBqEhF056OWTLn3TfG3vJt823QTS9PG1zl3Wac9DPeFVoBdTh5D75+eYtWV
	 C7qXyV9FUNG8C3khsuPC21g060sEl1VT9R0jqxVT3P9y9ObY6lmxzg7lki3vh8Nh0mm9c
	 jfXw6XF4kI4RrGMsFWd3VTWryQH+Sx1u4PmGI1Vissnp1a0aXQkxoZ6pFzpVv+8K780ks
	 NzVEZexbPrBx+tYoQKa364G2L4+LO3yBPNZaFn7jRHKRV6VTH2dOCODXvUDqiutQI8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNij6F7O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30914606A31C;
	Tue, 10 Nov 2026 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DNij6F7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A5B1F008A2;
	Tue, 10 Nov 2026 22:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349965;
	bh=HQ7x/TllQKscfko1enh7ZEudM21vFfhSSI8zpxm9WxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DNij6F7OuI5XOtcmTJS7mQ74EjScBg5KrzI5SF+tcsu2XCZXUAdVGJd+QGxFFhk43
	 pte2jeJ3BU/3vPPeTE+1dmBTTbYGgf8fpCwOETFKxsyWxbYU78iE98lrc3OtVcnuVk
	 bsBTIJbuvu9iTKP2FRHZYizKxaylLy+JMRBIUX+QsL4+WxMt25yiBz/XSVXsMgpxBt
	 3A+hlDqapoXwRa2TwXu+dl6mEzo6U0+yKmfX6mLWvLnK0/JJr9FPB11EaxUxVaraEU
	 xQE86hHfcG1vNEg3MPDiblk4WTR6NeLEv4RWMypBMM+24R1EeuOgIHwmpTFT+GIJDF
	 Fh6I5KRsXxuXw==
Date: Tue, 10 Nov 2026 14:32:44 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org,
	tytso@mit.edu, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v2 1/5] fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Message-ID: <20261110223244.GC1907@quark>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-2-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-2-aalbersh@kernel.org>

On Thu, Nov 05, 2026 at 12:55:26PM +0100, Andrey Albershteyn wrote:
> [PATCH v2 1/5] fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS

Should use the "fs:" prefix for this one, since it only changes
fs/file_attr.c.

- Eric
