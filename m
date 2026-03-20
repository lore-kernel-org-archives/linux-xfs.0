Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF27356A3C
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990743; cv=none; b=r/qljK/vHCvi1FviQALE9BtlWnlfbV2qk3O7PTAPkno+qCkPn+R4J8FJV1QouQghC+khWEzDr/XrwuJNHQB4QBsc60sp3d9VUh1HDjs8NGrifthiBs8se0kFLOBLT0X5uXG9ygYUg9D78tpXAcx2yzZcghAUQx2mTqyQ8iyn+T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990743; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sEmFqpGrf1Q9WZaK0xZjvzglUW+g4kthRl5FvxASR3KWleWfgAe1aFgityVEhnjo6JMcefEdkAc8Y6J7xKIiUN26ywxQg+sxd/CqCfZT+qKtH2DDJzY3WDBosph0Hf71NofpIO8CGm1Z7FX3f25gUfuppFPbgaIoVS+0IATTtek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CsVS9aLA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CsVS9aLA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CsVS9aLA9JAP69uu/g0vkj2wkL
	Hh+YeKHYfVaQoeoSet4N1PMNKbK/eie5gnc/FvoCWw5b25fc7CYfBE3qlQ9ckVZX0mXDpkJPsBKZe
	m7Mr4Uz3FBDoLkNwkvDZZG91HCdvVSkQ82atYqFwAl5mClM4XmhidJ/K8hJskRbX9wd/0U1il8fs5
	mexVZdprv8FIZ4LwxYzghXUFuFDHXEjri+KEX1QegAseCTn64P9o2VwgvuB75vrpGkzo0gQnAqmPr
	H59uq+2MZ6fMGxNAt8ExtIFGTnuFThIYi57XvCwbzmwGQVk+IIRNq+mn1J0yHxcoYTMM2Qoc+8/3Z
	dIVba+sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U1s-0000000CDOt-2OdS;
	Fri, 20 Mar 2026 07:12:20 +0000
Date: Fri, 20 Mar 2026 00:12:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/22] libfrog: allow bitmap_free to handle a null bitmap
 pointer
Message-ID: <abzzVDaBNFhCzXu-@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389506958.3681140.9104825233192607870.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389506958.3681140.9104825233192607870.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

