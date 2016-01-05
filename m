Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B459829DF5
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 17:54:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65557AC002
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 15:54:43 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id krCKlcMOBwYZmjIz for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 15:54:42 -0800 (PST)
Date: Wed, 6 Jan 2016 07:53:09 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 35/35] block, drivers, fs: rename REQ_FLUSH to REQ_PREFLUSH
Message-ID: <201601060734.Dqx8lzOI%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1452027218-32303-36-git-send-email-mchristi@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, osd-dev@open-osd.org, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mike,

[auto build test ERROR on next-20160105]
[cannot apply to dm/for-next v4.4-rc8 v4.4-rc7 v4.4-rc6 v4.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/separate-operations-from-flags-in-the-bio-request-structs/20160106-052858
config: um-x86_64_defconfig (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um SUBARCH=x86_64

All errors (new ones prefixed by >>):

   arch/um/drivers/ubd_kern.c: In function 'ubd_add':
   arch/um/drivers/ubd_kern.c:869:43: error: macro "blk_queue_flush" passed 2 arguments, but takes just 1
     blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
                                              ^
   arch/um/drivers/ubd_kern.c:869:2: error: 'blk_queue_flush' undeclared (first use in this function)
     blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
     ^
   arch/um/drivers/ubd_kern.c:869:2: note: each undeclared identifier is reported only once for each function it appears in
   arch/um/drivers/ubd_kern.c: In function 'do_ubd_request':
>> arch/um/drivers/ubd_kern.c:1293:24: error: 'REQ_FLUSH' undeclared (first use in this function)
      if (req->cmd_flags & REQ_FLUSH) {
                           ^

vim +/REQ_FLUSH +1293 arch/um/drivers/ubd_kern.c

a0044bdf Jeff Dike          2007-05-06  1287  			dev->start_sg = 0;
a0044bdf Jeff Dike          2007-05-06  1288  			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
a0044bdf Jeff Dike          2007-05-06  1289  		}
a0044bdf Jeff Dike          2007-05-06  1290  
a0044bdf Jeff Dike          2007-05-06  1291  		req = dev->request;
805f11a0 Richard Weinberger 2013-08-18  1292  
805f11a0 Richard Weinberger 2013-08-18 @1293  		if (req->cmd_flags & REQ_FLUSH) {
805f11a0 Richard Weinberger 2013-08-18  1294  			io_req = kmalloc(sizeof(struct io_thread_req),
805f11a0 Richard Weinberger 2013-08-18  1295  					 GFP_ATOMIC);
805f11a0 Richard Weinberger 2013-08-18  1296  			if (io_req == NULL) {

:::::: The code at line 1293 was first introduced by commit
:::::: 805f11a0d515658106bfbfadceff0eb30bd90ad2 um: ubd: Add REQ_FLUSH suppport

:::::: TO: Richard Weinberger <richard@nod.at>
:::::: CC: Richard Weinberger <richard@nod.at>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--u3/rZRmxL6MmkK24
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--u3/rZRmxL6MmkK24--
