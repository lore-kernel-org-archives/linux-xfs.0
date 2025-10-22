Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D2B261B9E;
	Wed, 22 Oct 2025 04:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106974; cv=none; b=jJTlB5R/xLlNAzaYrPIDw5CyJwkJ7ItdU7Za0BzTph+iME+s07RgfYPBQvewu+MUaYHvKAFiGUVSHlU4Jeb2s6OxmlwATOlQNYcoss9vFwcoV1khoW2HDaAp/90g9iQZlr4TTlHmelCgSg0xz+jkmOM+JWK2iDcJBXbOiqhF4DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106974; c=relaxed/simple;
	bh=zbeZii5su2c1pK6YaJ6/NFjeV1Tib5FNNFHABHDVjFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFOlJkzFi1Xl59ikKPOlGKe6W4lx88JRljCmKhsqkpXWNxvfGxQ8NSgzxKcPceNaoOBisNRp5HgHhzAmPY0oYD33wNpu9V94Xa/yKdV75lj/mz0UBDeXZ/9X9LRJFgbgzB+1TDq3rNiq6mDJw+ptSXpO40TzlRrdjoyxxRbdG7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jN3DaKYJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jN3DaKYJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=65Rz+6M2cBPOg3gTPvYKetk6jfP8sVWdZw2qDbNRzao=; b=jN3DaKYJsLQmFQcCqVDNTWuvOx
	3sxWFnmATPpDceKtqHtshNKqRZBE6pe05LXaA/Z2HR1z/Q2/vnDvQPzbP+XVvqcVQUlPlW3SjbW8I
	C3myAeRjkgqVT1YcD4lwH6eb9Y4sfwj7UOwGx5rVq37jOSxjw3qo5wU+HWJ/av0LMLIo2v8qASE/h
	RQKwQR2fLuz6PeJRieXHZYl3iQCmAUZygzo39IXOgA5txqueUNY/xCWz6k4P1BdS4Pwk7I5VZHszh
	reofts+vMK3oqtzgkGiW+d/+SunFjVUqfDMZABd5r5OLc0SugEvyc7EWB0C4SHRG6R3MHG6avXNmE
	lGk2pa8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQNA-00000001QLI-250D;
	Wed, 22 Oct 2025 04:22:52 +0000
Date: Tue, 21 Oct 2025 21:22:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fsstress: don't abort when stat(".") returns EIO
Message-ID: <aPhcHFrqR2qpNROD@infradead.org>
References: <176107189031.4164152.8523735303635067534.stgit@frogsfrogsfrogs>
 <176107189054.4164152.5531016084628066127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107189054.4164152.5531016084628066127.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 21, 2025 at 11:42:20AM -0700, Darrick J. Wong wrote:
> We really should have a way to query if a filesystem is shut down that
> isn't conflated with (possibly transient) EIO errors.  But for now this
> is what we have to do. :(

Please send a patch to send a statx patch..

But for this patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>

