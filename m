Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF001E7C18;
	Thu, 21 Aug 2025 08:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755766040; cv=none; b=XjbXcOjWPO5HK9zWeI5ye3vxr8z+NsNtnPoFUo6n0qfbuFz/owOO/jIEYRglF0GlCJ4JMvguaYJpcHT7gTcro7Dgbfcg1eWgfvzSAL8p3AoClvDCb3FunS1/UyxdUIa++vRk9hA7KI6SbA016aUzgyJ95N7QaAnUJyNXX9kIHxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755766040; c=relaxed/simple;
	bh=DlYEcUJLsw/MqzOBv72trID2YohXF6ThfaQqc5nFqts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2WBIl/5x0CtqB5kBZiRzWpGJCiJxsrUsv8fcMI0hJrea7mWnK4xkEET0Izrxrqd1//vACC686XgM5fQhj/sLB+5so+fV4cSrhf0gts8DYZNcZoxgylHA2wnhBgzANzrBV6VVyWxwHdXIyAUN+OdHoA5aGNtW96dGEGY4eQGnGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fWENBFe1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fWENBFe1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mh/S+h5QxhKEbHlGF8hYN24btVqVDLaiV8YcyYE/644=; b=fWENBFe16pOMAhbCXyM4DqUIOF
	LlAtLPM1aQ6DWsawNjzJJIq/HjYEDZaa5jG118IDy9XyDkq52D3hXO3yUADzBInVISrmSGKgt9ner
	8urb+gAVKzFR/aqOUdbgGUrEa+natlf0ipzLq7ypJ3jsVnefg1pezXki4J7QYwBlQoIxoDjYNq/2L
	noSpdE6KVIHt+APXXujuDDZg8sL3Y3aohkPigYeU7o8VZ2Q+a/Zo5t8Rm4x/PK2wx1Tv0JERXbG0I
	D6d4pwx6PmPZq+0v3r0aRVz9Ne96/vQUOKZlzbfIZQjKqzCknxzBnXnC21lwvFDnmjWdZltyv5+za
	dkrketpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1up0x2-0000000GIiw-1acc;
	Thu, 21 Aug 2025 08:47:16 +0000
Date: Thu, 21 Aug 2025 01:47:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Marcelo Moreira <marcelomoreira1905@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] xfs: Replace strncpy with memcpy
Message-ID: <aKbdFONDSYp0FxSg@infradead.org>
References: <20250817155053.15856-1-marcelomoreira1905@gmail.com>
 <aKKvjVfm9IPw9UAg@infradead.org>
 <CAPZ3m_g+KcJt_wxBjdmvyW+FqXAcEfVDUuHkp8iZ6XiUZ+6x-w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPZ3m_g+KcJt_wxBjdmvyW+FqXAcEfVDUuHkp8iZ6XiUZ+6x-w@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 20, 2025 at 10:47:17AM -0300, Marcelo Moreira wrote:
> Hmm, I've sent the same link to other people, and none of them
> reported any issues with the SSL certificate. In my case, I'm using
> Let's Encrypt. It could be an outdated certificate in your Firefox.

Turns out I was connect to a corporate VPN which had some man in the
middle thing checking for "bad" websites, and they somehow considered
your bad, and their redirection didn't work.  Sorry for the blame :)

> Regarding sending it to the official xfstests README, it would be a
> good idea! If anyone here is involved in the xfstests project and
> thinks the post is good, I can send it to the official README :D

I think for the README itself it's probably a bit too specific.
But I'd love adding it as a new HOWTO file linked from README.

