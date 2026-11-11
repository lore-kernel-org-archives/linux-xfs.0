Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410116;
	b=PHKr97+x1zekXjHGNUP3sTlccBAHxx6cpSZ4Y2vbkrCy0e/iLSLK0eXh5PFxKeVmiplA
	 76/1ehPbxMMZBdFD3BYvW401poOMtS7Wn/LtLyzkCh2DX4qYPGPF1yehCi+u4Exn1yESO
	 FIKMu8M1VvQ1k14BowqfYK639MpB8SiYAl7ULelxcs9tjRpMg0rnHlYA17jDJ9QDlzeJ6
	 HMg1OlYQ4tpe/vVPgbU9cTld1qNZCpASQJrG3WxInwMlrYKyvKLetXdA7MWcockW0XNf1
	 VMtOaxE/P46FB4LldudHPMnwqIH0zFBvIkHayLXSIOh0TlPHrE4W7tuQPdkVjl83Yog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410116;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=dZ9wHOzmBnq6hnSYf7T/mxsoyeumDHCL723twOr4xDbxiFpKa17VQvMpxfkhEAbeSavO
	 MEVDSUEOKOFU8jOZSLb0QDTpzZVyLob+Xa4GJX1l48wvx2Ohk02hO/2J3ErOZIcAY4+5P
	 T8G/KgyMs2xRvgCmBoMITQ/W+dGKXd+92TGRzHIMNOx/1k0+cm9RU9lZyAOvrOMi66b0K
	 VpR8LVdSkfZJnv/J8NkDz18PE2lk2wys+DaO2uMbXzioIZ0Xtz4eXDXrcIfconi2YrHDn
	 ari4Brndx4WulyHTiMfU7NhW3tfouu/2QeACcjSIsa3lGYpCVVUKhyIhd20bHEhPBFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=shy7eKLr;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB81F606A324;
	Wed, 11 Nov 2026 15:15:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB81F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=shy7eKLr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=shy7eKLrtisqtWDKu/B8UJCAni
	fsO0MQ5212gAPqahcKIK002nwejZdIXBuQr+7JH+bi7RIVb4cwKkGyqVaLGcIEShQ2h7K1/RpWrEX
	s8JcTGIHQO/38BGPX0b0WHlP2wJlQ6p+uA6JKFkOWfx75AM1f+vkBd/y/JB84g8P35MloxVY8guBB
	MTa5mzcgK4JaAXTCTKjmuJGfCMwf1y8Gew2uoc7FyY/NB4M8tdFLX7M5eDzp0jyqVSV8uXblG0Dl4
	s4cEt7+QlAvKMmaSf44mCnKihYUop6ncNE1d9j4AlWUZIMiYAj+2EPrQQeIHP1ZNM2Zy1lFjHhtpB
	Yo3MMK0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRA2a-000000073vw-3lVf;
	Wed, 11 Nov 2026 15:15:12 +0000
Date: Wed, 11 Nov 2026 07:15:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v7 09/11] xfs: test for always COW after the dio write
 checks
Message-ID: <avSGgPbwyXvMvGzp@infradead.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-11-mason@kernel.org>
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
In-Reply-To: <20261110190417.32650-11-mason@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

