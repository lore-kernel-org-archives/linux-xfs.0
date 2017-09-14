Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbdING5o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 02:57:44 -0400
Date: Thu, 14 Sep 2017 14:57:41 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v2] xfs: add regression test for DAX mount option
 usage
Message-ID: <20170914065741.GH8034@eguan.usersys.redhat.com>
References: <CAPcyv4gGpAW7kUCgqSoNCPkFZVYzTVQi3C4x6AFm2KHvFrZSfw@mail.gmail.com>
 <20170911200103.28226-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911200103.28226-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests@vger.kernel.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

Hi Ross,

On Mon, Sep 11, 2017 at 02:01:03PM -0600, Ross Zwisler wrote:
> This adds a regression test for the following kernel patch:
> 
>   xfs: always use DAX if mount option is used
> 
> This test will also pass with kernel v4.14-rc1 and beyond because the XFS
> DAX I/O mount option has been disabled (but not removed), so the
> "chattr -x" to turn off DAX doesn't actually do anything.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> ---
> 
> Changes since v1:
>  - Use perf instead of tracepoints to detect whether DAX is used. (Dan)

Thanks for the test! But I agreed with Dave here, it doesn't seem like a
good idea to depend on the kernel tracepoints in a test, but I can't
think of a better solution either, so I didn't get to this patch
earlier..

Before XFS disabled the ability to switch on & off per-inode DAX flag,
the x flag was only shown after an explicit 'chattr +x', even if XFS was
mounted with dax option, e.g.

# mkfs -t xfs -f /dev/ram0
# mount -o dax /dev/ram0 /mnt/xfs
# echo "test" > /mnt/xfs/testfile
# xfs_io -c "lsattr" /mnt/xfs/testfile
---------------- /mnt/xfs/testfile
# xfs_io -c "chattr +x" /mnt/xfs/testfile
# xfs_io -c "lsattr" /mnt/xfs/testfile
---------------x /mnt/xfs/testfile

I'm wondering if it makes sense to make lsattr print the x flag by
default when XFS is mounted with dax option, that way, we have a method
to know whether dax is used or not on a particular file too.

Thanks,
Eryu
