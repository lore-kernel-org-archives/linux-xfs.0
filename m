Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176258468
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244865; cv=none; b=q4GEwcp+TrIiJaXt5ZriHkcBRK3+/bYlD2C4N89VquDeBc1x47e1liUhZ88qcw/ckZ2aTPF2Y0lxooLh0QtTXaNvgt0Kvtlt57PLtVbZ4h5o3B59f/pCrai4YvbDm6LxcZtmjsUCEVaFdWPQgQ6xwrx1x4w+IShX50jWq4UJTnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244865; c=relaxed/simple;
	bh=U0KYnjznHzuD/2kyxGKHD9Zjk0A/BTcYC7+Goqr5oxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyJsKWArRRfAymdkAsAfZn8KFLPJeUi6aEC5ygH+HUPH2vEUFM1Kp8J5F0UBiVtfWZl2Uy4mSbVuVeF5Aue8iyTJ9e8CxMhWCXtTlQrFa7NhtZQpA4iQy0P0zTCsSSeJk7NCbpGB2c3jEaEBX/Oem+mw1Y6CQV4knS65f5bHGqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xvOeFEYu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xvOeFEYu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r2XqoH5eeteqUHdSzwngD3QgNQKlhO1VNH1M9o2JDOE=; b=xvOeFEYuL0/qvAI4Ok+bLUKXjH
	fpwNhg4YQCJWHRBak08hyF1D+GLUtQTWQb7hmRK/cUjuETKglH9FwQMPF79WYuIBqIG32lxFosYUn
	GrGHI6ujC6Np0I90ZQVogdORyylfNkeGaHjeRIWDVMiVUNe0xQo1RfkC5zlsKaYbph89OTDlzYIqd
	c8ov/eCGRGV1z4cfRj8b6pKy92zj7p0GYU0NVKrvxjd7w/sjDvoyV2S4iJ88d2FYDtVkx1z8SXSlI
	W/8ogJGB8H++JqkEFV2I8tmb3e2F1CP5IKAXWWK6/C1HjWHb8ofUIRt92ZXH4KKA+nB1iKfhLtTrh
	1stZke8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbFf-0000000Avd8-27yp;
	Tue, 16 Apr 2024 05:21:03 +0000
Date: Mon, 15 Apr 2024 22:21:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 26/31] xfs: add parent pointer ioctls
Message-ID: <Zh4Kv9kTzBbgBxKC@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (memcmp(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid)))
> +		return -ESTALE;
> +
> +	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
> +		return -EINVAL;

Maybe we should just stash the fid without the fsid?  The check for a
match fsid when userspace already had to resolve it to even call the
ioctl is a bit silly.

