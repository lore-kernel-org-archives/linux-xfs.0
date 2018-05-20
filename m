Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbeETTUP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 15:20:15 -0400
Date: Sun, 20 May 2018 12:20:09 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] fs: clear writeback errors in inode_init_always
Message-ID: <20180520192009.GA22365@bombadil.infradead.org>
References: <20180518225037.GA26206@thunk.org>
 <630faadb74f608aa5a42649b81657e8b62d46bc3.camel@kernel.org>
 <20180519152700.GB4507@magnolia>
 <20180519231944.GB23448@thunk.org>
 <fa3b4dec3452aa5696b8657ef509891908901d95.camel@kernel.org>
 <20180520125843.GA25612@bombadil.infradead.org>
 <20180520162954.GA5250@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180520162954.GA5250@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jeff Layton <jlayton@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On Sun, May 20, 2018 at 12:29:54PM -0400, Theodore Y. Ts'o wrote:
> On Sun, May 20, 2018 at 05:58:43AM -0700, Matthew Wilcox wrote:
> > On Sun, May 20, 2018 at 07:45:31AM -0400, Jeff Layton wrote:
> > > [PATCH] loop: clear wb_err in bd_inode when detaching backing file
> > 
> > Is this the right thing to do?  Putting the test-suite aside for the
> > moment, if I have a loop device on a file and I hit a real error on the
> > storage backing that file, I don't see why detaching the loop device
> > from the file should clear the error.
> > 
> > I'm really tempted to say that we should fix the test-suite to consume
> > the error; once it's been read by at least one reader, it won't go back
> > to zero, but neither will it show up for new readers.
> 
> You can't detach the backing store if there are any open file
> descriptors (or if there is another loop device keeping the loop
> device open, or if there is a file system mounted on it, etc.).
> 
> If you can detach the backing store, once you detach the backing
> store, the loop device is *gone*.  The user of /dev/loop0 will very
> likely be a completely different backing store, so returning an error
> simply doesn't make any sense.  There is a very good chance it will be
> a completely different backing store, with potentially a different
> user, so returning a carried over error is just going confuse, annoy,
> and anger the user.....

Oh!  I misunderstood.  I thought that bd_inode->i_mapping pointed to
lo_backing_file->f_mapping.

So how about this to preserve the error _in the file with the error_?

	if (bdev) {
		bdput(bdev);
		invalidate_bdev(bdev);
+		filp->f_mapping->wb_err = bdev->bd_inode->i_mapping->wb_err;
+		bdev->bd_inode->i_mapping->wb_err = 0;
	}
	set_capacity(lo->lo_disk, 0);
	loop_sysfs_exit(lo);

