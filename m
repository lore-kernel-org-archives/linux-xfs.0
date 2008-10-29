Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 22:27:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T5RBbq007633
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 22:27:11 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF132556CFC
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 22:27:11 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 5rnpDDNClKvpkk2i for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 22:27:11 -0700 (PDT)
Date: Wed, 29 Oct 2008 16:27:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029052707.GH4985@disturbed>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029040014.GB17624@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029040014.GB17624@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org

On Wed, Oct 29, 2008 at 05:00:14AM +0100, Nick Piggin wrote:
> On Wed, Oct 29, 2008 at 02:16:45PM +1100, Dave Chinner wrote:
> > FWIW, the core issue here is that we've got to do the
> > filemap_fdatawait() call in the ->fsync method because ->fsync
> > gets called before we've waited for the data I/O to complete.
> > XFS updates inode state on I/O completion, so we *must* wait
> > for data I/O to complete before logging the inode changes. I
> > think btrfs has the same problem....
> 
> Interesting. Does that mean you can do without the final filemap_fdatawait?

We could, yes.

> Can you do the first fdatawait without i_mutex held?

I don't see why not - I/O completion is only touching the XFS inode.
XFS has it's own inode locks for I/O and inode exclusion, and the
mapping tree lock protects the tree walk that the fdatawait is
doing...

> There was some talk IIRC about moving all this logic into the filesystem
> to provide more flexibility here. If there is still enough interest,
> we should get that moving...

It would simplify some of the code in XFS, that's for sure ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
