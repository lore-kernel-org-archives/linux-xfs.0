Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409781;
	b=OH3Uk1568rXq5MGrTwxl1dMFgS38eIMqhmsoYN7j+DRBoSsQ+y66Yddunsj9uROX1vI8
	 CBcxlTucdCqnP8pjCpyAgVCZLC9wCAFYm5yaDdXEYvpdQfjC2xfwEMgC+Nl856WvpIgv+
	 w9PoJnAd3ct4LCRAFtX4ch5idbjKFxDyH7rNINqDO4R9Ab4uAJM13wxr0VKWQZJXs36FQ
	 Z47DtYACF1TbE3m8s8/kpCTZi9d2gUJjM5hHGqlbwke/xV0qe6QbL3qBe0u9+oy1hFO81
	 3YTLI1r3eCiwG1MZxyAxJoLGngIAV+rZTb2NaHsHz2PjS5l7YUwE4WofU+HL5WDvZ5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409781;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=0Loohs0l13RgnqI71ZUmljjW6di5rwCdEPkxPKK44G0=;
	b=gluSc5Pp/+X5eIc327u2Rk8YdfP7vJxlFIlcioTwoEn/AgeJDAnXwk/Nm/Lx66cMi2yz
	 IAwG68Eds6kU4fwL6Gv16apFDCeInz4yBltlwEIG+r9GsYjZiu5fyXFx/sJ3t9A4eMNq9
	 8zIwzhq0tiEbCpD4IOg5qF1swMVBngb+pzSW4oIul0+XwhSi3JDiTY3+QH9iD1fV+NfQF
	 IG+l2GCkqZAWgbysVRUs6Ub4HfSHuEHvXT5Gmy0Ssepk9WrAoKFOeQ0g3QJjgoaCBrYhQ
	 zUqneUtzK2aAFDH5XnhQ86aJsuDj55DFAh8DN4UFdHvPBHJUZlLS++Olcn85V0rmttQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=xC0ized8;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9094606A888
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 15:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9094606A888
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=xC0ized8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0Loohs0l13RgnqI71ZUmljjW6di5rwCdEPkxPKK44G0=; b=xC0ized80oVltVLkIP1G58o6/j
	zsLIG31zVdj3z61ODLWtES7r64Mv8HJWRUlbgUukPeQeJvwNrw9uaF5H3hL5wz6QSguwuGpBGp9hS
	OCheYy1GxJnK9Yra0iht5sfkAFPnNV1tj82tnypraALvwz7oq8V/cXEla4Xai++uNgqQwBN5H/3oK
	SVeanXaP1yphQoVYObXAWzzJYd/ho5uw+BEK0F2kVG1wx3WvwNLmmtWERZnVKSCTOnOOvUsMsgpHx
	0PjERZqZ2dul+e4ivUU3dJGhjXsGfGIHCKL09O8yyxABLY3xb5Ttc0LKbIUaU9twTPEYjRAyLmPUl
	gXkGbAfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR9xD-000000073ZV-06fz;
	Wed, 11 Nov 2026 15:09:39 +0000
Date: Wed, 11 Nov 2026 07:09:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfsprogs-7.2.1 non-parallel-safe make and some gcc-16.2.0
 warnings
Message-ID: <avSFMsqoo3wpWMXH@infradead.org>
References: <20261108113039.08688362@plasteblaster>
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
In-Reply-To: <20261108113039.08688362@plasteblaster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Thomas,

all the warnings should be fixed in current git for-next.

The build systems in xfsprogs is a major pain and we'll need to find
time to replace it with something modern.

