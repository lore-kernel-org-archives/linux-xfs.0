Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54424 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbeJLJvW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Oct 2018 05:51:22 -0400
Date: Thu, 11 Oct 2018 22:21:08 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported
 devices
Message-ID: <20181012022108.GA2420@thunk.org>
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
 <20181011103636.GC9467@quack2.suse.cz>
 <CAPcyv4iAD_wkjY1way1rOxr4=gC_TGx71VquF13ooAuUPz9RJw@mail.gmail.com>
 <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Oct 11, 2018 at 01:38:34PM -0500, Eric Sandeen wrote:
> > The different behavior between filesystems was confusing customers so
> > we had to align them, then the question was which default to pick.
> > Honestly, we came to the decision to bring ext4 in line with the xfs
> > behavior because we thought that would be easier than the alternative.
> > Dave and Christoph made repeated arguments that DAX is just a hidden
> > performance optimization that no application should rely on, so we
> > went the path of least resistance and changed the ext4 default.
> 
> Ok, well, I guess we'd better reconcile "it's a hidden performance hint"
> with "if the administrator asked they must receive..." before making this
> change... cc: hch for bonus input.

And it's not so hidden if there are some applications that are
demanding that they know whether "dax" is turned on....

I don't really care, but it would nice if we settled all of these
disagreements about what dax is one way or another.  Flip a coin if
necessary; ext4 isn't supporting a per-file dax flag right now since
it hasn't been clear whether or not XFS is going to drop support
(which it is claimed we can do since dax is still "experimental").
 
But whether it's flipping a coin or super-soakers at 20 paces, can we
please figure this out?  One way or another?  I'll provide some
suitable coin at LSF/MM if we can't figure it out sooner --- but I
really would prefer that it be sooner.  :-)

Thanks,

						- Ted
