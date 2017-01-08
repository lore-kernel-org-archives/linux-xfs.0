Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50814 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935416AbdAHS5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 13:57:30 -0500
Message-ID: <1483901848.2542.27.camel@HansenPartnership.com>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use i_rwsem
 in the VFS inode instead"  change causes hang
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 08 Jan 2017 10:57:28 -0800
In-Reply-To: <20170108181856.GA781@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
         <20170108145200.GA29570@lst.de>
         <1483898365.2542.13.camel@HansenPartnership.com>
         <20170108181856.GA781@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, 2017-01-08 at 19:18 +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 09:59:25AM -0800, James Bottomley wrote:
> > Hey, that's not really true: the inode lock (i_rwsem) is used in 
> > all sorts of generic places, including generic_file_write_iter(). 
> >  That's, I think, why ima is using it to try to prevent writes 
> > while it measures the file.
> 
> But all these are _below_ file_operations.  The only place where take
> them in the VFS is for namespace locking, e.g. before calling into
> inode_operations (to generalize a little).

Definitely agree we need an abstraction with defined semantics.

> > > So the answer here is that ima needs to stop playing with
> > > i_rwsem.
> > 
> > Isn't there a happy medium? most sensible filesystems will allow 
> > shared reading (unless they want to tank performance) so we can 
> > rely on the fact that even if a fs does use i_rwsem internally on 
> > the read path, it will have to be shared.
> 
> At least for direct I/O that doesn't always have to be true.

I'm unsure about the DIO case, so lets try defining the semantics and
see if they're implementable for DIO, otherwise simply exclude it.

> > So simply replacing the inode_lock() in ima
> > with inode_lock_shared() should do what ima wants and not interact
> > badly even if the underlying FS uses i_rwsem.  If there's ever a FS
> > that takes it exclusively in the read path, ima can simply
> > blacklist
> > it.
> 
> IFF we actually allow recursive readers for rw_semaphores this would
> work around the issue (but I'm not sure about that fact, at least
> in the past we didn't).  It won't fix IMA for all the file systems
> use other synchronization for reads, e.g. the cluster locks in ocfs2
> or gfs2.  It won't fix NFS which will exhibit exacly the same issue
> as Mimi reported.
> 
> Last but not least it won't solve the problem that IMA has never been
> designed and does neither document the requires it has from a file 
> system, nor is there any systematic testing for it.  It will keep on 
> breaking because it has all kinds of weird implicit assumptions never 
> written down or verified, and the test coverage for it is basically
> non-existing.

OK, so how about we define it.  I think we need two vfs calls:

inode_block_local_writes(inode)
inode_unblock_local_writes(inode)

With semantics that between these two, all write attempts to the file
backed by the inode on this system block but reads of the underlying
file are allowed (I added local so we don't have to implement for
remote filesystems).  inode_block_local_writes() will block until all
local writes to the file have finished, so you're guaranteed the file
only allows reads when it succeeds.

As for implementation in the vfs, I suspect an outstanding write count
in the inode might be the better way?

James

