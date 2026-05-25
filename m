Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E034B30E828;
	Mon, 25 May 2026 05:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779686262; cv=none; b=t/tHOTw55yI8qPeR5yLo/2904g7bLnThCXo7D1ry0CnEeaKwpQHeb9v686y4WiP53uUAhHKQqPeNO/nvgr2bo2RwdON9KMeWoffwzBJekEjnSZFoOzTcqRtWOm6vSJ9GFJx2x3Wj7xgF4OyhCjjJRL1lMHeqEPzDlmaUbGO/lPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779686262; c=relaxed/simple;
	bh=ZhbE90TpM/1he8VU/w83v8tewOyDUveEm8gaa9VDpag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YIzlp3L/s+5csCkS6FSPZbZ9NLsyusqahWD1Ec63UILodhwHBPLKcGkpQOJtjXAupIEfPtBwntVX/AAn33o83FqMnCliG7CCVYzemERIJldbYrF8BKHFbww1xSkDC6WuIlGSEHNSUPep3Aym6zFIkcQ0K1tN6XoJ4NVDKegp9yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GLm05S0P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GLm05S0P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WGFWPzw6+sfQbAaiqeC7ZcWGmRnj56UaqVBKUeVEioE=; b=GLm05S0PC4mGsmC79PM1H00V2a
	bZDM/XiGMekJuKe97X9xAfLAxDV/rMnkNBSDLgOZ3/ylKMgBZdwvLnffl2mFwdPae5Q+832q8eqiB
	BSRO5uuokBeK+XKYCbNp2TAradZX7/IYOlyE2dUKOSNqab98xY6Qdaud8IsLYU27ATb/gdS6t78Bu
	tCIHrhr/FJoo0DS5knx1zdVXph3SrOTV2LEGGQrLXgMbCMJFJKwVz1EnNw+cWVNuw/i6fzUb4u8d4
	tUUzJS7eFimHgrCaY6/KE+eBembed6MlM4geLu5MhUeKky4EYQEtS8jSmHMbMFXhxsTUE5249dP2i
	niEzrsPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNgv-0000000GJGp-3yPC;
	Mon, 25 May 2026 05:17:29 +0000
Date: Sun, 24 May 2026 22:17:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ahPbaSEoNA755Nt3@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 22, 2026 at 06:47:43PM -0400, Tal Zussman wrote:
> > But this 1-jiffie delay also means we unconditionally increase
> > completion latency, which feels like a bad idea.  Do you have any
> > measurements that show where it does benefit?  Note that queing work
> > already often has very measurable latency on it's own.  This also
> > directly contradics the erofs experience that even went to a RT
> > thread to reduce the latency.
> 
> I added this per Dave's feedback on v4, where he noted that XFS inodegc
> uses a delayed work item to avoid context switch storms. There's only a
> delay for the first bio in a batch to complete, as we only delay when the
> list is empty. I'll run some experiments and measure context switches,
> completion latency, etc. to see if this is necessary.

The difference is that XFS inodegc is not latency bound.  Most of the
time no one cares if it is delayed a bit, in the cases where someone
cares we explicitly flush the queues.  I/O completion on the other hand
is something where users very much care about latency.

