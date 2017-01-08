Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32973 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752368AbdAHPh1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 10:37:27 -0500
Date: Sun, 8 Jan 2017 16:37:25 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use
        i_rwsem in the VFS inode instead"  change causes hang
Message-ID: <20170108153725.GA30270@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com> <20170108145200.GA29570@lst.de> <1483887789.8189.90.camel@linux.vnet.ibm.com> <20170108151430.GA29847@lst.de> <1483889482.8189.104.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483889482.8189.104.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, Jan 08, 2017 at 10:31:22AM -0500, Mimi Zohar wrote:
> > Depends on the file system.  In addition to XFS at least the NFS
> > also uses i_rwsem by default.  Also all file systems supporting
> > a DAX I/O path.
> 
> We're only interested in the integrity of the local file system.

And I'm only interested in supporting sane use cases that don't include
IMA.

But even if you only care about local file systems IMA is simply
fundamentally broken.  Read/Write zerialization in Linux has always been
in the fs (or generic library called by it) and not by the caller.

> IMA needs a mechanism for quickly reading a file to calculate the file
> hash and validate (or set) the file signature/hash stored as an xattr,
> prior to any other process getting access to the file.

And that's simply not doable in Linux from a layer outside the file system.
And really questionable even from inside the fs.    We should simply drop
IMA from the tree in the current state because it's obviously broken.

If you can convince fs maintainers to do the right calls from the file
systems itself for given file systems (and only support IMA for those)
we can add it back just for those.
