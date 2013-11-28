Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65D2D7F54
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:01:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35C2D304051
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:01:14 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TP7DqZSdIaojZ5XH for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 02:01:12 -0800 (PST)
Date: Thu, 28 Nov 2013 21:01:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131128100107.GN10988@dastard>
References: <20131127023119.GB13101@boogeyman> <20131127024713.GE10988@dastard>
	<5296ACFB.4030901@sandeen.net> <20131128051626.GM10988@dastard>
	<5296D5EB.2080008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5296D5EB.2080008@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Phil White <cerise-xfs@l.armory.com>, xfs@oss.sgi.com

On Wed, Nov 27, 2013 at 11:34:35PM -0600, Eric Sandeen wrote:
> On 11/27/13, 11:16 PM, Dave Chinner wrote:
> > So, it failed to write using direct IO because of IO alignment
> > because I didn't tell mkfs that it was running on a file. i.e. I
> > forgot the "-d file" option.
> > 
> > $ sudo mkfs.xfs -d size=1g,name=/storage/fubar.img
> > meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=0
> > data     =                       bsize=4096   blocks=262144, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal log           bsize=4096   blocks=7344, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > mkfs.xfs: pwrite64 failed: Invalid argument
> > mkfs.xfs: read failed: Invalid argument
> > 
> > Yup, still fails. Let's force it!
> > 
> > $ sudo mkfs.xfs -f -d size=1g,name=/storage/fubar.img
> > meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=0
> > data     =                       bsize=4096   blocks=262144, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal log           bsize=4096   blocks=7344, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > existing superblock read failed: Invalid argument
> > mkfs.xfs: pwrite64 failed: Invalid argument
> > mkfs.xfs: read failed: Invalid argument
> > 
> > And there's the identical failure to what was reported.
> > 
> > So, user error - the user is telling mkfs.xfs that it is making a
> > filesystem on a block device named "/storage/fubar.img".  The same
> > thing happens with the normal method of specifying the block device:
> 
> If only we had some way to tell, programatically, whether the mkfs target
> was a regular file or a block device, eh? ;)
> 
> Seriously, I always thought the requirment to specify "-d file" was silly.
> And now I think it's even more silly, if it actually is required for
> proper behavior...

It has always been required if you want mkfs to create the file for
you. And given that doing stuff like ioctl(BLKDISCARD) on files is
completely wrong, so I think it really is needed...

> > What mkfs needs to do is reject devices that are files when "-d
> > file", "-l file" and "-r file" is not specified, and the problem
> > will go away because it will catch users who forget to tell mkfs
> > that it is supposed to be operating on an image file...
> 
> Or maybe just stat() it, and DTRT?

Well, we need to stat it to make sure that it's a file if "-d file"
is specified, and a block device if it's not. That will prevent this
problem.  Every other xfsprogs utility has to be told that it is
being pointed at an image file rather than a block device, so why
should mkfs be any different?

Indeed, if we don't require users to tell mkfs that it's a file,
what do we do with non-existent  device names when they are provided
by the user? Just create the file rather than returning ENOENT? So
suddenly /dev/ fills up with fileystem images because of typos?

Principle of Least Surprise says that ENOENT is the correct
behaviour, hence it follows that "-d file" is needed and should be
properly checked and enforced. I'll add this to the start of the
patch set I'm currently working on that fixes all of the mkfs input
parameter validation problems I've found over the past couple of
weeks...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
