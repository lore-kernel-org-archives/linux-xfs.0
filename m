Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7HFlGwA055854 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 10:47:16 -0500
Received: from mailout.rz.uni-frankfurt.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B774CCEB27
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 08:56:58 -0700 (PDT)
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de
	[141.2.22.233]) by cuda.sgi.com with ESMTP id fJAj3wqL6ycaP1Ej
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 08:56:58 -0700 (PDT)
Date: Tue, 17 Aug 2010 17:47:31 +0200
From: Mario Bachmann <mbachman@stud.uni-frankfurt.de>
Subject: Re: [PATCH] Re: xfsdump-3.0.4 problems
Message-ID: <20100817174731.0061f5ec@x2.grafnetz>
In-Reply-To: <20100817114550.GQ10429@dastard>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
	<20100817095340.6b9ab8e2@x2.grafnetz>
	<20100817090534.GP10429@dastard> <20100817114550.GQ10429@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Am Tue, 17 Aug 2010 21:45:50 +1000
schrieb Dave Chinner <david@fromorbit.com>:

> On Tue, Aug 17, 2010 at 07:05:34PM +1000, Dave Chinner wrote:
> > On Tue, Aug 17, 2010 at 09:53:40AM +0200, Mario Bachmann wrote:
> > > Am Tue, 17 Aug 2010 17:13:37 +1000 > schrieb Dave Chinner <david@fromorbit.com>:
> > > > > Compiler: I use "gcc (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) 4.4.4". 
> > > > > 
> > > > > Testing List (on one machine only):
> > > > > works:   x86_64, 2.6.34.4, xfsdump-3.0.1
> > > > > works:   x86_64, 2.6.34.4, xfsdump-3.0.4
> > > > > failure: x86_64, 2.6.35.2, xfsdump-3.0.1 (worked only one time)
> > > > > failure: x86_64, 2.6.35.2, xfsdump-3.0.4
> > > > 
> > > > Ok, that makes more sense - we changed the way bulkstat works in
> > > > from 2.6.34 to 2.6.35 to correctly validate inode numbers being
> > > > passed in via bulkstat, and hence files unlinked during the dump run
> > > > could return EINVAL when validating the directory structure (as they
> > > > no longer exist). Is you system completely idle while the dump
> > > > is running, or are files being removed while the dump is running?
> > > 
> > > I would call my system idle, when I use xfsdump. No rm or mv operations 
> > > are running while the dump. The first machine has a dual core 2.9 GHz and
> > > 8 GB of RAM and the filesystems are not really big (~10GB used). The second 
> > > machine has a dual core 2 GHz and 2 GB of RAM. 
> > 
> > Yup, I have reproduced it here. What is strange is that xfs_fsr uses
> > XFS_IOC_BULKSTAT_SINGLE, and that works fine on 2.6.35.2. The same
> > ioctl calls from xfsdump are failing, though, so something funny is
> > going on there.
> > 
> > I'll look into it further.
> 
> Ok, there is nothing wrong with the changes to the bulkstat code;
> when all the inodes in the filesystem are hot in the inode cache
> xfsdump succeeds.
> 
> When I run xfs_fsr per file to exercise the XFS_IOC_BULKSTAT_SINGLE
> path like so:
> 
> $ sudo find /mnt/test -type f -exec xfs_fsr -d -v {} \;
> 
> It succeeds without any bulkstat failures. A subsequent xfsdump
> invocation then succeeds without failure, either. Clearly the find
> is populating the inode cache for the subsequent bulkstat calls,
> 
> Ok, so the reason this wasn't picked up is that xfs_fsr silently
> ignores inodes that it gets an error from bulkstat on.
> 
> and it looks like
> Dropping caches then running xfsdump:
> 
> $ sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
> $ sudo xfsdump -l0 -L "Test" - /dev/vda 2> t.t |gzip - > ~/dump_test.gz
> 
> Results in failures.
> 
> /me sighs
> 
> My fault. I screwed up the btree lookup for the inode validation.
> Can you test the patch below?
> 
> Cheers,
> 
> Dave

Your patch works here with 2.6.35.2. 
:-)

Mario

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
