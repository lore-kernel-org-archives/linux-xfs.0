Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 10:31:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NHU3Qe022270
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 10:30:07 -0700
Date: Thu, 23 Oct 2008 13:31:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: assertion failure with latest xfs
Message-ID: <20081023173149.GA30316@infradead.org>
References: <49003EFF.4090404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49003EFF.4090404@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2008 at 07:08:15PM +1000, Lachlan McIlroy wrote:
> Just encountered this after pulling in the latest changes.  We are trying to
> initialise an inode that should have an i_count of 1 but instead it is 2.  I
> was running XFSQA test 167 when it happened.

I think the assert is incorrect.  The inode has been added to the radix
tree in xfs_iget_cache_miss, and starting from that point an igrab can
kick in from the sync code and bump the refcount.
