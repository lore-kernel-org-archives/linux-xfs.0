Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 23:49:03 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAG7mtJt027772
	for <xfs@oss.sgi.com>; Thu, 15 Nov 2007 23:49:00 -0800
Date: Fri, 16 Nov 2007 07:23:13 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] Move AIL pushing into a separate thread
Message-ID: <20071116072313.GA17009@infradead.org>
References: <20071105050706.GW66820511@sgi.com> <473BBDC1.2020107@sgi.com> <20071116004310.GL66820511@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116004310.GL66820511@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, Nov 16, 2007 at 11:43:10AM +1100, David Chinner wrote:
> > >+		/* Too many items we can't do anything with? */
> > >+		if (stuck > 100)
> > 100?  Arbitrary magic number or was there reason for this?
> 
> Arbitrary magic number based on observation. basically, if
> we are skipping too many items because we can't flush them or
> they are already being flushed we back off and given them time
> to complete whatever operation is being done. i.e. remove pressure
> from the AIL while we can't make progress so traversals don't
> slow down further inserts and remov?ls to/from the AIL.

Might be worth adding something like this as a comment.
