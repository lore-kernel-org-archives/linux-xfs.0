Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5L9I7nd027151 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 04:18:08 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IZ9EZZwjXZkMBmPf for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 02:18:06 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1ShdWd-00038B-I9
	for xfs@oss.sgi.com; Thu, 21 Jun 2012 19:18:03 +1000
Date: Thu, 21 Jun 2012 19:18:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [regression] stack overflow in xfs_buf_iodone_callbacks
Message-ID: <20120621091803.GB10673@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Folks,

I just had a stack overflow in the delayed write buffer error
handling with a shut down filesystem:

.....
[   20.712744]  [<ffffffff81448023>] xfs_buf_iodone_work+0x23/0x50
[   20.712744]  [<ffffffff814481a0>] xfs_buf_ioend+0x70/0x180
[   20.712744]  [<ffffffff814484c5>] _xfs_buf_ioend+0x25/0x30
[   20.712744]  [<ffffffff81448788>] __xfs_buf_iorequest+0x98/0x130
[   20.712744]  [<ffffffff81448836>] xfs_buf_iorequest+0x16/0x20
[   20.712744]  [<ffffffff81448945>] xfs_bdstrat_cb+0x65/0x110
[   20.712744]  [<ffffffff814b9d7c>] xfs_buf_iodone_callbacks+0x11c/0x290
[   20.712744]  [<ffffffff81448023>] xfs_buf_iodone_work+0x23/0x50
[   20.712744]  [<ffffffff814481a0>] xfs_buf_ioend+0x70/0x180
[   20.712744]  [<ffffffff814484c5>] _xfs_buf_ioend+0x25/0x30
[   20.712744]  [<ffffffff81448788>] __xfs_buf_iorequest+0x98/0x130
[   20.712744]  [<ffffffff81448836>] xfs_buf_iorequest+0x16/0x20
[   20.712744]  [<ffffffff81448945>] xfs_bdstrat_cb+0x65/0x110
[   20.712744]  [<ffffffff814b9d7c>] xfs_buf_iodone_callbacks+0x11c/0x290
[   20.712744]  [<ffffffff81448023>] xfs_buf_iodone_work+0x23/0x50
[   20.712744]  [<ffffffff814481a0>] xfs_buf_ioend+0x70/0x180
[   20.712744]  [<ffffffff814484c5>] _xfs_buf_ioend+0x25/0x30
[   20.712744]  [<ffffffff81448788>] __xfs_buf_iorequest+0x98/0x130
[   20.712744]  [<ffffffff81448836>] xfs_buf_iorequest+0x16/0x20
[   20.712744]  [<ffffffff81448945>] xfs_bdstrat_cb+0x65/0x110
[   20.712744]  [<ffffffff814b9d7c>] xfs_buf_iodone_callbacks+0x11c/0x290
[   20.712744]  [<ffffffff81448023>] xfs_buf_iodone_work+0x23/0x50
[   20.712744]  [<ffffffff814481a0>] xfs_buf_ioend+0x70/0x180
[   20.712744]  [<ffffffff814484c5>] _xfs_buf_ioend+0x25/0x30
[   20.712744]  [<ffffffff81448788>] __xfs_buf_iorequest+0x98/0x130
[   20.712744]  [<ffffffff81448836>] xfs_buf_iorequest+0x16/0x20
[   20.712744]  [<ffffffff81448945>] xfs_bdstrat_cb+0x65/0x110
[   20.712744]  [<ffffffff81448c39>] __xfs_buf_delwri_submit+0x249/0x280
[   20.712744]  [<ffffffff81449920>] xfs_buf_delwri_submit_nowait+0x20/0x30
[   20.712744]  [<ffffffff814bc43e>] xfsaild+0x21e/0x750
[   20.712744]  [<ffffffff810a0472>] kthread+0xa2/0xb0
[   20.712744]  [<ffffffff81b83c64>] kernel_thread_helper+0x4/0x10

Basically, the commit:

43ff212 xfs: on-stack delayed write buffer lists

took away the delay in resubmitting metadata buffers that have
had a write error, and so the xfsbdstrat() resubmission immediately
errors out on the shutdown flag, calling the io completion for teh
buffer that then runs xfs_buf_iodone_callbacks(), that then calls
xfs_bdstrat_cb(), that then errors out on the shutdown flag, calls
io completion, and around it goes in a spiral of death.

I did flag the change to an immediate xfsbdstrat() call as a problem
in review, and mentioned a possible solution to the problem, but it
looks like it fell through the cracks

http://oss.sgi.com/archives/xfs/2012-04/msg00760.html

	"This will just resubmit the IO immediately after it is
	failed, while previously it will only be pushed again after
	it ages out (15s later). Perhaps it can just be left to be
	pushed by the aild next time it passes over it?"

That would definitely prevent the Spiral of Stack Doom that I've
just seen....

I don't have time to come up with a fix for this right now, but it
needs to be fixed before 3.5 releases. I don't have time because I'm
going to be AFK next week, so I'd appreciate it if someone could
look at fixing this in the mean time?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
