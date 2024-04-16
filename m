Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2C48468
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244680; cv=none; b=DrHMNDZ6fDrO1amb/03OGoy/uL0TG9uEN1MhdL1Wqr22/5+yABWl+BoiM35SXojVox1rP72bXdJCxFjF4wF4/m9XblKScpFjK1YhKJOQUo7gmjwGeOJIz3ihNyRprnhwSwb0twE7kC0IVusBgyBa7zh6dEZQmLze01eQ6FFTEvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244680; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+GY4fXlvQbxjGhanbpwZ9RYGpH/LDmCDGvhcAyskdZc1N+fDNkgtNoWkwoybjvcaTWvyAr2+/sT9sG8r9/nxbnFzpdYVeKAVDk2e645vrU2HZ6bPESjEURLiYIwdCaEQlyqDis30maa+us1s2rFmyxexq3/Kotc+1Ez4q/RLjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qHC2wD9X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qHC2wD9X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qHC2wD9Xa05jUZofjJPeBbmJ1+
	3u5N/38FV7FK68MACAB/v8cLrHK0NXRa9/YCygFDneokVOHzQhjXMqc97boXS75XW0XJCUjMaMymK
	eULChCtF1gyfzsEbnpn00m944uCCd82S5JoldmME1clhKof7zMQMkZq9+zPSsEVwFVQyFKqIfjHih
	9Cw4Rg0pDOzBc/JPbpkbc5bqBEtFfkDzbqrJIAVanrfuu3sYQqY/FYwlzCx5d6/YLE5PiGu4ZMkCh
	55g/RfzLyeuccJIDAbGBImhR5AbprhA8PTBwflCwejiIyDaGLDQMebP1EwmJuaK9/GkwdQ46e0Cm1
	64gVZs8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwbCg-0000000AvPZ-2UTm;
	Tue, 16 Apr 2024 05:17:58 +0000
Date: Mon, 15 Apr 2024 22:17:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>, hch@infradead.org,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 21/31] xfs: don't return XFS_ATTR_PARENT attributes via
 listxattr
Message-ID: <Zh4KBrq3X-tgLESH@infradead.org>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028128.251715.17144732888350103618.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323028128.251715.17144732888350103618.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
