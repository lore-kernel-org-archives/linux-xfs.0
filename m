Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A754E43C7B6;
	Tue,  4 Aug 2026 13:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785848654; cv=none; b=kjt8UKiCxokrsLS2RCe1mT2YRrtrlb9ymkzixj7OMQp/xvdc4CgTUTIrlwHAP4sXdxgzY/Ui6PDwU/3DTR3S20ZgjClcfjtu5cZ3YovhXAfRv5JB+hvLjnyyQhYGx1ClY53RVCWThH9JZq+a0rhTj14czJTaBEZ3tXeiJq0C6pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785848654; c=relaxed/simple;
	bh=ZCeNCBoxvi1EiAiAIP93iHr1y7Woff81jffOy++3ziU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxtKCbt4cjy/2rbEJt2264XJNdSVd7m4xypOEKxqlSu5ZVGlxQMlT8zvJdzVlsh9KjMCZY4iSeLnT1HsX4+QluZlQWpUl96fmgmgEaHK1sJ9OtYfpoyCX/ZkRmqQvIzUSYPxHBRkZ5FC+ncrew/qRLG6gOd2pmS0Q+ae7QardTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K1Rf8ruX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K1Rf8ruX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LQl1PoD9whXshfiGdiRGN/MouZH83WKAc5uKqtzgf1s=; b=K1Rf8ruXaCO0RHwTW3HGNdLxEN
	UehSuFaYjmEaaycnFZiN1zXEnHPIpv5BQe5q+js0SXAxb3TK4Eyyw3IFJBYhM991O+oZBiGLyF4xG
	D/IIu5cl0XYEmgzOftRVRUHYN0XXfbhDwmMRHoW584lsu4K91Vgou+tdv96EGyc46GJRVKMo6RSYf
	LqEIlAUHCod75QZwf7Q/l+n7ZL+VQdaZw4K8MgdXixh79SEAGwHL3U71hMpCYhR0qnT27wkXgDvr3
	3FvJDKRGqJXN5nNn6rOJV/Dhnq0BaFup841dec2g2gf0W9CppXwCz5+owbsrZyrUQcBApb1qjNLMX
	3gt007yg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEoF-00000001sbx-14Kr;
	Tue, 04 Aug 2026 13:03:55 +0000
Date: Tue, 4 Aug 2026 06:03:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <anHjO1vokMmADsZP@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
 <amsHrVCJnuXzeGG1@infradead.org>
 <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15506dc8-e5b8-4fa8-a85f-912a92edb83f@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 04:39:03PM -0400, Tal Zussman wrote:
> Sorry, I misunderstood and assumed you'd take care of it in a follow-up.
> I'll adjust it as below and send v8.

My plan was to move from the version you had to something better in a
follow-up.  Anyway, Jens merged it as-is so I'll look into a fixup.
Travelling for two conferences this week might make this a bit slow,
though.

> > And move setting the flag to iomap_ioend_writeback_submit, and only
> > for the case where no io_bio.bi_end_io is already assigned.
> > 
> 
> To confirm, this would only work because XFS provides its own task context
> and is the only consumer of iomap that sets its own io_bio.bi_end_io.
> If another filesystem set it and didn't provide task context, this would
> break, right? I can add a comment about this requirement, but I want to
> confirm the intent, as it feels a little fragile as-is.

Yes.  And I think this might be a good time to actually open code
iomap_ioend_writeback_submit in XFS and remove the "accept an overriden
bi_io_end" thing entirely.  Back in the original code that was required,
but now that the submission happens from a file system methods there is
no good reason for keeping it.

