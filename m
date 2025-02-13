Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22632054E4
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739419559; cv=none; b=dfdbLqMfADmhapCo3OJW95IIWO3DamgC2WgWfMy7G51PC6ob7LAbCSBTME6vktguRXMn4iG2yrbjUUVTry7OO4KUHIXn4dfV7xIFv8HfJyqDsr3s+sUwhTX3XkcoaIpE0uxFoOISdCmaKgNtPPdPRBQljIrqYxz18ZnYXaDmXv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739419559; c=relaxed/simple;
	bh=+UAwf+cPnuK1T41mezYyyvf7E8xIXOVTA6bYOf7iQDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxmYUYh6OhycO+kHTHXXw8hX7b9X6zTVm3Hj1EN7RPgCgs9XwN3zB2soZlGlsvbrjq+z9N79UOvUU+bWX7rKVHCwldpC+YR26swpULTgNobiZiNq4popCc3scJXqiShYzq3to3/pdHUSBL2jF3DLm753uG6dTfWLLX5EOQjszYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TfYw+jWS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TfYw+jWS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b7vvxGAknfkfCLhMs1DQqlS6JDutss9pzHAp0PBEiXU=; b=TfYw+jWSDhhZEWLw0XbtGUHzi9
	zktkvxhvpwzHEmBYwN6xY2GaioEjGziJvVSQBD+HQV3I8iu0mpFDY4igPDAVduftmpF7j+Roi3UT3
	AXlCAGj+swOJIeLWed2kP9LIcS/BsuRcMYntSxi3TiUWEBwoDQ3+9hnxxqzXfRcnBY4zedJ4v05Yk
	Y9BxQe/qF1+bMg4hnnc8zNZ+HxoIsg5n+eNth4CAJgFBCk3YepQzp0jgd1JHIGZiBFs7d+Gx7HDNi
	W9uIa0GiYnw3SucgLNZb2inZ03Q/hoQQhDZjFzKcIXKaQU9vLtpxeid34sTnSTESkJ1A47NNaOoDj
	XTv7oPRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQU7-00000009fOw-3Oxx;
	Thu, 13 Feb 2025 04:05:55 +0000
Date: Wed, 12 Feb 2025 20:05:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] libfrog: wrap handle construction code
Message-ID: <Z61voxnKjM5izf45@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
 <Z6WNXCVEyAIyBCrd@infradead.org>
 <20250207044922.GR21808@frogsfrogsfrogs>
 <20250207170002.GW21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207170002.GW21808@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Feb 07, 2025 at 09:00:02AM -0800, Darrick J. Wong wrote:
> Which is much more verbose code, and right now it exists to handle an
> exceptional condition that is not possible.  If someone outside of
> xfsprogs would like this sort of functionality in libhandle I'm all for
> adding it, but with zero demand from external users, I prefer to keep
> things simple.

Ok, let's keep things simple then for now.  If we need an external
version we can still add it late.  And for the future reads curious
about this maybe add this explanation to the commit?

