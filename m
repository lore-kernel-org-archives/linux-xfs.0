Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C3A15E5D6
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724077070; cv=none; b=ZNEmgzqUC3YQiOuDYAaEmZePUptwPgS4ts7jn8LeNV8+E7cDbrgPLM4GclKy/YPzbc+fG/AKCBDfkFoXLdO8xjHaYKuT8zAP/A+fZK6NR1sGpxEaUmni0YUckR52h6djzTXcYlx6kDCv7EkVc/MR/kBgDbL6CnkfACk0M2IZnqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724077070; c=relaxed/simple;
	bh=RqZWoKpKTGWk09law4kuCdcjLVtRZIj3J+L83EJWmDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qpup03lUSAVXvda+aq9hc1/VFNAWMj02OS+V4N7Oes9bfvffcg05ArWceoOpMXPawIfjcOulE87B40a8cpiYax++j8uIQoSw94ZE8If7yC7pH4SonUzuVbyPCofnlKb2QCuxEI+0kpDOICXoac4lsFa75/Dq26XN+YLl014UzqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RU7VryTW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RU7VryTW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C1KvwdvNX/YNJHfr7DhZxcYe0h7mS0Z1W0tRtvSG+H4=; b=RU7VryTW+OOzlMGstcYMhWzJvg
	bsd/hkcX98quZ/IIGb2BW+FpXlvtg/4meDXi05HDhfnwUhve/T5qAWmf4/7cZzAZjfOUD3AXmgXNM
	i+FKnmzMg3yByLr9M09lDuHk7ohE96Ghw6x1WWSTZDBi3URjPq8/lv3y2GPmJ228T46ta0f5pZihv
	1JuQ+uZILC/GII49NFIeofCxoFW/pfzp625M7aEQmy0NfcQFul65yzSGNTJsNCr/w9kVfIfcuw9ot
	/p7oipAyxOyhhIC6psyxBsVKp9ZM2Z2SJj15ibH9Kru4/y9ue6S6PLk66JUOZSNxGDEH0a4/3MlXr
	tY1I/CRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sg3Cb-00000001ie1-2EDX;
	Mon, 19 Aug 2024 14:17:45 +0000
Date: Mon, 19 Aug 2024 07:17:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julien Olivain <ju.o@free.fr>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] libxfs: provide a memfd_create() wrapper if not
 present in libc
Message-ID: <ZsNUCdDpYO3BNDCt@infradead.org>
References: <20240817160052.2810571-1-ju.o@free.fr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240817160052.2810571-1-ju.o@free.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Aug 17, 2024 at 06:00:52PM +0200, Julien Olivain wrote:
> Commit 1cb2e387 "libxfs: add xfile support" introduced
> a use of the memfd_create() system call, included in version
> xfsprogs v6.9.0.
> 
> This system call was introduced in kernel commit [1], first included
> in kernel v3.17 (released on 2014-10-05).
> 
> The memfd_create() glibc wrapper function was added much later in
> commit [2], first included in glibc version 2.27 (released on
> 2018-02-01).

I guess 6 years old is still worth supporting.  The code itself looks
good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
