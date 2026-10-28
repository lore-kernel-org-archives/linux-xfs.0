Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202712;
	b=Nd8HCiFunVMEZX6bLIqTjssSK/rqunIJpwoii0uQCUWTM9EzU/O/ecltJCo8ByH6aiXd
	 gmq8aL7ySROKUf1O8Jpk5jBjbS9E0Cg/FZR24tTkFy41s5m6hK7bbsADAlmcdD4ZIIz5X
	 KgA/cJ+DBTIwNe+MFL1C9Cx289awF3k2xZrw1+jR4Vp5gNc5/TWO0Q0HzfWdr3uWTORL/
	 dQgbTw5KjycOxpQhbBb6nmGdjjZQv8+p9kLBm1PPURCD9A3RdcA0JUsoBCPOlJlMb29R1
	 0FzwrILlrvZZNJTxd4QNZKU95uA7WMhO3/aB0WxRwf6cZnvYxBgIOLdjYRkkN8JjMbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202712;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=OybWytafnze4ucf8FBZl/wW2oJbmxAnKzwyJvow8l7U=;
	b=Cu3tcMG8+4DbkujA2j9OEhpYUa5zFysNMPeVfLOpy6o4KP+IRZgHMvgzFEYU7frA2Yq0
	 8WTGZ7zJlAHUc0MSODx02ApAhhQ5982i3wT6Iwzz0KXHY7SDR2mLxLlJdB7qVEVf2nByF
	 14ysvTwNNlNYLXZCDBx9+T3LCvOHmA4+dJsegTUJpKCfBsNU3hcTLXeTT34GzRnJBYnSO
	 6tMYsRd3gzY8BxNw4Cx+x4k7Pl3L5rSXJXGP4T9/ceiRp4nRIU3jSYWvhO9K/jWw1hluT
	 Lu7kvJLTtTkbjI1mO97y4VQWGmz+po/W9kYJmsQgY6FtM/1vs6qU07J/IT16OpydOYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=D59tpPtC;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7357606A31A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:51:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7357606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=D59tpPtC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OybWytafnze4ucf8FBZl/wW2oJbmxAnKzwyJvow8l7U=; b=D59tpPtCdZ2EAUmRYCuF2UKWZJ
	hpFvqZ+yPa3vH5wMi0fAUh/Iyk223udh5gSyTioGlAbJoYPQ7uIGK5Hj/DVi6QGxQ3bldEKex8sFi
	KcOb3MjgYxf9/BnKgHJUyi7NqzrP/33dws+i2cUn9jLcnvc/T2Sp8roGeOF6xTzL6YODCEk2AmhsI
	mYU1UFy/HdnYpJuxIwicBnLOQqsYZVvdpDUwNLiwbnN6NyxEU8rfjoBVpdFmx0r/RR5Bbvs3naFvI
	xh6A7MQNNGGO5TPmj2hRfdKs7Dxm0t+I2jYEpn0yH92OmzVrfd//OdspOSkLhX9ZEfkG580w07uiz
	Or/8rwJw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5wN-00000007T31-1rjT;
	Wed, 28 Oct 2026 15:51:51 +0000
Date: Wed, 28 Oct 2026 08:51:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dgc@kernel.org
Subject: Re: [PATCH 8/8] xfs: remove status parameter from two btree delete
 functions
Message-ID: <auIaF8RzY_-tYz50@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-9-sandeen@redhat.com>
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
In-Reply-To: <20261016193422.1630907-9-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 16, 2026 at 02:29:08PM -0500, Eric Sandeen wrote:
> xfs_btree_delete and its callers now have no need for the status
> parameter; either they return error = 0 / status = 1, or nonzero error
> and status 0. No caller evaluates the status variable, so remove that
> parameter from these functions.
> 
> As requested, convert all of the compound tests/assignments to discrete
> lines.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

