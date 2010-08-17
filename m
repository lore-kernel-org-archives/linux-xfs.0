Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7H959T4038410 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 04:05:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4BFB1D759D9
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 02:05:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	FCyGbuitpS7qy4Yt for <xfs@oss.sgi.com>;
	Tue, 17 Aug 2010 02:05:37 -0700 (PDT)
Date: Tue, 17 Aug 2010 19:05:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump-3.0.4 problems
Message-ID: <20100817090534.GP10429@dastard>
References: <20100816182236.249a2a0f@x2.grafnetz>
	<20100816223021.GL10429@dastard>
	<20100817083227.06e23889@x2.grafnetz>
	<20100817071337.GN10429@dastard>
	<20100817095340.6b9ab8e2@x2.grafnetz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100817095340.6b9ab8e2@x2.grafnetz>
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
To: Mario Bachmann <mbachman@stud.uni-frankfurt.de>
Cc: xfs@oss.sgi.com

On Tue, Aug 17, 2010 at 09:53:40AM +0200, Mario Bachmann wrote:
> Am Tue, 17 Aug 2010 17:13:37 +1000 > schrieb Dave Chinner <david@fromorbit.com>:
> > > Compiler: I use "gcc (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) 4.4.4". 
> > > 
> > > Testing List (on one machine only):
> > > works:   x86_64, 2.6.34.4, xfsdump-3.0.1
> > > works:   x86_64, 2.6.34.4, xfsdump-3.0.4
> > > failure: x86_64, 2.6.35.2, xfsdump-3.0.1 (worked only one time)
> > > failure: x86_64, 2.6.35.2, xfsdump-3.0.4
> > 
> > Ok, that makes more sense - we changed the way bulkstat works in
> > from 2.6.34 to 2.6.35 to correctly validate inode numbers being
> > passed in via bulkstat, and hence files unlinked during the dump run
> > could return EINVAL when validating the directory structure (as they
> > no longer exist). Is you system completely idle while the dump
> > is running, or are files being removed while the dump is running?
> 
> I would call my system idle, when I use xfsdump. No rm or mv operations 
> are running while the dump. The first machine has a dual core 2.9 GHz and
> 8 GB of RAM and the filesystems are not really big (~10GB used). The second 
> machine has a dual core 2 GHz and 2 GB of RAM. 

Yup, I have reproduced it here. What is strange is that xfs_fsr uses
XFS_IOC_BULKSTAT_SINGLE, and that works fine on 2.6.35.2. The same
ioctl calls from xfsdump are failing, though, so something funny is
going on there.

I'll look into it further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
