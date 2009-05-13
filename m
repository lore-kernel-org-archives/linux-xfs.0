Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4D58qtY117602 for <xfs@oss.sgi.com>; Wed, 13 May 2009 00:08:52 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D831C1D2C3DE
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 22:08:50 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 5617PpTVrA51AIXD for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 22:08:50 -0700 (PDT)
Message-ID: <4A0A55E0.4010202@sandeen.net>
Date: Wed, 13 May 2009 00:08:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: file preallocation without unwritten flag being set
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
	<618437.93111.qm@web65601.mail.ac4.yahoo.com>
In-Reply-To: <618437.93111.qm@web65601.mail.ac4.yahoo.com>
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
To: p v <pvlogin@yahoo.com>
Cc: xfs@oss.sgi.com

p v wrote:
> 
> 
> I want to avoid any metadata modifications while doing O_DIRECT reads
> (the fs is mounted with noatime). Right now I am doing it mostly for
> testing - I am seeing a performance degradation going from raw to xfs
> on a 10TB filesystem - probably due to my application but I am trying
> to narrow it down so I am starting with running randomio benchmark on
> raw - then 10TB file, then 10 1TB files, then 100 100GB files, ...

you may want to try the inode64 mount option so the allocator is free to
roam your whole 10T ...

> But in general certain applications can definitely take care of the
> preallocated space (db, FB haystack, ...). 

Ok, so it sounds like you do understand the implications and you want to
be able to write into prealloc space without any metadata updates as
they are converted to initialized extents... :)

> What they require is
> minimal fragmentation so they would prefer to preallocate the space
> (fill the whole fs with contigous files) and then maintain in-files
> app specific metadata (such as valid offsets of initialized data,
> ...). What I would really like is to have vxfs equivalent of setext
> options -
> 
> setext -r <reservation> -f chggsize
> 
> And on top of that I would really love to have is vxfs equivalent of
> "nomtime" mount option. Then with O_DIRECT I have raw-like
> performance.
> 
> With the unwritten mkfs option I could get the setext semantics. So
> what's the trick (before I dive into the xfs layout)? I am guessing
> that there is no equivalent for nomtime option?

well, the unwritten=0 option did get removed:
http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git;a=commitdiff;h=8d537733f52a642d471f6781f32f306241dd4308

TBH I'm not entirely sure why.

The unwritten flag is per-filesystem not per-file; you can still clear
that feature bit:

#define XFS_SB_VERSION_EXTFLGBIT 0x1000

by using xfs_db in -x expert mode to rewrite every superblock's
"versionnum" without that bit set.

The xfs_db "version" command will give you a more textual representation
of what is actually set before & after.

You could script the sb rewrites...

For what it's worth, your xfs_db tricks below to preallocate seem a bit
... tricky.

This should suffice:

xfs_io -f /hay/foo
xfs_io> resvsp 0 1024g
xfs_io> truncate 1024g
xfs_io> quit

Oh and you're right, there's no "nomtime" option AFAIK.

-Eric

> Thanks
> 
> Peter Vajgel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
