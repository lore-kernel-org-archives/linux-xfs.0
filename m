Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96012D4B47
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 12:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751029089; cv=none; b=pIExGrU3tkqBe+oXaGKIEW47mFxn2X6q6a5bL1b1//FVwNTNmgrXvNRHkV1OSK+cCw6xG7ROZgR22Xj5d4MUPTQNjOezjRct2ZJSZGiX4ibK1u2dwMn+jjOVESdQZuk0JNJ/JVSLzEIY89IrxP56/ye2JTbRgoLXsAwfzL+KuWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751029089; c=relaxed/simple;
	bh=19MrupmGWhbrvhDHUMCm/mnT38m023M6t+ZPH6rvXb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhI7O/rSrrUMzvtOoERI3lC55kR4eDoSutPT5OauCwVQqEtbC3HL2hp5Dm8MekIfGhO58MKla1nQpcGNxWgjIBp7NFK/Pg+AGMQlIjegLNmVWZJigD1FxxpmufC3TnQQ7nk/9Rp/XnqY4Xx2UQnATrC5D20iCRcvGqUr9+HQEzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qvgjWb4w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qvgjWb4w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xpkdGdcwTFuyL1wZpDNKw6mE0DOpHqPtQ+6a5Wl9DF8=; b=qvgjWb4w2H0ZDEAHK4GuZ2kpIT
	qCcnkAuYPwmkjWWDW/Hsb8mNjyG2zG/nF3lBVAA76Hj+L7xjpXLwdTyweGp23M1Osm2TWximq2+9P
	eQgxi3epyDzSMw1C353dNfJqNwGP6spptm215ULtA0lzy3g0l9tb9+eus1gvfEJZqG7kv4uaKuRQx
	v12jCcOBV9HiX/Sp3IvOfxoNy9r/zdgxn8jxsWSENwAFA7/AoXrXe/SNo1y1GIYrdrQ2RWqX/CyM1
	y59k0YMzOhkr8WeWGnjmJjfy9P8mIwAQ4Sa3Cwqo74aTKnxfRcQ4WBhGJhqJnHag/ADCnVWx7A/vU
	uTG5zFOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV8ee-0000000Ehun-1usJ;
	Fri, 27 Jun 2025 12:58:08 +0000
Date: Fri, 27 Jun 2025 05:58:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f259584cb40c
Message-ID: <aF6VYKOp4JutnLme@infradead.org>
References: <hyw5332gxstbro2j5lswrypary3h2snvozqw5tszboku4trals@3x3wntciy3bi>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hyw5332gxstbro2j5lswrypary3h2snvozqw5tszboku4trals@3x3wntciy3bi>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Btw, I assumed you'd send my fixes from three weeks ago to Linus for
6.16.   Do you plan to wait for 6.17 or did you just not get around
sending a pull request?  At least for the zone allocator shutdown
check that would be annoying as it causes hangs during testing.

