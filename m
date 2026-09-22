Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9AE2F7EE6;
	Tue, 22 Sep 2026 05:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054135; cv=none; b=J0Y3rdjt/uHpzwRfXL0H7fC56qPEbjjqgCjN77OB/J1PPL3djvKHenGbEJq3q7ApEFJs5Xh7QjvA+txNl0e58CQwLd5RfqkonEg4NEaHnEJ08idW8Vur1XmkCN+LYT/KmtRhrJ7UzKQkzXQyxkTn6otJmtu6c/ngATY86Xbsl2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054135; c=relaxed/simple;
	bh=1moB5J1aXjs3pzPPXwDJA8HcHOtjhSgprylhtS+Mayc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFJvc77NrL3ugD5nz1PvPkeb4zFMF7eqbSovWru+wyzSqfc7qccOl53bhAWGjev+IT+4JX+T3TinoHFOpzntgUxDCxisw9qFxvC6OryFYe8SgnhEsTpzfCL6pi2RGIM73kL1fzuDQGjqF+WKT27Vt5Q0xaGBgOhs98v4e2TMMbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nTpPjHOo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nTpPjHOo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nN4CLSII4DdXAXSh83aMyv9jCPgG19LWy3EYKrrcIJI=; b=nTpPjHOo5avirpRR2m45DA1Lav
	I6ik0iseApOJB3oGAAr38vcOIA153yuuAPrBxccXLbgT0XmtjKGz29unX8GErnPx8KsPo57fcWPnV
	Ejc/KJyLUElZzvOSus+krjJZkTf+7ZiAqP7Rpd9qC62yJkBFI30qRLnOmfFtYq8A9PBXj5Pth+MLr
	pPKnYmGFi83WUMEdU4EIGU6p59yj9PeeAnuYPx0cbUfKD3jFwZoPoEEj16UcYwJ5TJl+1v9bW+WMb
	UTsBw5WJbdsjL0kr45EvMhQpDblgzQosxPkLWkpj8GgyRi4ISWibfLo+ZQT7Mijr+f8ankXwIaqUi
	y/YavdEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8sqq-00000004EU7-1gb8;
	Tue, 22 Sep 2026 05:15:32 +0000
Date: Mon, 21 Sep 2026 22:15:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: fix buffer overruns in xfs_ioc_attr_list
Message-ID: <arIO9JiKf_MXBb46@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120615.181988.8935770811414289563.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120615.181988.8935770811414289563.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:15:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we converted the al_offset array in struct xfs_attrlist into a VLA,
> the size of the object shrank by 4 bytes.  Unfortunately, the buffer
> size validation in the attrlist ioctl wasn't updated to notice this, so
> the al_offset[0] assignment blindly writes off the end of the buffer.
> LOLLM noticed the omitted check and complained.  Probably should've left
> working code alone but for everyone wanting these ***n static checkers.

It's not really static checkers, but fundamental semantics.  Arrays of
size 1 used for VLAs always were a bad idea and should have never been
used.

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

