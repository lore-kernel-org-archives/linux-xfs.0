Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34874 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752378AbdAHSS7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 13:18:59 -0500
Date: Sun, 8 Jan 2017 19:18:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use
        i_rwsem in the VFS inode instead"  change causes hang
Message-ID: <20170108181856.GA781@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com> <20170108145200.GA29570@lst.de> <1483898365.2542.13.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483898365.2542.13.camel@HansenPartnership.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, Jan 08, 2017 at 09:59:25AM -0800, James Bottomley wrote:
> Hey, that's not really true: the inode lock (i_rwsem) is used in all
> sorts of generic places, including generic_file_write_iter().  That's,
> I think, why ima is using it to try to prevent writes while it measures
> the file.

But all these are _below_ file_operations.  The only place where take
them in the VFS is for namespace locking, e.g. before calling into
inode_operations (to generalize a little).

> 
> > So the answer here is that ima needs to stop playing with i_rwsem.
> 
> Isn't there a happy medium? most sensible filesystems will allow shared
> reading (unless they want to tank performance) so we can rely on the
> fact that even if a fs does use i_rwsem internally on the read path, it
> will have to be shared.

At least for direct I/O that doesn't always have to be true.

> So simply replacing the inode_lock() in ima
> with inode_lock_shared() should do what ima wants and not interact
> badly even if the underlying FS uses i_rwsem.  If there's ever a FS
> that takes it exclusively in the read path, ima can simply blacklist
> it.

IFF we actually allow recursive readers for rw_semaphores this would
work around the issue (but I'm not sure about that fact, at least
in the past we didn't).  It won't fix IMA for all the file systems
use other synchronization for reads, e.g. the cluster locks in ocfs2
or gfs2.  It won't fix NFS which will exhibit exacly the same issue
as Mimi reported.

Last but not least it won't solve the problem that IMA has never been
designed and does neither document the requires it has from a file system,
nor is there any systematic testing for it.  It will keep on breaking
because it has all kinds of weird implicit assumptions never written down
or verified, and the test coverage for it is basically non-existing.

