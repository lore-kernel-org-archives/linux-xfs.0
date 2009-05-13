Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4D4Yr2r113709 for <xfs@oss.sgi.com>; Tue, 12 May 2009 23:34:53 -0500
Received: from web65601.mail.ac4.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D71642803A2
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 21:34:59 -0700 (PDT)
Received: from web65601.mail.ac4.yahoo.com (web65601.mail.ac4.yahoo.com
	[76.13.9.69]) by cuda.sgi.com with SMTP id tIER1aqZuc9FADa5 for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 21:34:59 -0700 (PDT)
Message-ID: <618437.93111.qm@web65601.mail.ac4.yahoo.com>
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
Date: Tue, 12 May 2009 21:34:57 -0700 (PDT)
From: p v <pvlogin@yahoo.com>
Subject: Re: file preallocation without unwritten flag being set
In-Reply-To: <4A0A0E76.6000701@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com




I want to avoid any metadata modifications while doing O_DIRECT reads (the fs is mounted with noatime). Right now I am doing it mostly for testing - I am seeing a performance degradation going from raw to xfs on a 10TB filesystem - probably due to my application but I am trying to narrow it down so I am starting with running randomio benchmark on raw - then 10TB file, then 10 1TB files, then 100 100GB files, ...

But in general certain applications can definitely take care of the preallocated space (db, FB haystack, ...). What they require is minimal fragmentation so they would prefer to preallocate the space (fill the whole fs with contigous files) and then maintain in-files app specific metadata (such as valid offsets of initialized data, ...). What I would really like is to have vxfs equivalent of setext options -

setext -r <reservation> -f chggsize

And on top of that I would really love to have is vxfs equivalent of "nomtime" mount option. Then with O_DIRECT I have raw-like performance.

With the unwritten mkfs option I could get the setext semantics. So what's the trick (before I dive into the xfs layout)? I am guessing that there is no equivalent for nomtime option?

Thanks

Peter Vajgel





----- Original Message ----
From: Eric Sandeen <sandeen@sandeen.net>
To: p v <pvlogin@yahoo.com>
Cc: xfs@oss.sgi.com
Sent: Tuesday, May 12, 2009 5:04:06 PM
Subject: Re: file preallocation without unwritten flag being set

p v wrote:
> 
> Hello,
> 
> I need to create large files fast without initializing them - in the
> past I used these steps -
> 
> mkfs -t xfs -f -d unwritten=0 /dev/sda1 mount -t xfs -o noatime
> /dev/sda1 /hay touch /hay/foo xfs_io /hay/foo xfs_io> resvsp 0 1024g 
> xfs_io> quit ls -i /hay/foo 131 /hay/foo umount /hay xfs_db -x
> /dev/sda1 xfs_db> inode 131 xfs_db> write core.size 1099511627776 
> core.size = 1099511627776 xfs_db> q

Is there a reason that you don't want the unwritten flag set?  (You know
that not using the unwritten extents feature exposes garbage from the
disk in this case?)

There may well be a legit reason but I just want to make sure you're
doing what you think you're doing :)

Thanks,
-Eric

> But unwritten=0 is failing as unrecognized option now (was it
> deprecated????) so I tried to clear the unwritten extent flag
> directly -
> 
> xfs_db> a u.bmbt.ptrs[1] xfs_db> write recs[1].extentflag 0 
> recs[1].extentflag = 1 xfs_db>
> 
> It just won't change to 0 - any way to do this? Or is there any
> straightforward way to preallocate a large file and set it's file
> size without the unwritten flags being turned on?
> 
> Thanks
> 
> Peter Vajgel
> 
> 
> 
> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 


      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
