Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32768 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdAHPOc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 10:14:32 -0500
Date: Sun, 8 Jan 2017 16:14:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use
        i_rwsem in the VFS inode instead"  change causes hang
Message-ID: <20170108151430.GA29847@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com> <20170108145200.GA29570@lst.de> <1483887789.8189.90.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483887789.8189.90.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, Jan 08, 2017 at 10:03:09AM -0500, Mimi Zohar wrote:
> But not normally for a normal file read.

Depends on the file system.  In addition to XFS at least the NFS
also uses i_rwsem by default.  Also all file systems supporting
a DAX I/O path.

> Unless something has changed recently, to synchronize reading files to
> calculate the file hash and writing xattrs it has to take the i_rwsem
> prior to reading the file.

No, you must simply not do this at all.  If you take a lock that
belongs to the fs and is not your own over ->read_iter you're toast
as you've seen.
