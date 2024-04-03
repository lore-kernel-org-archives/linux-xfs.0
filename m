Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042545035
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712118947; cv=none; b=UKeIc/uO0vnNUNymawTchcfiHxUT9m4WLjipKVTIk4oe11SsqZpbOa9VZeqxbwLXAkJ8FEowf21xShZYYLFLAEBVEmVdUWq6SikbRGWIqiPJf3aNNY1D14kplJhQxg1TEdktKbxVNurQxZRcRTvhwAsd7yZ3bxgXv97Z4VuMm4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712118947; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4QCjcnl9ycuwE9yUdynXq+nzLcVF+DFh74ECsrRRYVBKSa1+vK5SQII7Uw0S0prf/fqiE/l1ME6Bu4ijB9LkSH568VC9ICGuTTeUHmPHiVKgRrqcHmdCRAVJWXSdsLOXQ0RGfBnMN4NMvEZuthgMvNSWSCozyP5+dkQKSsb1qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XKdeJmZO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XKdeJmZO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XKdeJmZOsgYJtU2eyuNsrUxirQ
	9KnSbeziACCxNNc0kXrq7cropxfxn02jg5xn2H3qZGfzO8vJd07aZhyKpmLvdnAIn1tJOTNpA6Mh8
	n5gBGW7m0olL8Q/ZlKWzP3CWd0hWpkOpoUn5C0AsPViyYHpA+r6k6xa/gf2v3/NDzM+FhwwCKCUuN
	LkLGuJp/cgHvcEmH8NHETMkjlWFNdWXSntcH3SDBQgFeqxcxKnejfMLDJLkhX571ABYhUQQKaucLE
	bkmLteir6THbk8rXfWjmyG4WPyaaySBq1kvmWrzte7tXFf+iVU4TRFHB2sWsBVx1E1ULlAx4eTuNN
	4WhugaYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsLg-0000000DyAG-1Bso;
	Wed, 03 Apr 2024 04:35:44 +0000
Date: Tue, 2 Apr 2024 21:35:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: remove unused is_rt_data_fork() function
Message-ID: <ZgzcoL1zjOGh-zDA@infradead.org>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
