Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 00FC87F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 23:34:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E360A8F8068
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 21:34:38 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ghx1rxowhRmxkCDL for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 21:34:37 -0800 (PST)
Message-ID: <5296D5EB.2080008@sandeen.net>
Date: Wed, 27 Nov 2013 23:34:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problem with mkfs.xfs on a regular file
References: <20131127023119.GB13101@boogeyman>
	<20131127024713.GE10988@dastard> <5296ACFB.4030901@sandeen.net>
	<20131128051626.GM10988@dastard>
In-Reply-To: <20131128051626.GM10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Phil White <cerise-xfs@l.armory.com>, xfs@oss.sgi.com

On 11/27/13, 11:16 PM, Dave Chinner wrote:

<snip>

> So, it failed to write using direct IO because of IO alignment
> because I didn't tell mkfs that it was running on a file. i.e. I
> forgot the "-d file" option.
> 
> $ sudo mkfs.xfs -d size=1g,name=/storage/fubar.img
> meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=7344, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> mkfs.xfs: pwrite64 failed: Invalid argument
> mkfs.xfs: read failed: Invalid argument
> 
> Yup, still fails. Let's force it!
> 
> $ sudo mkfs.xfs -f -d size=1g,name=/storage/fubar.img
> meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=7344, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> existing superblock read failed: Invalid argument
> mkfs.xfs: pwrite64 failed: Invalid argument
> mkfs.xfs: read failed: Invalid argument
> 
> And there's the identical failure to what was reported.
> 
> So, user error - the user is telling mkfs.xfs that it is making a
> filesystem on a block device named "/storage/fubar.img".  The same
> thing happens with the normal method of specifying the block device:

If only we had some way to tell, programatically, whether the mkfs target
was a regular file or a block device, eh? ;)

Seriously, I always thought the requirment to specify "-d file" was silly.
And now I think it's even more silly, if it actually is required for
proper behavior...

> What mkfs needs to do is reject devices that are files when "-d
> file", "-l file" and "-r file" is not specified, and the problem
> will go away because it will catch users who forget to tell mkfs
> that it is supposed to be operating on an image file...

Or maybe just stat() it, and DTRT?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
