Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32CEE7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 17:55:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 04C818F8037
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 15:55:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3lVzqQil8pcU1647 for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 15:55:09 -0700 (PDT)
Date: Wed, 20 Aug 2014 08:55:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_write: reservation ran out. Need to up reservation
Message-ID: <20140819225507.GS20518@dastard>
References: <159192779.3859815.1408461799560.JavaMail.zimbra@klaube.net>
	<362338960.3862279.1408462470243.JavaMail.zimbra@klaube.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <362338960.3862279.1408462470243.JavaMail.zimbra@klaube.net>
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
To: Thomas Klaube <thomas@klaube.net>
Cc: xfs@oss.sgi.com

On Tue, Aug 19, 2014 at 05:34:30PM +0200, Thomas Klaube wrote:
> Hi all,
> 
> I am currently testing/benchmarking xfs on top of a bcache. When I run a heavy
> IO workload (fio with 64 threads, read/write) on the device for ~30-45min I get

Can you post the fio job configuration?

> [ 9092.978268] XFS (bcache1): xlog_write: reservation summary:
> [ 9092.978268]   trans type  = (null) (42)
> [ 9092.978268]   unit res    = 18730384 bytes
> [ 9092.978268]   current res = -1640 bytes
> [ 9092.978268]   total reg   = 512 bytes (o/flow = 1163749592 bytes)
> [ 9092.978268]   ophdrs      = 655304 (ophdr space = 7863648 bytes)
> [ 9092.978268]   ophdr + reg = 1171613752 bytes
> [ 9092.978268]   num regions = 2

Oh, my:

> [ 9092.978268]   ophdr + reg = 1171613752 bytes

Thats 1,171,613,752 bytes, or 1.1GB of journal data in that
checkpoint.  It's more than half the size of the journal, so it's
violated fundamental constraints (i.e. no checkpoint shoul dbe
larger than half the log)

We should be committing the checkpoint once the queued metadata is
beyond 12.5% of log space, or about 250MB in this case. The question
is how did that get delayed for so long that we overran the push
threshold by a factor of 3.5?

Hmmmm - I wonder if bcache is causing some kind of kworker or
workqueue starvation? I really need to see that fio job config and
find out a whole lot more about the hardware and storage config you
are running:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> [ 9092.978268] 
> [ 9092.978272] XFS (bcache1): region[0]: LR header - 512 bytes
> [ 9092.978273] XFS (bcache1): region[1]: commit - 0 bytes
> [ 9092.978274] XFS (bcache1): xlog_write: reservation ran out. Need to up reservation
> [ 9092.978303] XFS (bcache1): xfs_do_force_shutdown(0x2) called from line 2036 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa04433c8
> [ 9092.979189] XFS (bcache1): Log I/O Error Detected.  Shutting down filesystem
> [ 9092.979210] XFS (bcache1): Please umount the filesystem and rectify the problem(s)
> [ 9092.979238] XFS (bcache1): xfs_do_force_shutdown(0x2) called from line 1497 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0443b57
> [ 9093.183869] XFS (bcache1): xfs_log_force: error 5 returned.
> [ 9093.489944] XFS (bcache1): xfs_log_force: error 5 returned.
> 
> Kernel is 3.16.1 but this also happens with Ubuntu 3.13.0.34. 
> With the bcache the fio puts ~30k IOps on the filesystem. 

Which is not very much. I do that sort of thing all the time.

> xfs_info:
> meta-data=/dev/bcache1           isize=256    agcount=8, agsize=268435455 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=1949957886, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> umount/mount recovers the fs and the fs seems ok.
> 
> I can reproduce this behavior. Is there anything I could try to debug
> this?

Run the workload directly on the SSD rather than with bcache. Use
mkfs parameters to give you 8 ags and the same size log, and see
if you get the same problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
