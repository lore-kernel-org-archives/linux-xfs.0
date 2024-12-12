Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686A81420A8
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 04:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733977382; cv=none; b=XSNtX71u/PI0iYPgoQa0jyUqp+LkeiX3hdHez7pLnIEqr0FDdEjfvNMg8bU7zrR65VX2lwxa4jtxLljlPsMzq8Al1WtZx7TaTwmcrSeUZ+OG2bIsNZXfYBpTJ8Bikh6KI6sQ0XBZEJnwpWDQKJ5txYmVite/qey3Pvv1aZMM3e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733977382; c=relaxed/simple;
	bh=ffYVTkp9NSqxekGLavmiHpiJQ0Vz4dS1meXKLdUDQu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcK7Z6Qy9AQXQIdy7bjURRZrKnEaH728F+AdYAY0p5UYuYHtEBXl7vsFRzmh/oarxTFJj80V2OTyQO/Da+lgXapSe117MopbZRD4Q/OIav3qwWuSDjuPwl7tQRxky2SdFd5X+bY5FfTEBEztgpceaWg5K8ej1/sap1N+VujC7Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o6oZRiRq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o6oZRiRq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vDvbgwPVFlk33SidQ3YGpLVoA2+yBRxgzmh8h2UvKqU=; b=o6oZRiRqNPiarqlpFC2sI8mfRi
	rte9OvkaOFZtLkujeJ/+iwzMJvfccZU+/GQhUh2g4TTNaFxoSNSt7aCP6TnUTZ+Y6VCoke1fFXyle
	/NMRWmMADSI+BlqLs5OW/p3XDNLQV/RoQizOBKjyRHNNhimil5ATrYCKK65F4++1Yl+E2j5mBj+JL
	nKEs8oxE74Sh29shtXiiGbGexxmiapL1qKlw8wU4g6x5/BY03DITpMmKYytwKEFbzYh3Qy7C9z3JC
	HwYruz1KA4fLx6+CdeIVUc5yQGIsphSpP1oZOZm0sq/pFkknhiJRJT+Yjh7XoTN+zdy3qoumfr4lj
	8C2pqNiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLaj4-0000000Gt2Q-348T;
	Thu, 12 Dec 2024 04:22:58 +0000
Date: Wed, 11 Dec 2024 20:22:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to e2b718c00102
Message-ID: <Z1plIsJ7ioP2ULxo@infradead.org>
References: <v67tb43qbrzmqvb3xwl3oav6walexakrdxywlfb2dbjcg7mnne@vhkxkszggy74>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v67tb43qbrzmqvb3xwl3oav6walexakrdxywlfb2dbjcg7mnne@vhkxkszggy74>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 11, 2024 at 10:39:08PM +0100, Carlos Maiolino wrote:
> Christoph Hellwig (1):
>       [13f3376dd82b] xfs: fix !quota build

It's probably better to just fold this into the original patch to
preserve bisectability.

