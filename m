Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115877;
	b=waz0VWY43gpv4BrZu8M+x++T+Q70YqMdD6kliXR3MpgEeJlCeWJIhx3y8k2FRnJ3VAwK
	 qCHYRSp9bD1eO5ynMmz68B2/eev0moaPIdBsnucmulDQYoWTHcKIEPousbQm6IMK0b6px
	 di0lLooVVx5w7kv5wYQWl3aVwzTsyYWMh/YeQ179JsP/BH8Q6Kgp2US1TnNDhzQiEDdP0
	 l9LiSnMfLgAJ/daw4jy/oHh/63o0pKs2K58EgIwEe0kY87xEc9RYEd48h+8TpTUSot9D1
	 e5ZZik6bX0y2coKG9zcn+SXOcvcijyD5SpszDo5mTF/iSjat3iuRg6e97Y8H3/zlSEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115877;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=4L+BjMr5xEroooA1nxT/cjtIFRwO412iU1NmnMGoeMcS/DRqkAQNk1g4NVFlmoYDw1Pc
	 raK8JBerCJM8NTBbZhDr1yYaAAiccpY5YGQB/e23UjXbPIzIxCZNM/0v7xCjeSYQRrzHx
	 dIoc9fZLe1D8CKkH5PRKHZvtk0rgBKXm4m9VENqOauBO2UQ6Nt25XnKXXL++tj+ep2Clr
	 iTpozjefZSgbqLlQNAzdXoUxYGNuMCMP41PEwrgGazJd36ayjUKrx8ldQNUEbEFz/UCzv
	 Q8AFchOENia/G8QlWIuF8aTNmozxQsfkT+A4l8xsy1U8Z/l1XD+hDX3/Ed+Py/EV38A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nNZjPWR3;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD48060A3827;
	Tue, 27 Oct 2026 15:44:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD48060A3827
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=nNZjPWR3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nNZjPWR3HfdR6gBeyQjFZsC0uL
	cwqQP1RpHraqUCTu8vhqyFiaTqryjmCbFWXoePCGIw/n6Dig2NjfvbF4q83wrBZrkgtto+xk9Wtd+
	pCSJP5iZUneI1PpqYiQwYp6AxeBB1orR9ItOmkm92NVGLMijYS7ql5WntIKAjpx/32FQjs7o5x0Ya
	Aaci1gCoMMDdrKhrjaiy+dCkqeEtU/eULkwrTwozokO5PhvMSfzrHVdOf4mxfG1dpCrJmzlx4oCzY
	hDv/cOCudUuQ3JKHQo5DNoRI1OMVsU1Epd7lpFFg3TcH/RyT/gtV42S/ZlE2tAZzgaODWWGSrHGHf
	Jn2x6kAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjLo-00000005GDB-1sjc;
	Tue, 27 Oct 2026 15:44:36 +0000
Date: Tue, 27 Oct 2026 08:44:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ravi Singh <ravising@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dave Chinner <dgc@kernel.org>
Subject: Re: [PATCH] xfs: mark i_mode=0 and shut down on attr fork
 inactivation failure
Message-ID: <auDG5Dy2vVQgYeEE@infradead.org>
References: <20261021063329.2853484-1-ravising@redhat.com>
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
In-Reply-To: <20261021063329.2853484-1-ravising@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

