Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5EF8mXU045862 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 10:08:49 -0500
Received: from out1.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 678FA14A22AB
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 08:14:51 -0700 (PDT)
Received: from out1.smtp.messagingengine.com (out1.smtp.messagingengine.com
	[66.111.4.25]) by cuda.sgi.com with ESMTP id 19g9q4BZkhQU8dHI
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 08:14:51 -0700 (PDT)
Date: Mon, 14 Jun 2010 10:11:06 -0500
From: Roman Kononov <roman@binarylife.net>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100614101106.6d883a2e@abend.internal.xtremedata.com>
In-Reply-To: <AANLkTilqrYxnRzB3FNNE3k3hX2Sp1U63gyTo3T4CIzWV@mail.gmail.com>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
	<AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
	<20100613224752.GA2069@dastard>
	<AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
	<20100614012933.GB6590@dastard>
	<AANLkTilqrYxnRzB3FNNE3k3hX2Sp1U63gyTo3T4CIzWV@mail.gmail.com>
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
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

2010-06-13 23:27 CDT, Ilia Mirkin <imirkin@alum.mit.edu> said:
>Instead it will be "mysql works fine on ext3, but with xfs it spams
>the logs with warnings, therefore xfs must be broken". I don't think
>there's anything realistically that you can do about uninformed users
>and FUD. Although I wasn't suggesting to get rid of the warning,
>rather to make it more explicit as to what it's warning about. I
>interpret a WARN as a BUG that can be recovered but where the
>underlying system needs a careful look; my first inclination after
>seeing a fs-related WARN would be to take the system down and run an
>fsck. What's happening here seems more akin to getting a WARN when
>calling an ioctl with invalid parameters.

I agree. My reaction to this WARN was horrible: I brought the system
down, started fsck-ing and re-installing older kernels, with all kinds
of FUD, which took me considerable time. The message was not well
explained on the Internet, nor was it clear reading the source code.
After talking to the mailing list and investigation of my S/W, I've
realized that the system works fine, and the warning now sounds to me
as useless and unwanted noise of quite high volume.

I am suggesting to issue a notice once per filesytem/mount without
taint. The notice could be as such:

"WARNING: Userspace issues direct IO which races with buffered or mmap
IO on the same file (inode <number>, device <name>). File data
corruption is possible. This message is issued only once per mount".

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
