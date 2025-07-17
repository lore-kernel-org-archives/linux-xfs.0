Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C0618C31;
	Thu, 17 Jul 2025 04:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752726660; cv=none; b=adQxB7xac9tt+5Mu4XDVYVlACH1UOEI/JgbI7TirqdpGzYkorW5BvFtt10A43jcNAvu0oI5yxy8XZUoQR8MWAx16FuUTmGfHnvP/tMQ8Jv/8cJ1NadOCGrcFH/0BUV6K67ACU1lFDnpx71fXkrvLCRCBUZBifyf1gIweIuMbRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752726660; c=relaxed/simple;
	bh=6ojHC/XajVgKg16CbNjIgYPS7vTqKKU4wR57hppfBT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNPw89OqKG+UUiVhAxXItbWZY+97JJWUFlR568oWnndOHov/I8wSc8Sm3aWQPWT6vrA2aMvRDG7qU0TRmPBZn8bVi8C6niDC8+C5KiCOmqdsvqSpThtJ2vpz1cmZkcEmyMDxmE6O2D3SgBMuQaO8dzf+ThsyJxfsktZZT8e2otA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pb69hzCG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pb69hzCG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LsbMKamyrM7DveMTwMuaPtSmJLXfOCSP27FnMYkSJs8=; b=Pb69hzCGk7QOgujaCgE8noAFPR
	yDQ1s6fmRhj1gNaJ2V9k3qFwXM9yIoeoRY7leIY4XOUIl0kqOSNTgL+hNq46iKRZZP9tZSskjLaWH
	wKofBPLOnyufpmfK9ylwRKVnksHqcdiV4ufxUIQ1SMzLaD5ftuu/G4fiIB+8jHSAvRv8xNXNM2NiW
	qW93baprmHzw0Ush8LjYs5ea0X4ZOLv4R0cb6YwoavcSgJel+ttXZSkjgGEz9pNaT5JEQy7Y9RlcC
	vTfgr/WwOQd6IcCaSWEN9eiy9FsjMY/UgUn/vZ1T7HDzBlzVFqisNgMmmjANtNnuL7dZ3hNv4P+iK
	6RLpyIhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ucGGn-00000009Acc-01bU;
	Thu, 17 Jul 2025 04:30:57 +0000
Date: Wed, 16 Jul 2025 21:30:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: Filipe Maia <filipe.c.maia@gmail.com>, linux-raid@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: Sector size changes creating filesystem problems
Message-ID: <aHh8gJ26ES2MQ77A@infradead.org>
References: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
 <20250716221003.0cda19e3@nvm>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716221003.0cda19e3@nvm>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 16, 2025 at 10:10:03PM +0500, Roman Mamedov wrote:
> If you dd the XFS image from an old 512b disk onto a newly bought large
> 4K-sector HDD, would it also stop mounting on the new disk in the same way?
> 
> Perhaps something to be improved on the XFS side?

Nothing to be improved, as the sector size obviously matters.  It is
part of the hardware geometry that is fixed, as XFS can read and write
down to the sector size boundary.  Both for internal metadata, and
through direct I/O also for applications.  The latter is true for other
file systems to, so even when you can change the sector size for some
file systems, you will be subtly breaking applications instead.
