Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200722;
	b=w3Yz2ik56CC6Xkt8mZrF1u4mZysJcvLwZSzzbZVp3lnGpO9KxvFvAyNlQHuaLmuSOtcY
	 w99eEApbK/DJ9Abu0qxPlKQzHVG4OoATHKXnWNFuJRe9/rbThFmNDbKEbaICJSWYiijyU
	 voREfAtv9jv49soueLXxmB7LBqi3AAm404PxShlVwXjp+On1NCvJWVR55w3aUrXm507aR
	 AaiuNf96QnZl5FsKpVXO9sOzbde7NBmna4cTsS1J6U/E+ive0XUZi74+yF4QE/eXROrJM
	 T8L32gq3d+S7aFKpksg9lUM8ybSwi8u8yr661jSY/aeUbN1hxfA9XLEAzTbQpApEK2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200722;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=O3C//2Q66mNOTbxeMwiSptb4v0mchlq6scVO0QhBDDI=;
	b=bCoyGa7pJY/wKgDs4uTLNRpAPwzFZmwxJPHKG2OfeoISOet5VrJdOJ5q7j8yp0FhicuJ
	 +zQIiHQ08zVt+YxUac0YeACMZQr5aKa7pZy01WszFeAc2m0JmNDZNh4iPwpiWbwlYgOSI
	 A7D2iV62hFoIzQPl0AMVda9OT33cjoJAJjdVcpTlEB8lDf/g8OjlcB6kkfPOcL+i12hKv
	 d7F6vy9VwBeB6vQsKVISduUSGeSrCZQ+TRDmuGTwpXApnYA1VmIDaJ+hY0a0wGNK8fao7
	 JQpFNhamjmYaSm1XWWFw3GLsvCHQ+Ab7oTjiraOAPIR8HmmUHOu9PixP4R4Mzcj0Aog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Fmg9vEWn;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889F5606A31A;
	Wed, 28 Oct 2026 15:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 889F5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Fmg9vEWn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O3C//2Q66mNOTbxeMwiSptb4v0mchlq6scVO0QhBDDI=; b=Fmg9vEWnOpKQZ64wN57qQnTKFK
	UGcSvJ5VDDShdM1hdohpVcHVcTzl/LRoN/BngPOd5YNdwmkdY7tDgTrmpxMfE4n2yirOFAGEs0oas
	7WzGnJv/q/zPXLWiyIlFhUyVo3EXuI9DJ1AON1dkE+ja7ZJ4Wyhc9PWyLilzsUVwQDFRYPQxffeIE
	Q4+vUJfoTxUScWmtOtZRnKf8JfXayhvdvU77c31/xjVVFdvyW13ctJ/tHenz4bcoVsQ11necFAyK0
	yIURzdjCV2kElhE7xT81y754N1KwGPglwlwp7No8poO3naOe1Y70PLX4+cDwsckeFkrc418rNN6Nl
	+gd6SBTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5QG-00000007KE7-2VWt;
	Wed, 28 Oct 2026 15:18:40 +0000
Date: Wed, 28 Oct 2026 08:18:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Reid Downing <skibletz@gmail.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix wrong compat fields in
 xfs_ioctl32_bstat_copyin()
Message-ID: <auISUBmIMQr7fesW@infradead.org>
References: <20261027161748.2760321-1-skibletz@gmail.com>
 <20261027164911.578ef6e7@pumpkin>
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
In-Reply-To: <20261027164911.578ef6e7@pumpkin>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 27, 2026 at 04:49:11PM +0000, David Laight wrote:
> On Tue, 27 Oct 2026 12:17:48 -0400
> Reid Downing <skibletz@gmail.com> wrote:
> 
> > bs_blocks and bs_xflags were both read from bstat32->bs_size.
> > Read each one from its own field instead.
> 
> It would be much better to do a single copy_from_user() of the entire
> compat structure and copy the fields to the standard one.

Care to explain why it would be "much better" to do two copies instead of
one?  The only benefits from copy_from/to_user over the current
get_put/user is avoidind the conctant user access disabling/enabling,
but the scoped uaccess thing would do the same.

