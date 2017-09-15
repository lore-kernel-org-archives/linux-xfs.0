Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8485 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751741AbdIOWm3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Sep 2017 18:42:29 -0400
Date: Fri, 15 Sep 2017 16:42:27 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH v2] xfs: add regression test for DAX mount option
 usage
Message-ID: <20170915224227.GA9020@linux.intel.com>
References: <CAPcyv4gGpAW7kUCgqSoNCPkFZVYzTVQi3C4x6AFm2KHvFrZSfw@mail.gmail.com>
 <20170911200103.28226-1-ross.zwisler@linux.intel.com>
 <20170914065741.GH8034@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170914065741.GH8034@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, fstests@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Thu, Sep 14, 2017 at 02:57:41PM +0800, Eryu Guan wrote:
> Hi Ross,
> 
> On Mon, Sep 11, 2017 at 02:01:03PM -0600, Ross Zwisler wrote:
> > This adds a regression test for the following kernel patch:
> > 
> >   xfs: always use DAX if mount option is used
> > 
> > This test will also pass with kernel v4.14-rc1 and beyond because the XFS
> > DAX I/O mount option has been disabled (but not removed), so the
> > "chattr -x" to turn off DAX doesn't actually do anything.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > ---
> > 
> > Changes since v1:
> >  - Use perf instead of tracepoints to detect whether DAX is used. (Dan)
> 
> Thanks for the test! But I agreed with Dave here, it doesn't seem like a
> good idea to depend on the kernel tracepoints in a test, but I can't
> think of a better solution either, so I didn't get to this patch
> earlier..
> 
> Before XFS disabled the ability to switch on & off per-inode DAX flag,
> the x flag was only shown after an explicit 'chattr +x', even if XFS was
> mounted with dax option, e.g.
> 
> # mkfs -t xfs -f /dev/ram0
> # mount -o dax /dev/ram0 /mnt/xfs
> # echo "test" > /mnt/xfs/testfile
> # xfs_io -c "lsattr" /mnt/xfs/testfile
> ---------------- /mnt/xfs/testfile
> # xfs_io -c "chattr +x" /mnt/xfs/testfile
> # xfs_io -c "lsattr" /mnt/xfs/testfile
> ---------------x /mnt/xfs/testfile

XFS actually still works this way, you just don't get dax now when you chattr
+x. :-/  But the inode flag is actually still there, gets updated by chattr
and can be listed with lsattr.

Actually, that feels like a really bad situation to be in - Christoph & Dave,
should we do more to remove the flag as long as it's not working?  i.e. remove
it from the lsattr output and make "chattr +x" fail with -EINVAL or similar?

> I'm wondering if it makes sense to make lsattr print the x flag by
> default when XFS is mounted with dax option, that way, we have a method
> to know whether dax is used or not on a particular file too.

Well, the per-inode flag that gets set in the filesystem metadata and the
actual S_DAX runtime flag which controls whether or not we do DAX I/O and page
faults are different things, and as we've seen they aren't always
synchronized.

I think making the 'x' flag in lsattr reflect the current state of S_DAX is
interesting, but it would suffer from the same TOCTOU races that Dave was
concerned about for the proposed VM_DAX flag:

https://lkml.org/lkml/2016/9/16/13

It could also be surprising to users - if they had mounted with -o dax, lsattr
on each of their files would show the 'x' flag, but if they remount without
that option those 'x' flags would go away.  I think this is surprising because
normally it takes a chattr to modify the flags.
