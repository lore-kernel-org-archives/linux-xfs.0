Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 07:46:09 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EEk34p006850
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 07:46:04 -0700
Date: Fri, 14 Sep 2007 15:46:04 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 968767 - Ensure file size updates have been completed before writing inode to disk.
Message-ID: <20070914144604.GA25941@infradead.org>
References: <200709130330.l8D3UGu9004196@redback.melbourne.sgi.com> <20070913112046.GA25515@infradead.org> <20070914000556.GX734179@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914000556.GX734179@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 10:05:56AM +1000, David Chinner wrote:
> > But hopefully I'll push changes to the core code soon
> > to move the filemap_datawrite/wait into fs domain completely.
> 
> What timeframe are we looking at there?

I'll aim for 2.6.25, but there is some mess to sort out with the fsync
prototype first.
