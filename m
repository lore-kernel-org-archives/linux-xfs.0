Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60650 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdAHOwC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jan 2017 09:52:02 -0500
Date: Sun, 8 Jan 2017 15:52:00 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use
        i_rwsem in the VFS inode instead"  change causes hang
Message-ID: <20170108145200.GA29570@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483886924.8189.81.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, Jan 08, 2017 at 09:48:44AM -0500, Mimi Zohar wrote:
> IMA takes the i_rwsem (fomerly i_mutex) before reading the file to
> synchronize calculating the file hash and validating the file's
> hash/signature stored as security.ima xattr

Well, it shouldn't do that.  In the I/O path i_rwsem is up to the
fs to use.  Various other file systems also take it internally for
reads, although mostly only for direct I/O.

So the answer here is that ima needs to stop playing with i_rwsem.
