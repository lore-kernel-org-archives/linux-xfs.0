Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBBNrcdC061388 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 17:53:38 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C2281B426AD
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 15:53:36 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qBPKhWxa6CcxRxMX for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 15:53:36 -0800 (PST)
Date: Mon, 12 Dec 2011 10:53:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Data corruption, md5 changes on every mount
Message-ID: <20111211235334.GJ14273@dastard>
References: <4EE4AE61.6000306@yahoo.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE4AE61.6000306@yahoo.co.uk>
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
To: Dmitry Panov <dmitry.panov@yahoo.co.uk>
Cc: xfs@oss.sgi.com

On Sun, Dec 11, 2011 at 01:21:37PM +0000, Dmitry Panov wrote:
> Hi guys,
> 
> I have a 2TiB XFS which is about 60% full. Recently I've noticed
> that the daily inc. backup reports file contents change for files
> that are not supposed to change.

What kernel/platform? What version of xfsprogs? What kind of
storage?

> I've created an LVM snapshot and ran xfs_check/xfs_repair. xfs_check
> did report a few problems (unknown node type). After that I ran a
> simple test: mount, calculate md5 of the problematic files, report
> if it changed, umount, sleep 10 sec. That script reported that md5
> sum of at least one file was changing on every cycle.

That sounds like you've got a dodgy drive.

> Analyzing the differences I found that a 4k block that should
> contain all zeros sometimes contains random garbage (luckily most of
> the files are pcm wavs, so it's easy to verify). However I did not
> analyze every occurrence so this may be not 100% true. The files do
> not look as they are sparse according to du. Interestingly one of
> them appears to occupy one block more than necessary.

XFS can allocate blocks beyond EOF - it's completely valid to do so.

> Then I did cp -a file newfile, mv newfile file and re-ran the test.
> No problems reported since.

So the file is now in a different physical location on disk.
Defintely sounds like a dodgy disk to me.

> As there were a few unclean umounts I think most likely it is a
> filesystem corruption that went unspotted by xfs_repair. It would
> not surprise me too much because xfs_repair took just 3.5 min.

The run time of xfs_repair is determined by how much IO it needs to
do to read all the metadata. Your filesystem is not all that densely
populated with metadata, so it doesn't take very long to run. The
short runtime does not mean it hasn't checked you filesystem
properly.

Think about scale or a minute - take your filesystem and scale it
linearly in all dimensions - a repair rate of 1.5m per TB means
2.5hrs for a 100TB filesystem or a day for a PB sized filesystem. The
speed you are seeing doesn't seem quite so fast now, does it?

> Any ideas? I could just copy the files and pretend noting happened
> but is there a guarantee that doing so won't corrupt other data?

I'd start by replacing hardware....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
