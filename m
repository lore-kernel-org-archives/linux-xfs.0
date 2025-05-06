Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8C8283C91
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 04:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505866; cv=none; b=vEVJyxRYpKenDKxOHFNXv1NYPys7S2Yz7+e9HpOzHMKsZ+0h4ldu6KFoLK9tMo9JgyYaEF0iGf7N2XBQROCWwuAJ0fidd1k975t3zYx1W0Anhvt0jAxuYlJeDs4wVNxg9q6XHpTPBhKpBGd7co9GP0AfWNmiJWhluRombSVYIdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505866; c=relaxed/simple;
	bh=rgIKbKjBX7sP8UM6PwARXGKm5MpqmsVvekJbGx8/13k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lscKqrtmCexpxhVm3JqHiLs0xVdAv07gJYSVpxk5FAEMhMQpqFZdGZmnu7nxfvdDxMyoZ8d8uQPucPeyuUhQCFc7YJlqSvfzI09nV56QKYGh9i7+4zN0aMc9SNFzsnRSdwtlJoVW7tDfK9Bb6vGorTVEnWgud39LlFud+7XnV84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k9M27hGB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k9M27hGB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rgIKbKjBX7sP8UM6PwARXGKm5MpqmsVvekJbGx8/13k=; b=k9M27hGBBR05eEOLoEP904jN46
	pymJDD4IwS8vD8VUmCJoCny8b+4shJSle4g7EVfwXiQFNtJ5853fmoPO8nc3idrKOuEOu8UPM6c4w
	wrawJUsZzR9exibuIIL5iznKXOIlNb62iD3t//E6DbH3odyIah9gWgPez7c+nqUaNeDPe0CWcB3/h
	1rbZjuQh7baaLPXvB6Szuas1wNTp0lN/aQea4BXsaFKad08Hk2gHSrq1jSWyVc7CS2X9FrmOdYY+E
	7NHoyITITOzfzG/lqOnE+v0nqqWiy213UvxI/KceLZ0OzBKaBiwG9fBA3ZTE+SGRJvqWrpgI7SxDe
	kzzgAtug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uC9xM-0000000AEFv-15nF;
	Tue, 06 May 2025 04:31:00 +0000
Date: Mon, 5 May 2025 21:31:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: free up mp->m_free[0].count in error case
Message-ID: <aBmQhAXcc0hSxgZ1@infradead.org>
References: <20250505233549.93974-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505233549.93974-1-wen.gang.wang@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 05, 2025 at 04:35:49PM -0700, Wengang Wang wrote:
> In xfs_init_percpu_counters(), memory for mp->m_free[0].count wasn't freed
> in error case. Free it up in this patch.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

