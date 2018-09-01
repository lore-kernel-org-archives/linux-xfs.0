Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbeIAPQn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Sep 2018 11:16:43 -0400
Date: Sat, 1 Sep 2018 04:05:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] xfs: don't unlock invalidated buf on aborted tx
 commit
Message-ID: <20180901110502.GA29326@infradead.org>
References: <20180829172634.57981-1-bfoster@redhat.com>
 <20180829172634.57981-2-bfoster@redhat.com>
 <20180831072437.GA7079@infradead.org>
 <20180831132119.GB39825@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831132119.GB39825@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Aug 31, 2018 at 09:21:19AM -0400, Brian Foster wrote:
> > > +	} else if (stale) {
> > > +		/*
> > > +		 * Stale buffers remain locked until final unpin unless the bli
> > > +		 * was freed in the branch above. A freed stale bli implies an
> > > +		 * abort because buffer invalidation dirties the bli and
> > > +		 * transaction.
> > > +		 */
> > > +		ASSERT(!freed);
> > 
> > This assert doesn't make sense as we're already in the else statement
> > of the 'if (freed) check.
> > 
> 
> It was intended to be defensive. I actually considered 'else if (freed
> && stale)' so the code was more clear, but settled on this (which is
> eventually replaced).

I see you've resend it, but I still object to an ASSERT(!freed) in
an

	if (freed) {
		..
	} else if (stale) {
		ASSEET(!freed);
	}

statement.  This isn't defensive but just bogus logic.
