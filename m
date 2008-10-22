Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 02:28:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M9SZO5019682
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 02:28:35 -0700
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E1481458BC3
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 02:30:20 -0700 (PDT)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id LHu7H4Blbqh0RThk for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 02:30:20 -0700 (PDT)
Date: Wed, 22 Oct 2008 11:30:18 +0200
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20081022093018.GD4359@wotan.suse.de>
References: <20081021082542.GA6974@wotan.suse.de> <20081021082735.GB6974@wotan.suse.de> <20081021120932.GB13348@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021120932.GB13348@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 08:09:32AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 21, 2008 at 10:27:35AM +0200, Nick Piggin wrote:
> > +		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> > +					-1, PAGE_KERNEL);
> 
> What does the -1 stand for?

Default node.
