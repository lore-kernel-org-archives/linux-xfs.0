Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A76D7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 17:59:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D70F304039
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:59:05 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	Ei6RgiRMSyo6Wq6T for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 15:59:03 -0800 (PST)
Subject: [PATCH 0/3] fs, bdev: handle end of life
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 Dec 2015 15:58:36 -0800
Message-ID: <20151201235836.36836.90416.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

As mentioned in [PATCH 1/3] "block, fs: reliably communicate bdev
end-of-life", historically we have waited for filesystem specific
heuristics to attempt to guess when a block device is gone.  Sometimes
this works, but in other cases the system can hang waiting for the fs to
trigger its shutdown protocol.

Now with DAX we need new actions, like unmapping all inodes, to be taken
upon a shutdown event.  Those actions need to be taken whether the
shutdown event comes from the block device being torn down, or some
other file system specific event.

For now, the approach taken in the following patches only affects xfs
and block drivers that are converted to use del_gendisk_queue().  We can
add more filesystems and driver support over time.

Note that 'bdi_gone' was chosen over 'shutdown' so as not to be confused
with generic_shutdown_super()

---

Dan Williams (3):
      block, fs: reliably communicate bdev end-of-life
      xfs: handle shutdown notifications
      writeback: fix false positive WARN in __mark_inode_dirty


 block/genhd.c                |   87 +++++++++++++++++++++++++++++++++++-------
 drivers/block/brd.c          |    3 -
 drivers/nvdimm/pmem.c        |    3 -
 drivers/s390/block/dcssblk.c |    6 +--
 fs/block_dev.c               |   79 +++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c           |    9 ++++
 include/linux/fs.h           |    4 ++
 include/linux/genhd.h        |    1 
 mm/backing-dev.c             |    7 +++
 9 files changed, 166 insertions(+), 33 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
