Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbeEULUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 May 2018 07:20:08 -0400
Message-ID: <a11668bbe2050c8b5fb8f27b8b301ba8a78e6a97.camel@kernel.org>
Subject: Re: [PATCH] fs: clear writeback errors in inode_init_always
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 21 May 2018 07:20:05 -0400
In-Reply-To: <20180520194124.GB5072@thunk.org>
References: <20180518225037.GA26206@thunk.org>
         <630faadb74f608aa5a42649b81657e8b62d46bc3.camel@kernel.org>
         <20180519152700.GB4507@magnolia> <20180519231944.GB23448@thunk.org>
         <fa3b4dec3452aa5696b8657ef509891908901d95.camel@kernel.org>
         <20180520125843.GA25612@bombadil.infradead.org>
         <20180520162954.GA5250@thunk.org>
         <20180520192009.GA22365@bombadil.infradead.org>
         <20180520194124.GB5072@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>

On Sun, 2018-05-20 at 15:41 -0400, Theodore Y. Ts'o wrote:
> On Sun, May 20, 2018 at 12:20:09PM -0700, Matthew Wilcox wrote:
> > Oh!  I misunderstood.  I thought that bd_inode->i_mapping pointed to
> > lo_backing_file->f_mapping.
> > 
> > So how about this to preserve the error _in the file with the error_?
> > 
> > 	if (bdev) {
> > 		bdput(bdev);
> > 		invalidate_bdev(bdev);
> > +		filp->f_mapping->wb_err = bdev->bd_inode->i_mapping->wb_err;
> > +		bdev->bd_inode->i_mapping->wb_err = 0;
> > 	}
> > 	set_capacity(lo->lo_disk, 0);
> > 	loop_sysfs_exit(lo);
> 
> I don't think it's necessary.  wb_err on the underlying file would
> have already been set when the error was set.  So if someone tried
> calling fsync(2) on the underlying file, it would have collected the
> error already.  Re-setting the error when we detach the loop device
> doesn't seem to make any sense.
> 

(cc'ing linux-block)

Yes, the error would have been set on the original file already. As long
as lo_req_flush or __loop_update_dio weren't called before we detach the
device, it should still be possible to call fsync on the original fd and
get back the error.

As a side note, it looks like __loop_update_dio will discard an error
from vfs_fsync, so certain ioctls against a loop device can cause errors
to be lost. It seems like those ought to get propagated to userland or
to the blockdev's mapping somehow.
-- 
Jeff Layton <jlayton@kernel.org>
