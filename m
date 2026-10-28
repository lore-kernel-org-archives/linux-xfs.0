Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212714;
	b=Kfmzxty3VRjOtqJqnOxXTqRKLPj29GmOp1PxecxqAkF++pK/VsgbS6zuU/KTwOaSrLrc
	 43LaZJLHHHtb7nwdoSTAW71buEFWuEyWMIKaKHwvUYxlHxZpHGGdNLhawTM3Ehp8TEWmI
	 Td8Lwzi2T0iK60dXOuAT09cdHY9DCDFKByjyCO0mNfqSDirC2d+YeF4nIyIIiCvvxYGrx
	 BC4z8SifSwSBYRIjcBv3V6D1BRkWyl6NkNSdzS12DPnBXcgczw941x1WYMRX4oHbyTUWx
	 HWWhXat+oNuaneTAOxnDLA9ZLSZ3+SdWnOifXe1bj0smTcEmft3zz+s4+gk6LJU0VGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212714;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VpA17SHHGuwrQBIEjd+s24NC7TfJ/mBAwe7vJ4GIKtI=;
	b=fSw5vKY+LSrPGsckPIOa6ZhIuEFQaQx/MAsDNOU/5YW3BP3PTw2gDNFHRBETetjLNePQ
	 iUJv0+iU7YLytYmzFUS/KpxFKNCPqvEBYRAaqUMeDE1OjJEIv+I+h3Nyp9toBsL+5s2tq
	 i+MGCwyVbEYAx3zOyndm1JX5s/zaqrdxOaqIXKuwQPpqnLu9ln1rOcSh4g3fpQxb5DUJm
	 7wT3IowF+vhG6wPTkwgJNUqpiVZYoQ3WZqWEzroV6/gg2NUa+ltlszj4KFapmKI5O3Rc0
	 aws7ergTqJfMJCAqBmG1BzwGn0CXxw30jeh8pMpcf9oPrgyoJWx32ui3u1OnPe0ixyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aQeeVIPM;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E37A606A322
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 18:38:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E37A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aQeeVIPM
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49d05d51553so10057055e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 11:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793212713; x=1793817513; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VpA17SHHGuwrQBIEjd+s24NC7TfJ/mBAwe7vJ4GIKtI=;
        b=aQeeVIPMUiqwk6WocMaK2fvqFwOXq4+ME7x7LUdhEWRKNeI+L7qE3SAenqbAKKHIEu
         /dZzO+hCGRCttUuyJao2yyEMffqXY1XcIVpeVQuXvPFmqDkY/EY33VTXhu43HGxq74ZO
         +6o+Q/0xUxxMomTwd00jaif3ZMEwJPorfnEKewH/nJ0b6ROCYffVkQq5ewb6SwNj4ve/
         LINfOhDwFhSEUcRKmkKUyBqhxHlvw/7HKboI/1J3227wiS+ln5iiwurOKfFN9Tl/kmUo
         s1Tx15RkKcq9clTXL2z/wjGiazmRXGXXnDvJaRXjBuvJ+RyHV7TfQw4joB+c0v7Pzi8L
         iDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212713; x=1793817513;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VpA17SHHGuwrQBIEjd+s24NC7TfJ/mBAwe7vJ4GIKtI=;
        b=G4ZRn8x/i47PhI9570nWYZoLSidO1LSMvjNmEcEcKyx8xgry3uViOzfDPopJLmqRI4
         NM7X2AlZIRZW/PkGHjr6gi41Rqum/2zjwfrSo8ZWQ35hnhU81KeGrhsA4otnd5ZtCksU
         b9D2gO+PD+MdUgKHhXcW1xPCpVxpkIIdL5C4Bf7+/pc+8ir/SmJy0XCCYo+1HNwkiBSG
         vjKjeoN3tmlOi0ZP4d0yiqNdF8pZBu8l+aH0F+L6CbJLgk8tNXHvclHtaWrcl8oe7SXo
         0NLCMfV0kyyyVaJ+AIi2r/SzFpTQiYFErXmA3YAS9CermLUt3wjFMHL9OjFE+Xg5oPr7
         Q4Wg==
