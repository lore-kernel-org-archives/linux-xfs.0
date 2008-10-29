Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 02:12:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T9C5SF027646
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:12:07 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A99514A6C21
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:12:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 0XGI3y7r8xqUhwjh for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:12:06 -0700 (PDT)
Date: Wed, 29 Oct 2008 05:12:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029091203.GA32545@infradead.org>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029031645.GE4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 02:16:45PM +1100, Dave Chinner wrote:
> Yeah, that'd do it. Good catch. I can't believe I recently fixed a
> bug that touched these lines of code without noticing the inversion.
> Sometimes I wonder if we should just conver the entire of XFS to
> return negative errors - mistakes in handling negative error numbers
> in the core XFS code happen all the time.
> 
> FWIW, the core issue here is that we've got to do the
> filemap_fdatawait() call in the ->fsync method because ->fsync
> gets called before we've waited for the data I/O to complete.
> XFS updates inode state on I/O completion, so we *must* wait
> for data I/O to complete before logging the inode changes. I
> think btrfs has the same problem....

Yes.  I have patches to fix this by changing what ->fsync does and
how it's called.  I really need to get them out on the list.
