Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2N6GOW045850 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 17:06:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 643181BE568
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 15:07:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	XcfMHcds7sDUAg62 for <xfs@oss.sgi.com>;
	Thu, 02 Dec 2010 15:07:59 -0800 (PST)
Date: Fri, 3 Dec 2010 10:07:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101202230743.GZ16922@dastard>
References: <4CF7A539.1050206@shiftmail.org> <4CF7A9CF.2020904@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CF7A9CF.2020904@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Dec 02, 2010 at 03:14:39PM +0100, Spelic wrote:
> Sorry for replying to my own email already
> one more thing on the 3rd bug:
> 
> On 12/02/2010 02:55 PM, Spelic wrote:
> >Hello all
> >[CUT]
> >.......
> >with NFS over <RDMA or IPoIB> over Infiniband over XFS over
> >ramdisk it is possible to write a file (2.3GB) which is larger
> >than
> 
> This is also reproducible with:
> NFS over TCP over Ethernet over XFS over ramdisk.
> You don't need infiniband for this.
> With ethernet it doesn't hang (that's another bug, for RDMA people,
> in the othter thread) but the file is still 1.9GB, i.e. larger than
> the device.
> 
> 
> Look, after running the test over ethernet,
> at server side:
> 
> # ll -h /mnt/ram
> total 1.5G
> drwxr-xr-x 2 root root   21 2010-12-02 12:54 ./
> drwxr-xr-x 3 root root 4.0K 2010-11-29 23:51 ../
> -rw-r--r-- 1 root root 1.9G 2010-12-02 15:04 zerofile

This is a classic ENOSPC vs NFS client writeback overcommit caching
issue.  Have a look at the block map output - I bet theres holes in
the file and it's only consuming 1.5GB of disk space. use xfs_bmap
to check this. du should tell you the same thing.

Basically, the NFS client overcommits the server filesystem space by
doing local writeback caching. Hence it caches 1.9GB of data before
it gets the first ENOSPC error back from the server at around 1.5GB
of written data. At that point, the data that gets ENOSPC errors is
tossed by the NFS client, and a ENOSPC error is placed on the
address space to be reported to the next write/sync call. That gets
to the dd process when it's 1.9GB into the write.

However, there is still (in this case) 400MB of dirty data in the
NFS client cache that it will try to write to the server. Because
XFS uses speculative preallocation and reserves some space for
metadata allocation during delayed allocation, it's handling of the
initial ENOSPC condition can result in some space being freed up
again as unused reserved metadata space is returned to the free pool
as delalloc occurs during server writeback. This usually takes a
second or two to complete.

As a result, shortly after the first ENOSPC has been reported and
subsequent writes have also ENOSPC, we can have space freed up and
another write will succeed. At that point, the write that succeeds
will be a different offset to the last one that succeeded, leaving a
hole in the file and moving the EOF well past 1.5GB. That will go on
until there really is no space left at all or the NFS client has no
more dirty data to send.

Basically, what you see it not a bug in XFS, it is a result of NFS
clients being able to overcommit server filesystem space and the
interaction that has with the way the filesystem on the NFS server
handles ENOSPC.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
