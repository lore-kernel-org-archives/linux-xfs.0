Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F0234845C;
	Fri, 10 Apr 2026 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775827608; cv=none; b=L+a4II2Wh1tntQS1hRZ+sPuuF2vXCZUKJ23P0ozRCkNgURLvPrMEnCFcjGM5LOTmgueRDOJm84976n7nrXucL5BxlB4EajOsXIQQ2i3S02Vp033k6AKHwhkb+zbpy4WnBf3u+NPNRZPMyuAXaz0fxOp2OI8BfEiSYpxeR6ijY8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775827608; c=relaxed/simple;
	bh=ARjLK/yg3r10++1X96g3OCo5oNcBp4oubtfoGQ0pH2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7y74ukXNE87wA/FpqQEz5XMih4T0fxRyG8vhK52cS9wvugrtiOnBnS9mlSSwhqXNB7dmtdrM4htj0IeLzW0aubIfVsAUuqFF9iA9a2Cksv24zMM5gSXCt8AP/aMMdGn4iV2uOIlYoLRcgEnpf32zqtHe+bELASGgTak2/Bj1SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V6MO+8Nf; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V6MO+8Nf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aTNJ1JSJOuyCEAD0SD81iIKvib8YxJR83tAvZlBQ/uQ=; b=V6MO+8NfY8Abp6Hg1tgXrze9Js
	djsU6gl19LWY3cKwYuDRL35dFJFmJT00E7aioJXLRKJ+Vy7zVBUdKO4B1T1M+4QO8T8yEQdcyx6yg
	e1nNGy3islw97egX0w+n0PQmoNwltLokKPWWwDbPT+myLcEH459x8o/ERgq1oS5MLg9lMuRUvOK9u
	HcMIUIsE6DgQRuB+6WBq3A8CZ11kORzn7u9oep2BwVrBWDYRo8koUx+1jhqWlEd8TAp6aNCDOrcnf
	CCy/8MPjnsZf9z+9ln7hzd2oZbUKuY81A3sPJXr2agjtxb//c6lCxRWGQ0WlSNlTMDkgA2NNErjYh
	kvCCO6uA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wBBsY-00000009QcX-1BPO;
	Fri, 10 Apr 2026 13:26:34 +0000
Date: Fri, 10 Apr 2026 14:26:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <adj6iibxNot-yc9X@casper.infradead.org>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-5-hch@lst.de>
 <adgJqiA0vivaW7NA@casper.infradead.org>
 <20260410061725.GA24667@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410061725.GA24667@lst.de>

On Fri, Apr 10, 2026 at 08:17:25AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 09, 2026 at 09:18:50PM +0100, Matthew Wilcox wrote:
> > On Thu, Apr 09, 2026 at 06:02:17PM +0200, Christoph Hellwig wrote:
> > > @@ -1836,9 +1837,7 @@ void bio_endio(struct bio *bio)
> > >  	}
> > >  #endif
> > >  
> > > -	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> > > -		bio_queue_completion(bio);
> > > -	else if (bio->bi_end_io)
> > > +	if (bio->bi_end_io)
> > >  		bio->bi_end_io(bio);
> > 
> > What I liked about this before is that we had one central place that
> > needed to be changed.  This change means that every bi_end_io now needs
> > to check whether the BIO can be completed in its context.
> 
> Yes.  On the other hand we can actually use it when we don't know if
> we need to offload beforehand, which enabls the two later conversions
> and probably more.

I don't understand why we need to remove _this_ way to defer completions
to take context in order to _add_ the ability to defer completions
inside the bi_end_io handler.

