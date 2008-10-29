Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 14:42:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TLg6jF025143
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:42:06 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69FB355B71C
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:42:05 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id XfsyjVazja2qH3SL for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 14:42:05 -0700 (PDT)
Date: Thu, 30 Oct 2008 08:42:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029214202.GH17077@disturbed>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029032601.GF4985@disturbed> <20081029091326.GB32545@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029091326.GB32545@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 05:13:26AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 29, 2008 at 02:26:01PM +1100, Dave Chinner wrote:
> > Ok, I was right - these problems happen all the time. The above call
> > should really call xfs_flush_pages() to do the flush and wait. I
> > note that xfs_flush_pages() returns negative errors, and all the
> > callers expect positive errors. I bet the same occurs for
> > xfs_flushinval_pages() and xfs_tosspages() which are the wrappers
> > that core XFS code is supposed to be using for flushing and
> > invalidating file ranges....
> > 
> > I'll write up a patch that covers all of these.
> 
> Can you also merge xfs_fsync into xfs_file_fsync while you're at it?
> The split newer made any sense as xfs_fsync is as Linux-specific as it
> gets and shouldn't be in the pseudo OS-independent layer.

I'll do that as a separate patch - it's not really part of a "fix
error value inversion" bug fix....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
