Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF31079FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808704; cv=none; b=pyikuJ0xEVeM5WCiTC1/qnISsyTb1uvjGIeUNiSelqpwVXnp5d/sAQIwvvkpJ8jaQoqHSr8mGghKNELvJbxzTeoyOVFkXDwy3Nm0B6L+Ax9Gm/Knx7t94zsFBb4PrPuJEeGMiA3MYkYo80TEW15EwT9s+N9xuTK2TD6rKQaWvWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808704; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EeovI/+T03CWXsoclSKv7DBBZJftkT6tJPW1rJyk80nktaabl0977gtlptIWIpYRqJdX3uyWRmiK7hdyH4k9f4Beujs1VIULxJ60cppChCS4BdPkgIynwjjwbl6VL9w1ur53ykmo6l9V4921KGT9t6A4tKFLa3ugF5PLM+RvsPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IpfcoePF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IpfcoePF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=IpfcoePFRLLsEp7Cb8H7WSohzK
	3bHdt99D8qK4j4zTRJ6mt8tqEUvliT1aURskT6rm/cV4Ecc/XGBxRD6W4xP2ienpl53D7PDe5AY08
	T0DjOxbwKdQw9ZHNXVWlN1hlforM5QOiSDs8mHa+O30uXRqXhL4ZjLZDrEC7WU4TkYx6+T9gYz3p2
	fCBIv/E6O7XC5uDYOzKWX5Vgn3ajTf0vYymRY0FC3yKLQ/SKIjinYP95sotJq8tjJKseRtyJZJW03
	cyUdZ8eRUzmVpAya9v8f2zFngm0T2PH3878amYtE8gIJhBSQukv/3oQTPfT4xjgjm56MolS4h01eG
	UFTKQdzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsqU-0000000AHtH-1vff;
	Tue, 10 Dec 2024 05:31:42 +0000
Date: Mon, 9 Dec 2024 21:31:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/50] libxfs: use correct rtx count to block count
 conversion
Message-ID: <Z1fSPpn7P873DfWZ@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752007.126362.11650470586267839011.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752007.126362.11650470586267839011.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

