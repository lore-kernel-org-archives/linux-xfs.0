Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0N4VLjA052559 for <xfs@oss.sgi.com>; Sun, 22 Jan 2012 22:31:21 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lQHdYuEjF8MuTDav for <xfs@oss.sgi.com>;
	Sun, 22 Jan 2012 20:31:19 -0800 (PST)
Date: Mon, 23 Jan 2012 15:31:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of
	512 bytes
Message-ID: <20120123043117.GH15102@dastard>
References: <CALx8gnT9tdPRGfVR0puoSVYz_MDDs4FtWtodST5x29GDnL3A_w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALx8gnT9tdPRGfVR0puoSVYz_MDDs4FtWtodST5x29GDnL3A_w@mail.gmail.com>
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
To: Christian Kildau <lists@unixhosts.org>
Cc: xfs@oss.sgi.com

On Sat, Jan 21, 2012 at 11:29:15AM +0100, Christian Kildau wrote:
> Sorry if this message appears twice!
> 
> 
> 
> Hello,
> 
> I'm having some very serious issues with XFS after upgrading from a
> Linux Distro running Ubuntu 2.6.32 to 3.2.
> 
> It seems like my filesystems are damaged after attaching them to a
> Linux 3.2 server. I am also no longer able to mount the hdd on the old
> server that is still running 2.6.32!

I take it that you are using external storage of some kind? Can you
describe it?

> (I created the xfs filesystem on the entire hdd, not on a partition,
> so /dev/sdd is not a typo)
> 
> $ sudo mount -t xfs /dev/sdd /media/
> mount: /dev/sdd: can't read superblock
> (dmesg)
> [236659.912663] attempt to access beyond end of device
> [236659.912667] sdd: rw=32, want=2930277168, limit=2930275055
> [236659.912670] XFS (sdd): last sector read failed

So XFS has asked to read 2113 sectors beyond the size of the device
that the kernel is reporting. What is the output of
/proc/partitions?

> $ sudo xfs_check /dev/sdd
> xfs_check: error - read only 0 of 512 bytes
> 
> $ sudo xfs_repair /dev/sdd
> Phase 1 - find and verify superblock...
> xfs_repair: error - read only 0 of 512 bytes

So both buffered and direct IO to the first block in the block
device are failing. I'd say your problems have nothing to do with
XFS. However, can you strace them and find out what the error that
is occuring actually is?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
