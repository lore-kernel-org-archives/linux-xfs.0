Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6CIpiE6258705 for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 13:51:44 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEE15A32088
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 11:59:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id sjaLx42VNqk9VQtZ for
	<xfs@oss.sgi.com>; Sun, 12 Jul 2009 11:59:42 -0700 (PDT)
Message-ID: <4A5A30E4.6090309@sandeen.net>
Date: Sun, 12 Jul 2009 13:52:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: bad fs - xfs_repair 3.01 crashes on it
References: <200907031320.48358@zmi.at>
In-Reply-To: <200907031320.48358@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs mailing list <xfs@oss.sgi.com>

Michael Monnerie wrote:
> Tonight our server rebooted, and I found in /var/log/warn that he was crying 
> a lot about xfs since June 7 already:
> 
> Jun  7 03:06:31 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt inode 3857051697 ((a)extents = 5).  Unmount and run xfs_repair.
> Jun  7 03:06:31 orion.i.zmi.at kernel: Pid: 23230, comm: xfs_fsr Tainted: G          2.6.27.21-0.1-xen #1
> Jun  7 03:06:31 orion.i.zmi.at kernel:

Hm, the other sort of interesting thing here is that a recently-reported
RH bug:

[Bug 510823] "Structure needs cleaning" when reading files from an XFS
partition (extent count for ino XYZ data fork too low (6) for file format)

also seems to -possibly- be related to an xfs_fsr run, and also is
related to extents in the wrong format.  In that case it was the
opposite; an inode was found in btree format which had few enough
extents that it should have been in the extents format in the inode; in
your case, it looks like there were too many extents to fit in the
format it had...

Just out of curiosity, it looks like you have rather a lot of extended
attributes on at least the inode above, is that accurate?  Or maybe
that's part of the corruption?

I'll focus on getting xfs_repair to cope first, but I wonder what
happened here...

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
