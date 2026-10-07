Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08983B42FA;
	Wed,  7 Oct 2026 13:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378360; cv=none; b=JF4oOrQAAIoijH79Ls+BK30ucF0P6TjQqPLez+n0LCOYqqXIzCqgjAZK2Hj+r5ejLqicYtOGox4JHIKfZ5aoFsLaKBUMTOfPKjEn8+XqFV+NI8XOFlULSREjSOoVjqUAR3w+IwK1TBK20JjFISs16ezxWXTqAjYJzpYRUmxYkG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378360; c=relaxed/simple;
	bh=2LMpP3564VJc1fSgBRgRRD8fAfJdwJWfKFkgKkzhO0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeTBmkn95pGGVSxYUnEJRTZaAfQCh2I3qbKoEfqIUPMsCSogEmZEdgj1XL7PqtRyhhWGPzkDtRlsFExrcbVjJ7rnyNGpoED0CANFr5xFsFxD9GyeEDwNmXTjI4Di9eNbVTXiQBRYA1lCclpY4vuL0Pj5Flv4nw6Z6A7e71SvV1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m061iEi3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m061iEi3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F8eCFXcOtSIxZ6/ZasSDQh5NxEUFT7WNFft6L+ruLHA=; b=m061iEi3Vok8AefGifvp+QGqIh
	rcHgAX0aVAw0ekNLfWEkt2klvSKDlhh7mtbwQNRw7jKOi93ZxGRmrJLUORWyynZDeu3ALgYw/dVbn
	iTboOmthJtcylykJia5WyDbn7H5FPvxR17ztmJYWSczom31s5A2L2mGUgyod7pI4xWmPclySKuRk+
	9FMgG6sBOzXJ49LJgdhtl5wIO/jBoF18h3OtOwargTNzeyHXwfrDrPGdmsD7Hsdo4ihykWIfbaFYD
	RvMk8NmGDKPLQA/a+slY6THsYBrWrVl6stmjsVqwv8bK1U1xreLEoYuX0Jxe27lpjyF15KyTBxo3s
	XjHKshWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERLD-00000002VHV-0HtJ;
	Wed, 07 Oct 2026 13:05:51 +0000
Date: Wed, 7 Oct 2026 06:05:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: don't allow sm_agno for non-group metadir
 path checking
Message-ID: <asZDr5qYU9Oaax7G@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965180.614350.15051352556483286821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965180.614350.15051352556483286821.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:57:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the metadata directory tree path checker accepts
> non-zero values in the sm_agno field for non-group metadata.  Make that
> case return -EINVAL.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

