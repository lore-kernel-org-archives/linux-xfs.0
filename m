Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50648 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753222AbdAHR7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 12:59:33 -0500
Message-ID: <1483898365.2542.13.camel@HansenPartnership.com>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use i_rwsem
 in the VFS inode instead"  change causes hang
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 08 Jan 2017 09:59:25 -0800
In-Reply-To: <20170108145200.GA29570@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
         <20170108145200.GA29570@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, 2017-01-08 at 15:52 +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 09:48:44AM -0500, Mimi Zohar wrote:
> > IMA takes the i_rwsem (fomerly i_mutex) before reading the file to
> > synchronize calculating the file hash and validating the file's
> > hash/signature stored as security.ima xattr
> 
> Well, it shouldn't do that.  In the I/O path i_rwsem is up to the
> fs to use.  Various other file systems also take it internally for
> reads, although mostly only for direct I/O.

Hey, that's not really true: the inode lock (i_rwsem) is used in all
sorts of generic places, including generic_file_write_iter().  That's,
I think, why ima is using it to try to prevent writes while it measures
the file.

> So the answer here is that ima needs to stop playing with i_rwsem.

Isn't there a happy medium? most sensible filesystems will allow shared
reading (unless they want to tank performance) so we can rely on the
fact that even if a fs does use i_rwsem internally on the read path, it
will have to be shared.  So simply replacing the inode_lock() in ima
with inode_lock_shared() should do what ima wants and not interact
badly even if the underlying FS uses i_rwsem.  If there's ever a FS
that takes it exclusively in the read path, ima can simply blacklist
it.

James


