Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 03:30:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TAUXKl000760
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 03:30:35 -0700
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D0C1B0162F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 03:30:34 -0700 (PDT)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id 6rTy94e23RUSrLAa for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 03:30:34 -0700 (PDT)
Date: Wed, 29 Oct 2008 11:30:29 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029103029.GC5953@wotan.suse.de>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029091203.GA32545@infradead.org> <20081029092143.GA5953@wotan.suse.de> <20081029094417.GA21824@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029094417.GA21824@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 05:44:17AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 29, 2008 at 10:21:43AM +0100, Nick Piggin wrote:
> > Please do.
> 
> Well, there's one stumling block I haven't made progress on yet:
> 
> I've changed the prototype of ->fsync to lose the dentry as we should
> always have a valid file struct.  Except that nfsd doesn't on
> directories.  So I either need to fake up a file there, or bail out
> and add a ->dir_sync export operation that needs just a dentry.

OK. I don't know much about hthat code, but I would think nfsd
should look as close to the syscall layer as possible. I guess
there must be something prohibitive (some protocol semantics?).

Is there anything that particularly makes it a file operation
as opposed to an inode operation?
