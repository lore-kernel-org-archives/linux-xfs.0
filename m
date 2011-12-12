Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC4F76o069160 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 22:15:07 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB38E2B40F8
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 20:15:04 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IutwW8LQqyLPj5mL for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 20:15:04 -0800 (PST)
Date: Mon, 12 Dec 2011 15:15:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Data corruption, md5 changes on every mount
Message-ID: <20111212041502.GN14273@dastard>
References: <4EE4AE61.6000306@yahoo.co.uk> <20111211235334.GJ14273@dastard>
	<4EE54734.8050603@yahoo.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE54734.8050603@yahoo.co.uk>
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

On Mon, Dec 12, 2011 at 12:13:40AM +0000, Dmitry Panov wrote:
> Hi Dave,
> 
> On 11/12/2011 23:53, Dave Chinner wrote:
> >On Sun, Dec 11, 2011 at 01:21:37PM +0000, Dmitry Panov wrote:
> >>Hi guys,
> >>
> >>I have a 2TiB XFS which is about 60% full. Recently I've noticed
> >>that the daily inc. backup reports file contents change for files
> >>that are not supposed to change.
> >What kernel/platform? What version of xfsprogs? What kind of
> >storage?
> It's linux kernel 3.0.0 at the moment, however it used to run
> different versions and I can't tell for sure when the problem
> started. xfsprogs version is 3.1.2.
> 
> The storage is a 2 node cluster with hardware RAID1+0 and drbd.

Hmmmm. HA, remote replication, network paths in the storage stack.
Not a particularly common setup, so I'd be looking at validating
your drbd setup before looking at XFS.....

> >>I've created an LVM snapshot and ran xfs_check/xfs_repair. xfs_check
> >>did report a few problems (unknown node type). After that I ran a
> >>simple test: mount, calculate md5 of the problematic files, report
> >>if it changed, umount, sleep 10 sec. That script reported that md5
> >>sum of at least one file was changing on every cycle.
> >That sounds like you've got a dodgy drive.
> 
> That would be my guess too, however the problem occurs on both nodes
> (i.e. it doesn't go away when the other node becomes active) and the
> same files affected which makes hard drives or RAID controller or
> RAM failure very unlikely.

Which simply means the corruption has been replicated.

Given that drbd is in the picture and that has a history of causing
filesystem and/or data corruptions, I'd suggest you validate that
drbd is not causing problems first. If you can reproduce the data
corruption on a storage stack that doesn't have drbd in it, then
it's probably a filesystem problem.  However, you need to rule out
the lower storage layers as the cause first.  i.e. once you've
validated that your block device is good, then we can start to look
at whether the filesystem is the cause.

In general, you need a reliable reproducer to do this, so if you can
reproduce the problem anymore, there's little that can be done about
it...

> Is there any way to perform a more thorough check, than xfs_check does?

xfs_repair -n is more thorough than xfs_check. But remember, both
xfs_check and xfs_repair are only chekcing the filesystem structure,
not the contents of your files. The contents of your files are yours
to check....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
