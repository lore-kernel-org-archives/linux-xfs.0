Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55612E7BCC;
	Tue, 10 Feb 2026 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740262; cv=none; b=Mjilb5ODm2BN5NZ6KiYebYrViFTSCUwREsaZViMpNupcOo619QvqdyFLxYj1ijjuFXoD1YVpr+SL32nY6SJOuMVrxsiIUNs47jPXBP86a2WTGXiTM/C10LyXEppPNyr9htlGhPjc6NFwXHZBlvOrQ2D8d9OSXv0zjzJ7KC55kTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740262; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTClc3Ml+lzgCFhK1x9ftBfZ5vzMOiWqDFJ24PLWWgqy6AP20E++BG03iHoQnpVcOD5lWKOJ6JfT6NvSWBMhBdajRGVZOPCF4vTq3/PhjkjKRvNbbZ8cWeJUs47yeTEFKbD8qhmgiDi7q1wVnNhzmWH0cPG4v2HKAtlSX6vAHxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dftxc6u5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dftxc6u5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Dftxc6u5sWv+O2yPZ331H3bV7w
	gCaMxPK2Tf91rvrXC4DXYtbEby5S3+KALsChBIEd56Ubcx3xCa4wCImOF3C8mTNs0H4Tu+5RoeTYV
	qP/8rl5YF6SZekW1hTiH+CnToUP2sgo0z6uYHcgFNOmMwXQPgyKe4qUIJ0dE2JSSRVwf6HOeG/jNK
	PwcHsNuzIZUy5wG4Ey4CGw3qCHl+8uXagQgennum0FlQuco4fcgrMDE1aHhNnY8s5FulmjA2RglIn
	ZHE6qMUekZcDr79tqxq9amTEJEq7bKb7Jb1WBKtiuUY+BXN1cgRNfMztghVclzdYP3z8PL4cO17C+
	fu9W6jjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpqQn-0000000HD5U-1z53;
	Tue, 10 Feb 2026 16:17:41 +0000
Date: Tue, 10 Feb 2026 08:17:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/5] xfs: look up cow fork extent earlier for buffered
 iomap_begin
Message-ID: <aYtaJX9WLTh_vxNo@infradead.org>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129155028.141110-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

