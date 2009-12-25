Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBPIgTUI206184 for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 12:42:29 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1B53E9CDF5
	for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 10:43:07 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	nRwSYfgan2Gb2vRk for <xfs@oss.sgi.com>;
	Fri, 25 Dec 2009 10:43:07 -0800 (PST)
Date: Fri, 25 Dec 2009 10:42:30 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
In-Reply-To: <20091225161453.GD32757@thunk.org>
Message-ID: <alpine.DEB.2.01.0912251021340.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: tytso@mit.edu
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, 25 Dec 2009 at 11:14, tytso@mit.edu wrote:
> Did you include the "sync" in part of what you timed?

In my "generic" tests[0] I do "sync" after each of the cp/tar/rm 
operations.

> Peter was quite
> right --- the fact that the measured bandwidth in your "cp" test is
> five times faster than the disk bandwidth as measured by hdparm, and
> many file systems had exactly the same bandwidth, makes me very
> suspicious that what was being measured was primarily memory bandwidth

That's right, and that's what I replied to Peter on jfs-discussion[1]:

  >> * In the "generic" test the 'tar' test bandwidth is exactly the
  >> same ("276.68 MB/s") for nearly all filesystems.
  True, because I'm tarring up ~2.7GB of content while the box is equipped
  with 8GB of RAM. So it *should* be the same for all filesystems, as 
  Linux could easily hold all this in its caches. Still, jfs and zfs 
  manage to be slower than the rest.

> --- and not very useful when trying to measure file system
> performance.

For the bonnie++ tests I chose an explicit filesize of 16GB, two times the 
size of the machine's RAM to make sure it will tests the *disks* 
performance. And to be consistent across one benchmark run, I should have 
copied/tarred/removed 16GB as well. However, I figured not to do that - 
but to *use* the filesystem buffers instead of ignoring them. After all, 
it's not about disk performace (that's what hdparm could be for) but 
filesystem performance (or comparision, more exactly) - and I'm not exited 
about the fact, that almost all filesystems are copying with ~276MB/s but 
I'm wondering why zfs is 13 times slower when copying data or xfs takes 
200 seconds longer than other filesystems, while it's handling the same 
size as all the others. So no, please don't compare the bonnie++ results 
against my "generic" results withing these results - as they're 
(obviously, I thought) taken with different parameters/content sizes.

Christian.

[0] http://nerdbynature.de/benchmarks/v40z/2009-12-22/env/fs-bench.sh.txt
[1] http://tinyurl.com/yz6x2sj
-- 
BOFH excuse #85:

Windows 95 undocumented "feature"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
