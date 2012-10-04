Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94G5QOB166487 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 11:05:26 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id f1vDt9aeo6fhcMVD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 09:06:52 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q94G6nGe027218 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 09:06:51 -0700
Message-ID: <506DB419.2030902@tlinx.org>
Date: Thu, 04 Oct 2012 09:06:49 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: how to replay log of a fs that has no log: is this supposed to
	work? SW Defect?
References: <506DAF66.2030507@tlinx.org>
In-Reply-To: <506DAF66.2030507@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>



Linda Walsh wrote:
(blah blah blah)...

or more specifically:

xfs_freeze -f /home/.snapdir/\@GMT-2012.10.04-03.06.17
Ishtar:/# xfs_ncheck /dev/Home+Space/Home-2012.10.04-03.06.17  

    ERROR: The filesystem has valuable metadata changes in a log which needs to
    be replayed.  Mount the filesystem to replay the log, and unmount it before
    re-running xfs_ncheck.  If you are unable to mount the filesystem, then use
    the xfs_repair -L option to destroy the log and attempt a repair.
    Note that destroying the log may cause corruption -- please attempt a mount
    of the filesystem before doing this.
    must run blockget -n first

ok -- lets mount/umount it:
Ishtar:/# mount -o ro,nouuid /dev/Home+Space/Home-2012.10.04-03.06.17 
/home/.snapdir/@GMT-2012.10.04-03.06.17
Ishtar:/# umount /home/.snapdir/@GMT-2012.10.04-03.06.17
Ishtar:/# xfs_ncheck /dev/Home+Space/Home-2012.10.04-03.06.17  

    ERROR: The filesystem has valuable metadata changes in a log which needs to
    be replayed.  Mount the filesystem to replay the log, and unmount it before
    re-running xfs_ncheck.  If you are unable to mount the filesystem, then use
    the xfs_repair -L option to destroy the log and attempt a repair.
    Note that destroying the log may cause corruption -- please attempt a mount
    of the filesystem before doing this.
    must run blockget -n first

---
Um... looking at the above it would appear that I froze a fs.
ncheck claimed the freeze didn't result in the logfile being written being put
into a consistent state, but said to remount the fs to allow it to play then
umount...

So... did that.
Log file is still in a corrupt state.

Am I wrong in assuming that doing xfs_repair -L to destroy the log on this
dev, might be a bad thing to do and might screw up it's "Origin" file
system (i.e. the current 'live' /home partition)?


  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
