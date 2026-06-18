Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8BF3603EE;
	Thu, 18 Jun 2026 09:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773458; cv=none; b=Tb7GVQtO2zjQO5bOR7orQTH6EecYRCGFEb+LK3HC7O4pm7Sz53SavCQYiS87LaSP+qU+p5imkNOBFmWLyGp0TQMAqpibR6riInkJ/E1KSbg+fw7b57fZvhw0HIGvIIxCqOLyfpn6sIk9/B6vaq4KlP6EeY6BWLpnFnKWhbsiH/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773458; c=relaxed/simple;
	bh=wF+t6BxD/LaY7W3eLHEftbTCZjhaeg75hXbcS91u2ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=db1St25npR5XL1xqLFE5EddHGMHf97Spd9rzpUWKvNX95euY/KabI6otnYn+lnJc1QuDbZ0EVAsUL3N1Ja2t/23HxY9zRLgwdhpdId2vxd+DbtMXQMgWJzojQLVADkL/ZpywfYJfSDB0sWwxAYYjhOOD3EkJUtvjpk98MIGKTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YmMWAlLa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YmMWAlLa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UrjmlDgw+suPHPDHkWXmSQ4qZJ8l/s/IHE9+ix893QA=; b=YmMWAlLa/Xw9JRE7jJbRxfm2KP
	/VLcsSxGA5RfBKMd6/H9UZmmwI6cxS3BGxXUs2RBjPhbE84M3Jdrd1bUpr6s3fmWKk9TxXD0PWwOU
	HRk7Zql+HCdY2aB/IcqahvanHCQUzKHgDiJSg8VzVMYmH7/6+sVOpKH6OJSNvHh7deDRPym+3lHfv
	AX1optjADK+AbrPDHehuSIKWU1nZywAm+EOA2PdRCL4x3RtFb8RQ3M6LQHKJh3yM1/EmNDy8mx3cK
	+TlKODinR4mfrFV6re/D/0nwTok8j7N3isHpBiU5WQ2D/MLjDERDLw+TrxV7udqjVGpJ3aUS1LTO4
	NSl9qbeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wa8fZ-00000000tdZ-1VKR;
	Thu, 18 Jun 2026 09:04:17 +0000
Date: Thu, 18 Jun 2026 02:04:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: always return status from iomap_write_iter
Message-ID: <ajO0kdqE5Ia-5Lhp@infradead.org>
References: <20260617114253.635751-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617114253.635751-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 17, 2026 at 07:42:53AM -0400, Brian Foster wrote:
> iomap_write_iter() returns either an error code or 0 if partial
> progress has been made. The error sanitization was required in the
> past because the return value was used by iomap_iter() to determine
> how much progress was made, and thus what to pass to ->iomap_end()
> and how much to advance the iter.
> 
> Now that iter handlers advance the iter incrementally and progress
> is separate from return status, this is no longer needed.
> iomap_iter() infers partial progress directly from the iter state
> and similarly, iomap_file_buffered_write() uses iter.pos to
> determine whether to return a short write or an error code.
> 
> This also eliminates a minor quirk in the write iteration where if
> an error interrupts a partial write, we'd have to loop back into
> iomap_write_iter() once more and run into the error a second time
> before iomap terminates the operation and returns the error. With
> the error code returned directly and separate from write progress,
> we can complete the operation and return from iomap_iter()
> immediately.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

