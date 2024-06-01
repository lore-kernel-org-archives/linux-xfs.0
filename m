Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3EFD2FA
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 04:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717217534; cv=none; b=XlpxkBB1ti0g9voPY2bxycPKY3a3zT+Y6c/VolXFHXpDy2zRzZWakD9ubn6SCAx2895QD2jL/CKnbhZqiTZZc8yP3hyqP1m7RIovNnOuKDvcXEv5aADPyg/59Oe3visO0rqtCJif033Jnl1izaKXCAwDYn9e1Vqt8cTbTcSHFkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717217534; c=relaxed/simple;
	bh=IVP0GhwYQZcr9/4+Il2VLorXAhqx4Jgg0h8Fc1HisiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsBRss2zTj4VqwV+6u3sbQVNzAIawVd5sBbgsJqkHelEqosj3wS00iJ/wCn/clw+0HIRosDvTNIxxSaqDtsm/twAkxIY2jNy915KnqdTWTKLr3NWQcJsTKW7Od3NVWtNj6t5s47IHzMZgK3hNP7U7aKBP2GIENC7+LMgov6wQW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nJZ29mRv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nJZ29mRv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dFRJ23JWevxOI3Dx1ungNmlfKzv2tu/srPqLgKr3xuU=; b=nJZ29mRvgMwY07PDom8iqRpc+i
	0ADutQ4A6PusD/25m0H7xM5HJMt6EK7L+gZCXfHw9/9Ynz0105skRuRz3wp1GTsYMd4ghNWFJ2T+n
	8p7sbMOmVkQnJnixqkFje6xUpdUzzqdMLDbbXNPmuPTbUqagGbekuw+AiW9PqmziDp1OeoYK/phvK
	f+BXEisoInJEpeXp75njnoVSUZUanq9gJfuG4eidthhmWgVbwJu3Y9CRHnneVYyXRvmajaQ0NJica
	5Zrht5H9KsC/hF7JaQJ8dsNp3qgJ83DZhgpqE2yJMMtrMvh1i6XCy0RQ5Nbz3Jvqi15OYoaY/WHLw
	kqwvTtVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDGix-0000000Bydz-2oQw;
	Sat, 01 Jun 2024 04:52:11 +0000
Date: Fri, 31 May 2024 21:52:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: make sure sb_fdblocks is non-negative
Message-ID: <Zlqo-zWI2UUI1lXf@infradead.org>
References: <20240531182918.5933-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531182918.5933-1-wen.gang.wang@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 31, 2024 at 11:29:18AM -0700, Wengang Wang wrote:
> -		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum_positive(&mp->m_fdblocks);

Please break the line to ensure it isn't overly long

		mp->m_sb.sb_fdblocks =
			percpu_counter_sum_positive(&mp->m_fdblocks);

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
