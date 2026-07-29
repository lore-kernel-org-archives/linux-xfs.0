Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2623B3A48F7;
	Wed, 29 Jul 2026 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306461; cv=none; b=egVv+7UU799bOOOxuosiCHXGvfUU6WVpkghPb8yN2PJPPNw53Vsam6p1QgqePWk1sjfMAX4JcJWxuReZxYE0y2qLmxRhu9qn1+niXiUjU5v9/VPj+gRKkj7+U1vPQkg+3sZZ3F0s0NGw+7QsiFleMwTRVEOPawZssTXpko/oHC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306461; c=relaxed/simple;
	bh=L/QFp5Pf4kmDUuqUYu5huY9PgZzASRZCpZzreISkzG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVEZgk1QP4vico37Q0MfLdHyw1w9SJCrULURIpiRq8E36rtyFGXgTxSvzm4VDYfTF9SQslfCJJHbJmN7WKtEUgowxXCtLpTPvoHpP3HWeF6X6lNcnyTCfWvcxkOLn/jmsM6C5Kk9G1kPDLrdRdeSO0C+jOMPwCzvcrk3mraCNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZsZY7cG7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZsZY7cG7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=we2zBkBV1sMyyTnYWgEW4xW+qGlKxs2hSnPL75Esv90=; b=ZsZY7cG7TISOF00itS0tsBVn6C
	SQ8jwg/oOzk58gKTWmUjQUCEprRhZH/PSG8CLrP8q70nJNdpgAIlHaA/Swjx0iDA4+MWCjB8GWqTX
	NdrYTlC5pq7NTdtYOeVqKJOFb1+ui73UKxxIJ/APW0rmaoDjS6f1D9hQWArr+u5QRwVGumyHuMtMo
	6J6u2NJn5Oy9Q0JFGQT/B87DyIEfVfMUaqy9Hto5YfD2jpQ4fzBRY8sYGN/rpep2jU2xCGO/ijQ0y
	4krBdt4IAc1g6eVZZyV20pxoXYs317s25Hd49ZKGzs2OC/ylbXuZP91UYFkb6/36zpD7+7dAanzkS
	g3fXKAAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woxlM-000000071M0-1A4l;
	Wed, 29 Jul 2026 06:27:32 +0000
Date: Tue, 28 Jul 2026 23:27:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ammdVAKErVaSboKA@infradead.org>
References: <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
 <amgrwn0yQoFvJP4u@infradead.org>
 <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 29, 2026 at 02:11:17AM -0400, Tal Zussman wrote:
> No worries, and apologies again for the delay. I had some deadlines and
> travel that kept me busy, but I have some additional results below:

Cool!

> 
> First, I investigated the workload C behavior further. The underlying
> problem is that ioends routed to the XFS completion workqueue were also
> carrying BIO_COMPLETE_IN_TASK, so unwritten completions bounced through the
> block-layer worker (plus its delay) only to be queued on
> m_unwritten_workqueue afterwards. The ioend workqueue already provides the
> task context the flag asks for, so something like this avoids the bounce:

Ah, cool - yes, we should not double-defer.  I suspect we might be
able to do something cleaner than the setting and clearing, but as I
have some work pending in that area I'm happy to look into that after
the basic series lands.

> C) 4k buffered randwrite, qd32 (~118k completions/s)
>   bandwidth (MB/s)                 649.5       655.7       643.4
>   write lat p50 (us)               215.4       214.7       216.1
>   write lat p99.9 (us)             703.1       984.4       730.5
>   context switches                20.69M      21.98M      21.44M
>   cycles                         922.5e9     838.1e9     911.3e9

This is a surprisingly larger drop.

> D) 64k buffered mixed r/w, qd32 (~11k completions/s)
>   bandwidth (MB/s)                 761.2       753.2       757.2

and this a somewhat surprising improvement.

How stable are the results?

> Again, my main concern with this approach is that 16000 (or 1000) is a
> somewhat arbitrary value that depends on disk performance. If the C p99.9
> perf is an acceptable trade-off, I think we can get rid of the delay, but
> I'd appreciate more thoughts on that and the XFS diff above.
> 
> I'll send v7 with the rest of the changes (Sashiko review, etc.) in a day or
> two, pending any additional feedback.

I'd be tempted to do delay=0 for now to get things going, and then
look into fine-tuning to see if we can come up with a good threshold
instead.

I also think in the longer run avoid the current workqueue and having
some sort of thread without the workqueue scheduling overhead would
be beneficial, as that would entirely avoid wakeups if the thread is
running.  But I'd rather get a nicely working API in first and then
fine tune it later.

