Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38322D9797;
	Thu, 18 Jun 2026 13:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781789778; cv=none; b=YRE0MZEJdZRc7wqCjHwVFXDQ575z+rJZazJDLRHmcjKl4pn2lxQ17FEMGlqN9rsRmYJSZIrslOfVh9ezi1eVAjeNZJMFhOQzK6CAFuEobNdB/8x0tiYAhWAOyn8khR/SgAAGjlpMF7I47SusLusamO29AZ1D5xtL2uzrQcIutsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781789778; c=relaxed/simple;
	bh=sonGjLaZC0lDrmBmtUKK0doqbc7i2VKlukN2A67cIFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJgN4G8Kz8JWc+iw7YRmjx7OCSU3WWnfteyIw8sJ5RJWkoqvqUgVnjWAUOdS2JHztds1fVWlfHDsCWneQezDd1oY307Efq1oYPM16ggpoYFm+6jbM+WScVScRZC7FAykyLuprWzXJzCH/Ktvx8wjS/h5GUI0MwXsztxExVRS/aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DH9xhWtb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DH9xhWtb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=NXWxqJMqoPNVH4ARTPzVTzSz7t0UDeI67i4rv8moi8I=; b=DH9xhWtbkAchcO8mqC2CsW0DZ4
	8T/txr8dvGfp//cUib7Gb8k1upCrXtZa55r6/HvYYf2hZ8JxhYfxSsD6pr8efx2+6D8ZIOg4bfKYO
	odX+5yl6vdDidK0Hm3iVbRldkYICdAyfDsU+EXBE+44P91tVFOy0EoyeuJRqb8D1SVxfycv6vKxdj
	el0GsVLqQMhtSLHwnStsvxEYuWwFsji4dcK+6J9DNSL/SFw3m9+YLHx6JTq/aC/iF4Jh9DZm92Aj/
	vj4BubFVtVW/2qpa4pEEd/t1vTchCWLJ4emVMTju4DvQeC0Pi0NMoMMytioN3/PLT8GagWKWJhWJk
	JmzL0rjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waCui-00000001N3f-3OjP;
	Thu, 18 Jun 2026 13:36:12 +0000
Date: Thu, 18 Jun 2026 06:36:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: hch@infradead.org, brauner@kernel.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: guard io_size EOF trim against concurrent
 truncate underflow
Message-ID: <ajP0TDAkqaO5Znyv@infradead.org>
References: <ajO1fOJZlmICeSAv@infradead.org>
 <B234832D26F10C59+20260618110320.545750-1-zhangdandan@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B234832D26F10C59+20260618110320.545750-1-zhangdandan@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 18, 2026 at 07:03:07PM +0800, Morduan Zang wrote:
> No, I do not have a workload reproducer. I noticed this while reviewing
> the EOF trim in 51d20d1dacbe for backport — our static analysis flagged
> that end_pos - ioend->io_offset is assigned to size_t without ensuring
> end_pos >= ioend->io_offset.

Ok, makes sense.

> If you consider this path unreachable in practice I am happy to drop the
> patch. Otherwise, the guard itself is small and only affects the trim
> branch — I can send a v2 with your suggested ordering if you think it is
> worth hardening even without a reproducer.

I don't think it's impossible.  Just curious where this change comes
from and hoping for a reproducer if we can come up with one.

