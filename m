Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D9256C8B
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 05:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773813368; cv=none; b=FvF+mFueqvPBtI4ribxD3slclj7xV+TQyBn3WNkZZdDzAw9ABHgc2XY4Ywozbj3jvX6zAftnP1Qwpzvmabbpw3T3aDAgswT5BoG7L+mCX2kejXAVgi6McW/REUnOwMBodse9XSF8Cv+wl/8QyFDqqcijQriV7d0irkdX7NBRwKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773813368; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2OSgwPoOUePMQkZd9EjnHxBJ4vb/p94SoJntQVyJICeI0OEGwXtvrXWGwC5yNqiLzyoE4ao5256ehVSKCz8N+N1qxghCeWdqIisV4MM7d6YS0hok2kwHNQLeOGHrDNvMijSPOSq/DOX+9hCdNUuZjnF6VqD7TwZTE9s6Io9+qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PCnW1s9z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PCnW1s9z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PCnW1s9zdHwKptCT4/6hooN3jA
	xw0Ah105Qxe6IoUsqYh5rfOYFj4JqKLF0I/GZtOh82/bQOMjIQ0/hVRsndVL+Mw63RpRVMHP3x2Fz
	HpZeBbYXYRMeX+l6sBKneYkUAg3OER7dnGe5Y/RJHnA7X7HMEPCC5YKD0Kyx0mqE3pkfVZuBz7VZz
	IQLBtHceOrsNvrS5bbsV4gZ891jpTRIMls0BJzqIHqzE66kiE4DUcujzXMHCmJWV+nGVU2McevqUQ
	ipYl3V6yd/DeNN1Ats+NZ27Hl27RlSdsoEqhMQDUVYGydTDP+hf9/IUc1uEYg16jwtonPYw7kwwnC
	2+3suzEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2jt0-00000007oqC-1lcV;
	Wed, 18 Mar 2026 05:56:06 +0000
Date: Tue, 17 Mar 2026 22:56:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>, hch@infradead.org,
	ravising@redhat.com, leo.lilong@huawei.com
Subject: Re: [PATCH v2] xfs_repair: don't fail on INCOMPLETE attrs in leaf
 blocks
Message-ID: <abo-dj0MJ93JbSnU@infradead.org>
References: <20260316225033.GP6069@frogsfrogsfrogs>
 <20260317205018.GJ1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317205018.GJ1770774@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

