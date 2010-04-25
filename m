Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PBFXSX259105 for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 06:15:34 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A3B62EE51A
	for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 04:17:34 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id G8L7sdBSXMxULxec
	for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 04:17:34 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1O5zq5-0004Hq-7T
	for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 12:17:29 +0100
MIME-Version: 1.0
Message-ID: <19412.9412.177637.116303@tree.ty.sabi.co.uk>
Date: Sun, 25 Apr 2010 12:17:24 +0100
Subject: Re: xfs_fsr question for improvement
In-Reply-To: <20100417091357.4e7ad1e0@galadriel.home>
References: <201004161043.11243@zmi.at> <20100417012415.GE2493@dastard>
	<20100417091357.4e7ad1e0@galadriel.home>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

>> XFS resists fragmentation better than most other filesystems,
>> so defragmentation, while possible, is generally not needed.

That's a common myth. For most file systems and filesystems.
Also most applications write files really badly.

  http://www.sabi.co.uk/blog/anno06-3rd.html#060914b

> There two systems nevertheless where I need to use xfs_fsr
> regularly to keep decent performance :

Fortunately 'xfs_fsr' is mostly reliable, but in-place
defragmentation is a risky propostion for several reasons even
if 'xfs_fsr' is fairly reliable.

Note also that 'xfs_fsr' uses a terrible "defragmentation"
strategy (from 'man xfs_fsr'):

  "The reorganization algorithm operates on one file at a time,"

  "xfs_fsr improves the layout of extents for each file by
  copying the entire file to a temporary location and then
  interchanging the data extents of the target and temporary
  files in an atomic manner."

> my test VMware server (performance dropped down to abysmal
> level until I set up a daily xfs_fsr cron job),

That should not be the case unless you are using very sparse
VM image files, in which case you get what you pay for.

> and a write-intensive video server.

That also should not be the case unless your applications write
strategy is wrong and you get extremely interleaved streams, in
which case you get what you paid for the application programmer.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
