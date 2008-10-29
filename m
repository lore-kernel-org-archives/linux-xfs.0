Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 02:13:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T9DRpi027904
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:13:27 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFAF45576F5
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:13:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id l9Wc20BEXRLgQQhC for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 02:13:27 -0700 (PDT)
Date: Wed, 29 Oct 2008 05:13:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029091326.GB32545@infradead.org>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029032601.GF4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029032601.GF4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 02:26:01PM +1100, Dave Chinner wrote:
> Ok, I was right - these problems happen all the time. The above call
> should really call xfs_flush_pages() to do the flush and wait. I
> note that xfs_flush_pages() returns negative errors, and all the
> callers expect positive errors. I bet the same occurs for
> xfs_flushinval_pages() and xfs_tosspages() which are the wrappers
> that core XFS code is supposed to be using for flushing and
> invalidating file ranges....
> 
> I'll write up a patch that covers all of these.

Can you also merge xfs_fsync into xfs_file_fsync while you're at it?
The split newer made any sense as xfs_fsync is as Linux-specific as it
gets and shouldn't be in the pseudo OS-independent layer.
