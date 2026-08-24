Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6F35C193;
	Mon, 24 Aug 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787600047; cv=none; b=WopWwPl5/NB3YfoBqVTiOyGNiLiEHG3QukadeSYFMUZEBN4/n81NeRqt+qCmm38I97Pg32tE2yVDV8tncVcGdKK05zQpEesLLem+oiiYSnW+n5sbYTHZkqMuCCVWS1IjeN+jGdKkTnbJpXA17LQ0eEvmOKspX+zMdPPKkcpi4Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787600047; c=relaxed/simple;
	bh=e856r2XdSovK3s46tfjF7qqNQSSG6k7Xd9AJzciOatU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uiAv1+c3PPD5HZNEs/wQpchJNXut66ik5n9pIe243jgIP/4Ch4qijmzebdHI7VYhOHKstXITpOc7SaZvJ3HTlf6HJlZosr2jNGL1nMeFNuqVHARI9uUib/MDFu5bo7NGzrjL7CXzp+t+qdi4gfUDMakGho65yL7VvhFJUy8IrLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=kUlwIRrM; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="kUlwIRrM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=e856r2XdSovK3s46tfjF7qqNQSSG6k7Xd9AJzciOatU=; b=kUlwIR
	rM9b3PMYhiTB2ZzcglWmkYwdqJmum7Yr9yLS+0pnHE0rt/ENWEENaxynSpa0bl4C/LI4/Xwqa1QZt
	LzDUVSkI8BVfOuQ+ad+upzsEcZiluRho8D2+C8AbG0Mb7FPgxDtYnHrANWSPsKpJXN+DEO4h2vx7B
	IJL57OpS684UxqO0KtAwB7dj33I/ZOf+cnSEoZCWVAsmjnzkzqQ4yEWaCSuFicOHlhipbOJtWiYlv
	Oss220Q4JuquNEbuhQ53VR+jVhnGhX2IH8de4HUyrojx/eNO0a7v2gTlRsjJN/DG609haBjOUgEU7
	IAYyq0bPGD5ajDBC1bAmNCIF68uA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wyaQ0-000000038ub-1E9K;
	Mon, 24 Aug 2026 19:33:16 +0000
Message-ID: <b067b26d9d0bc224b5916c7e064277863e7bbc55.camel@surriel.com>
Subject: Re: Removing ->dirty_folio
From: Rik van Riel <riel@surriel.com>
To: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
 Christoph Hellwig	 <hch@lst.de>, Jann Horn <jannh@google.com>, David
 Howells <dhowells@redhat.com>,  John Hubbard <jhubbard@nvidia.com>, Jan
 Kara <jack@suse.cz>, Qu Wenruo <wqu@suse.com>, "Darrick J. Wong"	
 <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, 	linux-mm@kvack.org,
 linux-xfs@vger.kernel.org
Cc: David Hildenbrand <davidhildenbrand@gmail.com>
Date: Mon, 24 Aug 2026 15:33:15 -0400
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-24 at 20:08 +0100, Matthew Wilcox wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and
> so on.
>=20
> This is not how filesystems want to be informed of folio dirtying.
>=20
This sounds like I should leave the folio_mark_dirty()
stuff in the get_user_pages() code alone for now, and
leave the shaving of that yak to another day?

In that case, I'll prepare my next version of the
get_user_pages() series.

--=20
All Rights Reversed.