X-Forwarded-Encrypted: i=1; AKwUvBz8L+a4ayLAg5gOfyMtuiak4BHAPZrLH4GkoIEASNPktoWiATX30YqfC4Ci6t98vMewyikLiZv4ESw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJwg9GQ2vBpRganwWYk9uJeELksrulhqrAhxc7XKIBMwWK9jKtB
	P95YvnifLO47AtCMMRGHNWxyL+ytpwOwGYlPJieKC/alOgI3KAg0U2e/
X-Gm-Gg: AYBFou0UP+q0tsHbGA5CEJkaLMbDxcyF8NYWWpBbXJ0vzXJS+KyIv27AxWi5Naz78Su
	cUd5V0scM8BwYK0KTEFUU4hrxVfpfarLb3KOR+vnUC5uQzpuxTytvaegKeFNH5DD/I5yvBLiAYH
	7Hp7vTqqfV6dFMpO+WKF0xmeq9yTL6RBkZaVkfRG9OO3HsCYMOIh3tJcrjArPgs32MxVZNwWZ6/
	Bdnkb9Un535jW8wbXXnFXo6K8ZY/ce9O1rDkz/U3nM8OYMY9MY642Iq7W+dMCFLWxWRn+qFITyC
	mnt2m5D+wmhQDj0XPsdSVRF+/1pcFaFZ1AtUOAPsOcGQ2L0vGV+yRQDU4gTVtFFCSOBZeyJwgXE
	LevdBMR/1kUpcyFaQp4+yXfKYrRBUWvcUatfIshgmhX7ks4B/w/qbLzhZ6E4MJhMY2GiE8PFvCs
	Vop8Hn3i5YntTiwOfFRp5XG4jkOR6qfzoVealnv6LnjzFKVZow6BtE5/O3l2Y9HmFPaTCekIn3Y
	L8UeHN44u7aELX3JkM7vPLM8hfXFi7DmxaCL+sQAojtGL9zxImX0gAQQf6P8IbJljtffbX8N+DZ
	iAesa863qrw2k8NIPLIS7yozAsfzpIrBARzexAW1XKMOvS3REaP5jjyOkr5AKbPb8g==
X-Received: by 2002:a05:600c:3541:b0:4a5:a5ca:de1d with SMTP id 5b1f17b1804b1-4a9675dc907mr75026265e9.30.1793212712626;
        Wed, 28 Oct 2026 11:38:32 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04723sm10842695e9.5.2026.10.28.11.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 11:38:32 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:38:30 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Reid Downing <skibletz@gmail.com>, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Darrick J . Wong"
 <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig
 <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix wrong compat fields in
 xfs_ioctl32_bstat_copyin()
Message-ID: <20261028183831.055627aa@pumpkin>
In-Reply-To: <auISUBmIMQr7fesW@infradead.org>
References: <20261027161748.2760321-1-skibletz@gmail.com>
	<20261027164911.578ef6e7@pumpkin>
	<auISUBmIMQr7fesW@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Oct 2026 08:18:40 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Oct 27, 2026 at 04:49:11PM +0000, David Laight wrote:
> > On Tue, 27 Oct 2026 12:17:48 -0400
> > Reid Downing <skibletz@gmail.com> wrote:
> >   
> > > bs_blocks and bs_xflags were both read from bstat32->bs_size.
> > > Read each one from its own field instead.  
> > 
> > It would be much better to do a single copy_from_user() of the entire
> > compat structure and copy the fields to the standard one.  
> 
> Care to explain why it would be "much better" to do two copies instead of
> one?  The only benefits from copy_from/to_user over the current
> get_put/user is avoidind the conctant user access disabling/enabling,

That is a massive hit.
The current code also has all the conditionals from access_ok().

> but the scoped uaccess thing would do the same.

True, but unnecessarily 'technical' for this bit of code.
You also save all the exception table entries - so the code size
would be rather smaller.

David


