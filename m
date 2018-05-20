Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59188 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751067AbeETTli (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 May 2018 15:41:38 -0400
Date: Sun, 20 May 2018 15:41:24 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] fs: clear writeback errors in inode_init_always
Message-ID: <20180520194124.GB5072@thunk.org>
References: <20180518225037.GA26206@thunk.org>
 <630faadb74f608aa5a42649b81657e8b62d46bc3.camel@kernel.org>
 <20180519152700.GB4507@magnolia>
 <20180519231944.GB23448@thunk.org>
 <fa3b4dec3452aa5696b8657ef509891908901d95.camel@kernel.org>
 <20180520125843.GA25612@bombadil.infradead.org>
 <20180520162954.GA5250@thunk.org>
 <20180520192009.GA22365@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180520192009.GA22365@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On Sun, May 20, 2018 at 12:20:09PM -0700, Matthew Wilcox wrote:
> Oh!  I misunderstood.  I thought that bd_inode->i_mapping pointed to
> lo_backing_file->f_mapping.
> 
> So how about this to preserve the error _in the file with the error_?
> 
> 	if (bdev) {
> 		bdput(bdev);
> 		invalidate_bdev(bdev);
> +		filp->f_mapping->wb_err = bdev->bd_inode->i_mapping->wb_err;
> +		bdev->bd_inode->i_mapping->wb_err = 0;
> 	}
> 	set_capacity(lo->lo_disk, 0);
> 	loop_sysfs_exit(lo);

I don't think it's necessary.  wb_err on the underlying file would
have already been set when the error was set.  So if someone tried
calling fsync(2) on the underlying file, it would have collected the
error already.  Re-setting the error when we detach the loop device
doesn't seem to make any sense.

					- Ted
