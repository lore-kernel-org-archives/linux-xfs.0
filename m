Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114318;
	b=I6KhqrsfNTPiB5Z0hKN8P7TzotwsXC25TgkxqGcVlymo7ke0a8hFZSRZPGKIPVyg/74a
	 47udUarq9DZ5K2Rgk/8XHrVlfEuVX74zckln3/IdNr95cJNKfVBLyCzZGK4Elmk9g2ZAL
	 acQd0hS4VSh4wv0lLIQUYcPPG4n8Ro56evCzXK86nN+Xq+V1j1ZuyJN+tBmAYCiBw55tS
	 oXV28kZu/Z5ciFxCt11mrOS50i71sfXML92dm5sey1Nfpl1/W15c3GmDqGWvwNlvbHceW
	 wo03Q5PHnCTuhof1p3ntEjCAL5ji6xVggZDYyQ+s64JUKSDlRa9trKcxqisgmfimc8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114318;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=xz4op60yf4EnDK3JLUQMIV53bRam1D/JhH6Dzl6OhXw=;
	b=a+Mub45djKyFWQp1eL4NaH//PLVLe3ltJBO+l1FOc+cULWPlA7mWYo6th38+mDYrta89
	 94PLy/M/7iBHAuA1L+dl449SMKzVIMoJUt18RWIPLvw7iK9r58mVJWZAJAs8Omxx7oKC8
	 F0Ay+nbuzKfomb6+ub1GufDZfSqQ4NCv2IkjwHPMvdvvZG64lzp5dTtnbcJ5XIRJgPYY4
	 RjBmnhFJEjXAzUeqZyI+ifH7XsKJ1Cfb36iLhamqOS0/0CzjMeg7xUXgQqFkVKkMxgMf9
	 2asFn8sA/8+sMmYae2ra+PbHHEv92qsZMC7jvEYjRdfr9j+/ARHbOC9BA97HAfugIPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vmdtYiv8;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1546606A31A;
	Tue, 27 Oct 2026 15:18:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1546606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vmdtYiv8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xz4op60yf4EnDK3JLUQMIV53bRam1D/JhH6Dzl6OhXw=; b=vmdtYiv8PR7e1sBPI9M8bXxAuM
	bZEuwkfmSatAdEGVJ7yztahMLcEb1pKVCExHgbTQF0b8xwLgT4FIdKBzg7LPWaU8mpplN0DKM49oG
	BZw2St2V9QxSxv8hXb+R8J3i8wppAnzZ1jF5XzfUKe58SHMYelHMEZpM/OYBbTBGBbcRctWbKtXEV
	kFA7xQwJatFzqR7XfMa0gTEKyAztd0zzaAL1qOYjQzXoJAaQHo28q8sGbVe//88boG+WJXORIaYx8
	6fTC/i4wbr8hqFgVawlP+FepHBJcgZgH9dZW5VrlDZsj0EHTv0q8K6n4vNrBlnEdvCo6aJf4qt/b9
	xq0AgHfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLiwe-0000000597F-46Cy;
	Tue, 27 Oct 2026 15:18:36 +0000
Date: Tue, 27 Oct 2026 08:18:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Reid D <skibletz@gmail.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH] xfs: fix bs_xflags copied from wrong compat field
Message-ID: <auDAzCf_MBLTmkBI@infradead.org>
References: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
 <20261016050847.GT2705364@frogsfrogsfrogs>
 <a785481f-74a4-468a-b164-0b7a55c04246@redhat.com>
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
In-Reply-To: <a785481f-74a4-468a-b164-0b7a55c04246@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I wonder if we should have a way to test these compat abis in
xfstests.  Have test programs (or xfs_io?) compiled with -m32
and compare to native?

