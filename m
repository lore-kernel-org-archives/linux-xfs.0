Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A0379FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806385; cv=none; b=gjUAk11gW8hwi0dZlazgrzYFckztx5a4XMm8DIl4OMcsVemwLSCL7u3kmxtU7fLcb2jQHGi6rUou4oc6GTNcZeLrC3qSQTctd/9uSeqPLi29w2vpVUYP8KssFWlnm5+3KcaphJY9Ty7f702NieeMQHM89bquRb72aKusu2dA2no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806385; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIFAsAqPcCgxTMfXpi8JY5mki7GoAQkJR2jgckb6ryF3Lu/3YAubleBGc1ZTpkY/5O+V18bvoWXeO1N/FPLEVORG8AjXPu8C+2IFVH2Mrb+Im8n7bqHL7iYYt+ULc3K00GSEcEUXKpkMAuBJRusvyLBhd+ppMS6JU8XCd61q0qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U8U13cvL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U8U13cvL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=U8U13cvL4fH/fl9051qVIx9YIh
	WPzZys/s1kW306VvnsBQAO6IQpy61S7Hlm+Foi+s6E4bP9FCbR2zDU7kiuQ9soE3jIdvLqc8NH5e2
	Ub1SJENm8VfKCgEdOoehChfhDtBRZGPLgxx0gb1vOf7fMCcX/ZnHlXWmjndIYBosYZ/JU6etYAWsn
	uwphU8icLnUel/0o1ww0a/DJ4dHcogyldnUiGdTip3FfEkly58u8CycfD7QdqG57fHlHXXcJmHwiY
	ImYJGYGEwYmiOvg/XsO45NjXkRUb+2xfLYwo4hqNTOwIctdmesYO8eMHQPmBjvVTQhKyBa3XzFrn1
	2550QSAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsF5-0000000AE75-2ara;
	Tue, 10 Dec 2024 04:53:03 +0000
Date: Mon, 9 Dec 2024 20:53:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/41] man2: document metadata directory flag in fsgeom
 ioctl
Message-ID: <Z1fJL3jeIzZezAQN@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748300.122992.7800701995690791823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748300.122992.7800701995690791823.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

