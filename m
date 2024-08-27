Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7082719F460
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 12:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724760910; cv=none; b=i2mel8ULCQs6HtlqvfCvyGpnybVH4eb2+OoheWyZ+xIaz0qA1nAoogUNdI0v8Zd2Mr2/HeVjPBAQvgFl4BxtYDxoy+6aoTHof5XTRUo5hXIKYQukyHWXt+5vvrlCw44FfScnGUj8pP2VtB4DPbtbh+5QK7otQJ4KpqWvrASFyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724760910; c=relaxed/simple;
	bh=eO+qRKvFvpGbItbiKVRgcq6+GvgjUw8WrLp8BuXDgfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=re6m+/vAEN8BYeMijPKylvxe/S7UOhtOgKdx53OTW+LARHKKP8OKKUgHk/4bDNCHi4396cp7MC3BBIkkZj0EduEpdpAGHmANuiAPZFEk9/s1uRCuRDqMugdZ6I9zypdTlbA7BT2IOY2FFGiOV8a1MgMMpU5d2++NIpXlKr1SsJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GrKWEr0C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GrKWEr0C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kFo9ba30qHb5jQfIhRODZi/+XLGLHOpZ9pUSvYIMJ7E=; b=GrKWEr0CRb7SLsGAGf8Pwbc4Wf
	3F4guu/sJP6uMIla7fXaOPxvr95HpDrOsCZk9vum6LvKeWnuacBvwA9/y/ImJJRa4nMctN/ZSVhcC
	ssuuqQPUxtAJLoAhlOmUOJNeLYkkeuyf3xiNACK/wepq3EMZDp0DoCIcpkiKTfTXa9J43DgBaxmw+
	Noaonn8NHI8rxWpx7VHgrtNzZvrKZrx3cLwbFPG1dYBppQ4fHPwnJFgeziHk4SmmWZECF3bnABK+R
	EL95rgK7ad4tGXFHXDtnUXaIq2ngom/EOL26AtmK02kSMzzU8ufgu1ZRQFw3rus2Nd3TiBatvtcg8
	6AJ6E7qA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1siv6K-0000000BAh7-2plr;
	Tue, 27 Aug 2024 12:15:08 +0000
Date: Tue, 27 Aug 2024 05:15:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/3] libfrog: remove libattr dependency
Message-ID: <Zs3DTPfDfQZxD0r1@infradead.org>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827115032.406321-3-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> + * We are redifining here so we don't need to keep libattr as a dependency anymore

> +#define ATTR_ENTRY(buffer, index)		\

Maybe add a XFS_ prefix to distinguish this from the attrlist one
and match the other xfs_ prefixes?

> +	((struct xfs_attrlist_ent *)		\
> +	 &((char *)buffer)[ ((struct xfs_attrlist *)(buffer))->al_offset[index] ])

And maybe this really should be an inline function as well.

> +	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;

Overly long line

Otherwise this looks good.
