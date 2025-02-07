Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA39154439
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903211; cv=none; b=YLla8xhH+NGONTsfKu6mvx+NFkjoa/kIzr0OJmtbkpkNhERViujbeKFobcNXs+mw8NErdQAIlLVDGq30oK9hl68YwVrKMjyC8D+b/RnHAFXFrt/uLscUMvzeNLh4ZPByz69a/ehxiH8bOQANpWrRGL2havlZ7PBk6+ucF+afHdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903211; c=relaxed/simple;
	bh=mKrBi2MSxtTA0AKt9/Z/HKbPhWFulVA8BnB+SX/HUfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0Bw14bRodkSFpSBmzcDKTu0oyHj/GAGC/Xd4gZxUdnXnrZYIpzE3Bvxs89Omv/XwfLjgMilFC5TI0bcbObpvYtvmzRz3KqXbYMhNEF68tc7zdIsiErLuRHCd7MRTcQ0TQe9xWk9BpoqZRV+Lb6euFCpUhJ9uvRI0VNvlHwdwOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4gcUQHTI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4gcUQHTI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Czv5l8uACR5+feY0cPsvrXhIBmdGpoqVC1wylcU6q3k=; b=4gcUQHTIb7pvieO1ZIhTtfYTUq
	LR8UKh2s4KQeioYV/UwC8fvF1gGBB7uZJW9B10RMUzUjc0f/paiGxj3g6fMsq8yAcfw4bokKI2exT
	a7kYvL2vdEPcYHKlWBc8PSyIe9UnxvmkGAQEXQgpyLhhGLtMgneHwbciA6xpaXcwyYDAWf+VxE6bX
	MRYd8hx+NYQm46OjJb5i/fTJLrRK/xVuUXe4pXzjKviTBAvor8U8lRX4Ll+VDW61HV22TNhMqgx+Z
	Iu/LIqkABcKia7YEwECIm2vhyehaYB8qOixP9EmVO+KX6iRe/dd3X9AJbzkeWgyNrKopB+Sc8O9Xr
	XSp3/GQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgG9x-00000008J9J-1bah;
	Fri, 07 Feb 2025 04:40:09 +0000
Date: Thu, 6 Feb 2025 20:40:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] xfs_scrub: actually iterate all the bulkstat
 records
Message-ID: <Z6WOqQBIrEAalr3-@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086198.2738568.10758609523199339681.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086198.2738568.10758609523199339681.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:33:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In scan_ag_bulkstat, we have a for loop that iterates all the
> xfs_bulkstat records in breq->bulkstat.  The loop condition test should
> test against the array length, not the number of bits set in an
> unrelated data structure.  If ocount > xi_alloccount then we miss some
> inodes; if ocount < xi_alloccount then we've walked off the end of the
> array.

Look good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

