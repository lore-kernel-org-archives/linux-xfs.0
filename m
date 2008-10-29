Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 02:21:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T9Lj0E028713
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:21:45 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA4A95575B7
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:21:45 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id w1RySkyLs6e9f0oN for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:21:45 -0700 (PDT)
Date: Wed, 29 Oct 2008 10:21:43 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029092143.GA5953@wotan.suse.de>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029091203.GA32545@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029091203.GA32545@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 05:12:03AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 29, 2008 at 02:16:45PM +1100, Dave Chinner wrote:
> > Yeah, that'd do it. Good catch. I can't believe I recently fixed a
> > bug that touched these lines of code without noticing the inversion.
> > Sometimes I wonder if we should just conver the entire of XFS to
> > return negative errors - mistakes in handling negative error numbers
> > in the core XFS code happen all the time.
> > 
> > FWIW, the core issue here is that we've got to do the
> > filemap_fdatawait() call in the ->fsync method because ->fsync
> > gets called before we've waited for the data I/O to complete.
> > XFS updates inode state on I/O completion, so we *must* wait
> > for data I/O to complete before logging the inode changes. I
> > think btrfs has the same problem....
> 
> Yes.  I have patches to fix this by changing what ->fsync does and
> how it's called.  I really need to get them out on the list.

Please do.
