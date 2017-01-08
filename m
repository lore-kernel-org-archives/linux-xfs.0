Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35478 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbdAHTJ7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 14:09:59 -0500
Date: Sun, 8 Jan 2017 20:09:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use
        i_rwsem in the VFS inode instead"  change causes hang
Message-ID: <20170108190955.GA1489@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com> <20170108145200.GA29570@lst.de> <1483898365.2542.13.camel@HansenPartnership.com> <20170108181856.GA781@lst.de> <1483901848.2542.27.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483901848.2542.27.camel@HansenPartnership.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, Jan 08, 2017 at 10:57:28AM -0800, James Bottomley wrote:
> I'm unsure about the DIO case, so lets try defining the semantics and
> see if they're implementable for DIO, otherwise simply exclude it.

Let's start with the semantics.  First we need to write down what
IMA requires from the FS, and have an interface how the FS can declare
that it supports these features.  As far as I can tell there are not
proper feature checks anywhere right now.  Once we have done that
we can move forward from there.

As you seem to be interested in IMA how about you spearhead documenting
the requirements and adding xfstests support?

> OK, so how about we define it.  I think we need two vfs calls:
> 
> inode_block_local_writes(inode)
> inode_unblock_local_writes(inode)

No.  We need an ->ima_measure file_operation, guts of process_measurement
turned into a library function that the FS can call after taking fs-specific
locks.  And maybe also a small wrapper around it that takes ilock and
can be used directly for file systems not needing special locking.

> With semantics that between these two, all write attempts to the file
> backed by the inode on this system block but reads of the underlying
> file are allowed (I added local so we don't have to implement for
> remote filesystems).

How do you define local?  Are GFS2 and OCFS2 local?  Is XFS with
outstanding pNFS layout local?  Is NFS with the block or SCSI layout
local because it operates on a block device?

The only sane way is to make INA opt-in with a check list of features
that need to be supported, and declared to be supported by the fs,
similar to how we handle NFS exporting.
