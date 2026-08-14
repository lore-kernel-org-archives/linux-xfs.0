Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8883CF1F1
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 07:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786692002; cv=none; b=BNiDrK0YQGx03hCj7NfsicIeyI2MTyelJr1KvEu4Pb0Kmo+Jn48XlNqrwYPHBGbX+Dfe7dSgYKJtr8OK1my3mAk+GnrTiwORy8j2WbBRdBNEHKw6v99x+rzhNF70vsXubJ27iudgz18WJKN0ODHtR3FEppLXQs/ZqqblfqnqiMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786692002; c=relaxed/simple;
	bh=WDsOUE0aOsyxSGZTsNq85XQVIx3SPPkmz2zt0ytNL/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxkUAVlHI0Xp55+bo7Axpie2xmMh1CxoYsgTESba/qp2EEXB/BcGrtUyNzNmKUNVTgPkcJFxKSoeq/BkrbFGql2pOIAPlsf4UaBhdKJbjWupF50gTBjAQyh8UAjiqNx9jHIPC4AdsnlazG4a/Jxg5NyGG4dNhqfqKcBFBcP0wpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mx3x1Bdx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mx3x1Bdx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WDsOUE0aOsyxSGZTsNq85XQVIx3SPPkmz2zt0ytNL/0=; b=mx3x1BdxtWyZYN2Ux5uY6M6hGU
	WSzDhrwWk5KFc6HrPVqExajrFCp6LO+jnHo3vEdTbpIskUMANnaf1mXqhazC3igfglBzliDC6SOLY
	cVU5LwnzH16NGktAjSAzn/nlI9vgJp+t64q6zFAxJ+AEv+s/ia2GrNhMiC2HBwWIcw20ZCq/ozDCU
	z94/GTKoIlLHp62IBbW3G9lsZmCRt6MIACxD4Xfi0ldKjRzxIr9IF5h+I/voCtS8QecDwaajdfXVO
	k62C/6lP3Rkeu1yljn7Nt2eoq/+W1n4iS/YDiUxVSaY9NsuJLzQ9x82ZAgmpgXC0tTmIAfY6eZYQS
	TNIgJAvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wumCt-000000026hn-0TtS;
	Fri, 14 Aug 2026 07:19:59 +0000
Date: Fri, 14 Aug 2026 00:19:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] xfs: mark kmalloc'd xfs_buf items as
 __GFP_RECLAIMABLE
Message-ID: <an7Bn1ZNvQyOUWqc@infradead.org>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <20260813204929.2253988-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813204929.2253988-2-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 13, 2026 at 03:40:52PM -0500, Eric Sandeen wrote:
> xfs_bufs have a shrinker and are therefore reclaimable; mark
> them as such in the kmalloc path, so that they are accounted
> for in this way.

You can use up all 73 characters for your commit log :)

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

