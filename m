Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6830E3AFD06;
	Thu, 30 Jul 2026 08:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398662; cv=none; b=RgP3xcQ2kWkvD5B36wZVEmNWrp5lYP+2GLLHxY+MxPPipyg/xveQBDkKIa083MARlvuWaMSwyUsAL6+T8gyQG/pv/u+qVBf26v7/OnlCcPOr1cxPnSEhhtwGgZPBoSTtLxN/ZlOqXyZBZq6VsK410iBlSLqnsHI91WcSAz7SsKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398662; c=relaxed/simple;
	bh=1LKCeNUq28ckiiYY18ChBDlS6uGtx4zniPdZj4iDYvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRvT/hDob5hSKyFP+2x/3hfz+9ZIXCufWX2wPCYTM6pMjAFgFDqU8Fs12RQm/29mizj/XPWIBEp4mXENfjJuI2nJgdvbxyf2jAzjLwOxgUxsopnIrtghr7ZqxBoqaLsnHW94OT0yr0ZDJimJ4lZUW4SGUT4uFhM6nLjyfOyhrs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sD8L/JIK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sD8L/JIK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1LKCeNUq28ckiiYY18ChBDlS6uGtx4zniPdZj4iDYvk=; b=sD8L/JIKZN+zhqqj/lVcOoArPV
	VV5ftcIob0mvEFn87d6ufWP/Wds/JM9hwac2n5uaMnP9ZFpXMkd+ejCaGt92tjsnHo0bXbggd5a5D
	sYKjacdSF+NQG45UczspXRzkwwnTmSBYWkEVhlCWx6mb0hQ/6g7p16iwiyaFOlWkl28o5XokbAg3s
	PY0Wr8j6v0Au9Bis6/oLVIBcLAW93bhbvxWchTyPaSD7WOrqsWqCl6FQ2+9Nm5qRAkH/SvMQp0q0a
	WbbClS7nHzHsy5RRL8XivnPqL4D/8YYeBAcQHOAmbxchQ+2jybSuci83GdOdyCysgqwXDZsj35cny
	YkaFq5Eg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLkX-00000009nCq-0r1I;
	Thu, 30 Jul 2026 08:04:17 +0000
Date: Thu, 30 Jul 2026 01:04:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: hch@infradead.org, cem@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhongling0719@126.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: use file target for post-log fsync fallback flush
Message-ID: <amsFgZKVxdbEPcuH@infradead.org>
References: <20260730021254.15467-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730021254.15467-1-zenghongling@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 10:12:54AM +0800, Hongling Zeng wrote:
> Fixes: 2291dab2c9d1 ("xfs: Always flush caches when integrity is required")
> Cc: stable@vger.kernel.org

Given that explanation I don't think it is a stable candidate at all,
And if so, it would be for: bdc03eb5f98f6f1ae4bd5e020d1582a23efb7799.

The change itself looks fine, though.
