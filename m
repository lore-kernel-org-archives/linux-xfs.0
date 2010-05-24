Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OJWVHw198141 for <xfs@oss.sgi.com>; Mon, 24 May 2010 14:32:32 -0500
Received: from out1.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29AF91DF9768
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 12:34:52 -0700 (PDT)
Received: from out1.smtp.messagingengine.com (out1.smtp.messagingengine.com
	[66.111.4.25]) by cuda.sgi.com with ESMTP id 99CVr3pPA1EV3J1v
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 12:34:52 -0700 (PDT)
Date: Mon, 24 May 2010 14:34:28 -0500
From: Roman Kononov <roman@binarylife.net>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100524143428.6f3a117c@abend.internal.xtremedata.com>
In-Reply-To: <4BF9FCA8.8090906@hardwarefreak.com>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<4BF9FCA8.8090906@hardwarefreak.com>
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
To: xfs@oss.sgi.com

On Sun, 23 May 2010 23:12:24 -0500 Stan Hoeppner
<stan@hardwarefreak.com> wrote:
> "The whole notion of "direct IO" is totally braindamaged. Just say no.
...
> From:  http://lkml.org/lkml/2007/1/10/235

I definitely measure dramatic overall performance benefit using
O_DIRECT carefully.

In that thread, it is doubtful that madvise+mmap+msync allow
asynchronous zero-copy reads and writes to/from already pinned by a
device driver memory of data produced/consumed by that device, without
cache pollution and with intelligent handling of disk errors. Am I
wrong?

Thanks,

Roman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
