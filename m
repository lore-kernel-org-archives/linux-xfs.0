Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0026847E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2024 05:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BSjQRQR3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ziIopJnAgK8JVebilslF87bayWZjbuNb/iV3Hsp+6W4=; b=BSjQRQR3E8W+dPsuYpbXxMc5nP
	RrW0A2r34S3q7LcLyb7TcCC7Up6Rjl8I7FLJCvCHw7+rxHqEGGzykB59pwBgFURCaJItI5nHR236H
	t9WPFQ/6/lb/1L59RVrARc1Ul8n4gqcGAFhXIC9xw3qJsb461wgjXvomkJPbDUlqQDF18WaKOyXsy
	3oWd+uQHSCLRMWXN8HcWXxizqNvtS07lq5bGHuX/jPi8jSpmKzgI9bN9thvr54RarAhEQzN6pKMLh
	+Sb6qsbfX7lj9Jd6QwL5/b7PQfVWqe7D3PfhKJUiNUS4X4L/fH7PUlF8zj4Z97Gbf+HBlIolsKm42
	EmD533lQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rPbtB-00B1BK-3C;
	Tue, 16 Jan 2024 05:21:29 +0000
Date: Mon, 15 Jan 2024 21:21:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: read only mounts with fsopen mount API are busted
Message-ID: <ZaYSWRrFuhtJYbof@infradead.org>
References: <20240116043307.893574-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240116043307.893574-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  
> +/*
> + * WARNING: do not initialise any parameters in this function that depend on
> + * mount option parsing having already been performed as this can be called from
> + * fsopen() before any parameters have been set.
> + */
>  static int xfs_init_fs_context(

... while you're at it, can you switch this to the normal XFS format:

static int
xfs_init_fs_context(

