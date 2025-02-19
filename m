Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0621B81DC;
	Wed, 19 Feb 2025 05:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944269; cv=none; b=KbSHn+3KV0z9fFCuilAzyYAlxPMlQ7BnY4N2eihJE8iNZ5evja3ODDS4j0KIIqIgPFBA5Ft5d35tfcF74dCXHnqdNqNTOxYBe/MiBff/MK9NzKyA/rOkF8IS7vKnd7dvSe/6Hbt6JLShR3/6WsHw/kL3kglPKJUMh4iufJ3j7Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944269; c=relaxed/simple;
	bh=AL/7oMbK88WVyq54aOcxQLCU1SQpmnppab7GiB2dzH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aocImoKY7OgiurfbKAcCSGVtfTU6BasyQ+Cre1Ko3G27XZoN3WH+Sk56DJbT/fxU/NaPQIhdm2YWUEcDhgE2m+KVw9gBYi5YYkARUNMfxt8LN3b7QqJbyElrwxRZ5TPnYKDb2lsLVGv82L7KxOORGgFzbIbTE0IlOILwpnicr+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yW+loH5n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yW+loH5n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AVYcYzLmlC904RztyQdQaAfxLgw1clUOsrCz9wn3haw=; b=yW+loH5nbUIZ+f5UEgLX9Uy5H7
	CxnduKNmjdMKT8Dy8u/zICUV6GDu1QFUN/KgIr6bAHVvuokxC4/LBxypVj3ma9TsWWYqbmq96yA3V
	x18f8BUMo9B6WAudAgy/PB88M5C2RjHok7TlqCfHKUG6dK8fZ+pEAiMioJjTwxC7SCtcZOWXUwQmh
	L8TPZ+50aXFz6Fqx7Ua914hWNFlZZM3FmbbtvP6IvX/bglpEU5gn5o0or+JJSjIua4S9x9keOh5fn
	n5bxN8ArOuteIXmeYi+Pv8eWECLGmBN1PUbTOla6IRN8gQzbJ4HhR+M9ARYnaixU2vlqZ1Fi/KJJf
	sGPh8/2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkczC-0000000AxIs-0stI;
	Wed, 19 Feb 2025 05:51:06 +0000
Date: Tue, 18 Feb 2025 21:51:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] dio_writeback_race: align the directio buffer to
 base page size
Message-ID: <Z7VxSgR8mOUMcQGd@infradead.org>
References: <173992586604.4077946.15594107181131531344.stgit@frogsfrogsfrogs>
 <173992586646.4077946.4152131666050168978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992586646.4077946.4152131666050168978.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:49:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's no need to align the memory buffer for the direcio write to the
> file allocation unit size; base page size will do.  This fixes the
> following error when generic/761 is run against an XFS rt filesystem
> with a 28k rtextsize:

Note that in theory even just the memory alignment reported by
statx / XFS_IOC_DIOINFO is enough, but I don't see how reducing the
alignment futher would benefit us much here.

Reviewed-by: Christoph Hellwig <hch@lst.de>

