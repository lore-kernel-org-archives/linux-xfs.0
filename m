Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8C2AD15
	for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 04:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724561573; cv=none; b=DIX4YRYF/0hP6CeFWk/8h+BqvYS5nJxHMvYNxFbJ30rK6bl5i19mGmN5/yN+F97WHaJvi4+S5b5+GqjTfn4YgJpvBRTv656OfRUDwrAOQnoftp6g6WcfCoZlBwhvSum6bD1hNkul7V2/FrufR8P2uxW3HXbed3Jlctfuul224ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724561573; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qID3GkJQQweFMsyl2xqp0sL0DoW41wazCmz/Fg0fr9Z3OP1nNXC57EzJRVbcdxRr6ym0GmzQNqPOY6T0oD3e+v/4T2bf+lnbCEK31SDklL15XNPV3ooIX6AduftGZEKlY+AIZPl4ZCALen6NLXOnuQJtdrmUamotL6CyWHv86wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VySoIm1R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VySoIm1R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=VySoIm1RGS2Lq+NRybj5CvtXyX
	7NAv9uUGQjf+lIR0P1yn2OxKDXCWAQW764zpQ0GyM+PRwiSU4v6QTbO5UjJXOY2gBCwNjVDdR1GDx
	R4ghnA4sn1f65WNjsodOoUk3dQ86bpxbxs170FoMXMlvGItyKtZrr0CqLBwykiJGjDWtrEYuZK0p2
	iiZvA3lOhfQ2oCY2Sqaiz31FGXeX9ufMGSyP86G2hcZMmsdijWoYPU87BtqDbwv5IPKp0nOzaARZc
	cQcgojnWBSaXPFIWnL99upzDR217hvkX3BZJ0VJWWJ4YFjqjQMIAHidBYBO4XxQZFrN1qVJJyF7JE
	/pZ9/hpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1si5FC-00000003bhw-1JTl;
	Sun, 25 Aug 2024 04:52:50 +0000
Date: Sat, 24 Aug 2024 21:52:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH 1/5] xfs: remove redundant set null for ip->i_itemp
Message-ID: <Zsq4onMrcSJ5kzvW@infradead.org>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823110439.1585041-2-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

