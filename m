Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B93DE423;
	Thu, 25 Jun 2026 12:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389980; cv=none; b=oboex14M1c/2DeB5xyXgwSV8kcRa8p+lB7vt364B2JvpfikQTr9HV+Ib+XK7eU3eHcVzvdg2VE4v7OhR9eoSQXG1ojynKw/DysdnvkNApOihSugLalREM4+WZ4SrrmHYXvCDph6pbvZWRP5hMIA804WalaDyrvn4KHX6cBB7/d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389980; c=relaxed/simple;
	bh=kiJqrMewwzSXMDaE2GkzDaJHN/fYpfLjSugceF1aUhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dK66nTpgVS1CNIPqb2FKGnVsy/Ou0nDCD3qHdlhvKp7wmUA5DET1t74LoJDKzC4Fqv28f0KW1f28ptP3KVfWtq7pTyC2vfsnnSTmk5U4xVgHq9XY/ULLcg/pdK+R9ykBeZqG1bm5iJ2sixPs4FMs9XwH+uosoeDlPDq779zW090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A0Vmv5u5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A0Vmv5u5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=diPDiTLoIfzsECeGhf9/bjGrtVCdsFmk3sSZe7cT7Vs=; b=A0Vmv5u5L3eTbVtxCtaeYQgHXD
	lP3BZqocFI/F/9S6MhWaP+U6UF2q9jFXcbw/gEXfqo8Bi1qs0yMY37HLwI8iL6O8BzQEAzZBf5643
	jq9XXoBXvmmI/gjdjZFI7wkWu1u4KkApz/Jii9fMexRI5SFBsgKT1sWwsRy76PK+U9g/X+/u+4V8n
	LWmYcFG4EOUCRWTSC0SZwu67sEvo26PQLu+9/diiWe/jLyUHfm3f8AOxkwD8PjHROWhuGCD3GM99M
	SOc2LfsTUM18LBnN2igznoXlzjGURnJIGdheem/hAM0tg0y7OuEgp/UKxvjuKfrzqUgGgTRpCVN4N
	CAO1e5nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcj3S-00000009BAv-0iad;
	Thu, 25 Jun 2026 12:19:38 +0000
Date: Thu, 25 Jun 2026 05:19:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
	bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, andres@anarazel.de, kundan.kumar@samsung.com,
	cem@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v6 3/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <aj0c2tziORZtae3j@infradead.org>
References: <20260611114029.176200-4-p.raghav@samsung.com>
 <ajFQPANpajmFuKpi@infradead.org>
 <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
 <557b2e5c-7c65-48de-87a9-6fba21eca99f@huaweicloud.com>
 <0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com>
 <aj0bNstaTvy3HOkh@infradead.org>
 <b86337f2-5aa5-4905-9610-35fafed2018b@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b86337f2-5aa5-4905-9610-35fafed2018b@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 25, 2026 at 02:16:11PM +0200, Pankaj Raghav wrote:
> I have already created one that does a subset of these cases. I will add more
> and send it to the list soon!

Cool.  I'll wait with reviewing the patches until we have the tests
and agree on all these scenarios.  (and because I'm totally overloaded
and am looking for excuses to defer work :))
