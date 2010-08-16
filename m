Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7GMTu0x004933 for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 17:29:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC90512C4F50
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 15:39:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	kzSrm67pGaHZBAYD for <xfs@oss.sgi.com>;
	Mon, 16 Aug 2010 15:39:34 -0700 (PDT)
Date: Tue, 17 Aug 2010 08:30:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump-3.0.4 problems
Message-ID: <20100816223021.GL10429@dastard>
References: <20100816182236.249a2a0f@x2.grafnetz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100816182236.249a2a0f@x2.grafnetz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mario Bachmann <mbachman@stud.uni-frankfurt.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 16, 2010 at 06:22:36PM +0200, Mario Bachmann wrote:
> Hello, =

> =

> my kernel is
> Linux x2 2.6.35.2 #1 SMP Sun Aug 15 00:32:14 CEST 2010 x86_64 AMD Athlon(=
tm) 64 X2 Dual Core Processor 5600+ AuthenticAMD GNU/Linux
> =

> I get a lot of Warnings with xfsdump-3.0.4 (booth, gentoo package 3.0.4-r=
1 and git-version):
> =

> x2 ~/source/d/xfsdump/dump # ./xfsdump -l0 -L "Test" - /dev/sda2 |gzip - =
> /mnt/data2/dump_text.gz
.....
> ./xfsdump: WARNING: could not stat dirent .crack-attack ino 100663674: Da=
s Argument ist ung=FCltig: using null generation count in directory entry

bulkstat is failing, indicating an invalid option was passed.

> With the "old" version xfsdump-3.0.1, I get no warnings!
> xfsdump -l0 -L "Test" - /dev/sda2 |gzip - > /mnt/data2/dump301_test.gz
> xfsdump: using file dump (drive_simple) strategy
> xfsdump: version 3.0.1 (dump format 3.0) - Running single-threaded
....
> xfsdump: Dump Status: SUCCESS
> =

> And the file is 4,8 GB. All seems to be correct!

I can't see any changes between 3.0.1 and 3.0.4 that would explain
this. Did you run them on the same machine and kernel? Did you build
them with the same compiler? If everything is the same, then perhaps
you could bisect (only a few changes so should be quick) to point
out the offending change.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
