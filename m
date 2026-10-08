Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C176938734E
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 07:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791443862; cv=none; b=elWJ6wLQsOK5DoKQRPqtdvOwGmwaBBBYJVRhNAtoqY82Xp1YB8UcyqzfT4niCGDF8Du6+LjGrUeo7BavOsOlxsW0Afcankz6a8kd7g8y3Z7XxqkouwiFZtLE5QRshNQQZ2VXqhjT+VLJuU1c9bbfz3gMY/jHvHIXBEkGsagzQhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791443862; c=relaxed/simple;
	bh=HVSmKFEfEkLceeHvrpvGiH7TEw/6XiBgWzojREthZqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXGZ44lbP2pJcdzc1ZoxJsms3qB9eIuVdItsfnod4+FSEjcKoZWzeM9MxfTVU9Cf0UwxPn16OtrIkZ+j0/ddjRLrL3s6iSpGdGZ7NsDGqkKL7lP1wKQBrzLGEo4pYw/ynmJ8FerAqXs0K4w2FAS4uY7u7iUpi0J4Dm+8e8iyj+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k7xm0xgT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k7xm0xgT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oJXwLLykdtmNnYwASRhWCbNOjOSyy4orz5BVriATGOA=; b=k7xm0xgT82H1h7a51iVAtUf6w4
	RFvsH7edjKkoK0XH4ZstMLnhN8A+7rN72fnwB3oEIWbRI6dYYyAmXu4xiIs2ko4MgywFF8eILaGaJ
	GySPTBQMRHrkkEB/AER89kGe+udE1uW/unLBS/tKGxAITOVT0mm3eIAon8IQkS9Y+ndTLb/IZX721
	lgM4aA1EhLp3v221JEtbJjgsSxhmFRwrPOe3TTcZhVU1MA/3tUD0oBlLYVqq5rwXGasd77ncBcETj
	MKMMzjawPaAg8UzT1bslVjGuPluSIswJC5zhpD1/W3Nz9DYXv8khg7+Pr8eFWozmv2RlaEbOMORbZ
	o/dIMRvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEiNk-00000003j2c-2iRC;
	Thu, 08 Oct 2026 07:17:36 +0000
Date: Thu, 8 Oct 2026 00:17:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	"cem@kernel.org" <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Message-ID: <asdDkOgueZHx0UVz@infradead.org>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
 <20261006144851.GX2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006144851.GX2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 06, 2026 at 07:48:51AM -0700, Darrick J. Wong wrote:
> 
> I don't think this is better.  libxfs' init functions do not create or
> assign the libxfs_init.{data,log,rt}.name fields, they merely reuse
> whatever pointer the calling program set.  Only the caller knows where
> that pointed to memory came from (stack, optarg, dynamic allocation) so
> only the caller knows how to drop the pointer.

Exactly.

> The original patch is more appropriate IMO but seeing as we're about to
> return from main and terminate the process, why do we care?  And if we
> do, shouldn't mkfs also free the other getstr() strings attached to the
> cli struct?

We probably want that, as having a clean xfstests run with addrsan is
actually really nice to have, as without that the addrsan support is
only if limited use.

> And shouldn't the exit(1) paths do likewise?

Maybe.  Although it doesn't really matter all that much.

