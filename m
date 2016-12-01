Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753428AbcLAK3e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 05:29:34 -0500
Date: Thu, 1 Dec 2016 18:29:32 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: use xfs_vn_setattr_size to check on new size
Message-ID: <20161201102932.GD29149@eguan.usersys.redhat.com>
References: <20161201101800.11419-1-eguan@redhat.com>
 <20161201102635.GA23215@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201102635.GA23215@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 02:26:35AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 01, 2016 at 06:18:00PM +0800, Eryu Guan wrote:
> > Commit 6552321831dc ("xfs: remove i_iolock and use i_rwsem in the
> > VFS inode instead") introduced a regression that truncate(2) doesn't
> > check on new size, so it succeeds even if the new size exceeds the
> > current resource limit. Because xfs_setattr_size() was used instead
> > of xfs_vn_setattr_size(), and the latter calls xfs_vn_change_ok()
> > first to do sanity check on permission and new size.
> 
> Oops, looks like this was a merge error..
> 
> > 
> > This is found by truncate03 test from ltp, and the following is a
> > simplified reproducer:
> > 
> >   #!/bin/bash
> >   dev=/dev/sda5
> >   mnt=/mnt/xfs
> > 
> >   mkfs -t xfs -f $dev
> >   mount $dev $mnt
> > 
> >   # set max file size to 16k
> >   ulimit -f 16
> >   truncate -s $((16 * 1024 + 1)) /mnt/xfs/testfile
> >   [ $? -eq 0 ] && echo "FAIL: truncate exceeded max file size"
> >   ulimit -f unlimited
> >   umount $mnt
> 
> Can you add this to xfstests?

Sure, I'll work on it.

> 
> The patch looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

Eryu
