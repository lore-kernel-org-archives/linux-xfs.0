Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F163F660F;
	Mon, 10 Aug 2026 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376375; cv=none; b=rjXgVLDDlmY2zDYlc492B02idakloFbwhf5YghQyLL2dKyjy7JdKi620bn/4aqm3R18GZ1SukQQxSELWq+26x7qFeGPQtQTwMRh1WkLr/ItIE2wbyrb4mw8Z5FRPFVrvPFuMltpH9H5RavdRF2D8GyzxXkkqye6ffWeU60jAkMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376375; c=relaxed/simple;
	bh=eAO4U9Ep2ogaCM0saRz6yMca+fI9iLjBnIJVsNRGzWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GS4GVtrcqZW8XDa7ocFsOCgZ42UOPdfSksw+vp91SIF24NoEPjQkLgprR+/C5Tr+Gap5rOiQ5BKcs/NpoGhy6RzgzuXis1lfDGvIKsq7J1N92IQEQH8sP3RxAwrwsRBjfyfkbx8eU/T2Xay6JJ32RaV5VDUrLMOlqVP2VNker5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cbSd9aKK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cbSd9aKK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eAO4U9Ep2ogaCM0saRz6yMca+fI9iLjBnIJVsNRGzWM=; b=cbSd9aKK93ytbjuumPCwnGSDo9
	81AjTTFCRdAkLvIoQTCCUEHvTPM7sL0Ed+2rctnJ6dH8XIyFR+wi/H0pEcfXGkMR2U0UeqIbuAidW
	BS6udsVwe5FVKfdmDt5CIoVzY2ybBkEjCIAkqiEXlcVoo2aQZ7YxkKbmduXnvLTpT0tOzk+4rUv89
	mbPqH0eGFUu7IeHKXt8z33MPFZeEj+uVFvA+AcTr4thKA71eD7lmlua7qd6Pdn7SAZHwDm74idSZ0
	0l9SuxyF/80/j5MVLrc+WCO1ENwmj08gGE7HLFcU1I26wxiphUMaVxs/sY0bZ9N4MB2ype/Z0xvA+
	K9egfUvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS67-0000000CHz3-1Yb3;
	Mon, 10 Aug 2026 15:39:31 +0000
Date: Mon, 10 Aug 2026 08:39:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove kmem_to_page()
Message-ID: <annwsxXkNEhZx3IL@infradead.org>
References: <20260807-kmem_to_page-removal-v1-1-7365a789acab@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-kmem_to_page-removal-v1-1-7365a789acab@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 07, 2026 at 06:58:51AM -0400, Tal Zussman wrote:
> kmem_to_page() has been unused since commit 5ced480d4886 ("xfs: simplify
> building the bio in xlog_write_iclog"), so remove it. This also removes
> the last instance of 'struct page' in fs/xfs/.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

