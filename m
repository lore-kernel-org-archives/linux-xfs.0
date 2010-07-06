Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o66NGAkU207356 for <xfs@oss.sgi.com>; Tue, 6 Jul 2010 18:16:11 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6D4515B7461
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 16:24:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	P61dSCkZRVp0h9Or for <xfs@oss.sgi.com>;
	Tue, 06 Jul 2010 16:24:29 -0700 (PDT)
Date: Wed, 7 Jul 2010 09:18:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: CentOS 5.5 XFS internal errors (XFS_WANT_CORRUPTED_GOTO)
Message-ID: <20100706231856.GC25018@dastard>
References: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
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
To: Shaun Adolphson <shaun@adolphson.net>
Cc: xfs@oss.sgi.com

On Tue, Jul 06, 2010 at 08:57:45PM +1000, Shaun Adolphson wrote:
> Hi,
> 
> We have been able to repeatably produce xfs internal errors
> (XFS_WANT_CORRUPTED_GOTO) on one of our fileservers. We are attempting
> to locally copy a 248Gig file off a usb drive formated as NTFS to the
> xfs drive. The copy gets about 96% of the way through and we get the
> following messages:
> 
> Jun 28 22:14:46 terrorserver kernel: XFS internal error
> XFS_WANT_CORRUPTED_GOTO at line 2092 of file fs/xfs/xfs_bmap_btree.c.
> Caller 0xffffffff8837446f

Interesting. That's a corrupted inode extent btree - I haven't seen
one of them for a long while. Were there any errors (like IO errors)
reported before this?

However, the first step is to determine if the error is on disk or an
in-memory error. Can you post output of:

	- xfs_info <mntpt>
	- xfs_repair -n after a shutdown

Can you upgrade xfsprogs (i.e. xfs_repair) to the latest version
(3.1.2) before you do this as well?

> We have reproduced the condition 3 times and each time we have been
> able to remount the drive ( to replay the transaction log ) and then
> preform and xfs_repair.
> 
> We are just using cp to copy the file.
> 
> Some further details about the system:
> 
> Software:
> - Fresh install of CentOS 5.5 64bit all patches up to date
> - Kernel 2.6.18-194.3.1.el5.centos.plus

I've got no idea exactly what version of XFS that has in it, so I
can't say off the top of my head whether this is a fixed bug or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
