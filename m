Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618863;
	b=OPHNUT7WzeaazqDIVamtbjHTVAPpZZsQtoUbUEIjizL0o9T+QtvxVbMZCP/X+ixWYUma
	 c30As8OSDAznMIsJQdk50f3s8Lj6+YBL2Qnt2RhauWuaml1XX2+FgdnArgVAnLgTCi61e
	 jdCCpaSUCPqoNOwPNXznbes4ZLfwLo4GGl5CdV0EEqyuA1Q/1ROmiosabIMfiWJBTCLHU
	 dghGy4HvZNBh1E0Qja56mEztaeCkuyX0zhkpEr3oMUZbwhBexq/Q2qXmjImKqheu99nS8
	 goFwTAmFNrfeznMx2u6DKJYi0GEliQj/7K8utMqno2Ac0f3xe8+RNCzZJuEG7K7IuBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618863;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=qKCifnF7a/trqLySbGgnu5Pm4QLd7cXNu4DdK4WoQ6I=;
	b=eUW7RqOpz30xJ19DfosvVggHufmqvEUj6OXYn0owm0iS4w5bZiHlcSwa1YcjOPL1RnDA
	 BcMF6Ec6GDAijGx8pXRoxHvXyuutx9FnlCJieY/eUqhf+Wng8Fwl7r/yI2MU74J5WIqjI
	 vuxjZNVvHggFCiV6a5aZ7TrKNSu26NAn5pI+yp/DKBdPvFNickJXzu17q9nRDSqafXUcl
	 WYPlzB5txxWRKylsEXr69fry8Lic/JU0cDvzUDwWchuC6zi8Nfun6zKPkf5oz4xD/RpcD
	 hgv6kcAJcWJUMy5Lj3v75ooZXnpEVj1hbFo3A8WiD9xvITBi8wlQfRGzWdcVjfGV08w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=duiWvS69;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FFC606A321;
	Wed, 25 Nov 2026 15:01:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90FFC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=duiWvS69
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qKCifnF7a/trqLySbGgnu5Pm4QLd7cXNu4DdK4WoQ6I=; b=duiWvS69yEdr7WrbRRd4JLazCh
	5/qMtP9P/BiFeeu7OAb3hfeCgkzQ7zRCC3e8vTaDwFBJx74arFtobmXMB0WMnhQlxOK114iJ2MjSV
	pO1BG54JNHQwFLjZT5Z4G7kE0hlZ0xzp4iXUCHAsjty/6FXsNDQDSZoDLgmvZ3SL0+qF50oeeBOTu
	1Rt+WQQOA/56fsTYI9bsUorZ1JHmP3RNKNHxtHOPT/Vqhyy2SqjrM5x3ycfJQgKnZX7ADzvuWn0W/
	L4insFfmKvBMEc0366aFwaAjTaNsQvV9tLm2FAuzreAvfWZibf+wSxhSxGfnfQalXUxzyIVNTbtuX
	A6hodg7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEUW-0000000AHeV-21xB;
	Wed, 25 Nov 2026 15:01:02 +0000
Date: Wed, 25 Nov 2026 07:01:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: reject a hole in a remote xattr value
Message-ID: <awb4LGfKUaKJNMiU@infradead.org>
References: <179559978502.2875040.12926533524466805036@gmail.com>
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
In-Reply-To: <179559978502.2875040.12926533524466805036@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The local variable makes this much nicer, thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>

