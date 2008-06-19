Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 01:20:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J8KQ0w006008
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:20:27 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53BD3CF3985
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:21:24 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id wtfXlQyVXUA9WBju for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:21:24 -0700 (PDT)
Date: Thu, 19 Jun 2008 04:21:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Directory mtime update issue (kernel 2.6.25)
Message-ID: <20080619082124.GA24076@infradead.org>
References: <20080618144534.GC11301@aurora.pimp.org.za> <20080618163356.GA6330@infradead.org> <20080618191045.GA10722@aurora.pimp.org.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618191045.GA10722@aurora.pimp.org.za>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael-John Turner <mj@mjturner.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 18, 2008 at 08:10:45PM +0100, Michael-John Turner wrote:
> Thanks for the prompt reply and the patch. I'm surprised this hasn't been
> mentioned before as every other Unix filesystem I've used has not updated
> the moved file's mtime during a rename(2). It's also odd that XFS only
> changes the mtime when there's a new parent.
> 
> What does everyone else think? Would it be possible to have this patch or a
> similar one committed upstream?

The patch also passes xfsqa, so it should be ready now.
