Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o65IYTDg134064 for <xfs@oss.sgi.com>; Mon, 5 Jul 2010 13:34:30 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D43C315920DD
	for <xfs@oss.sgi.com>; Mon,  5 Jul 2010 11:37:18 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id ctGYxweOxQz4brzn
	for <xfs@oss.sgi.com>; Mon, 05 Jul 2010 11:37:18 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <19506.8873.902105.181763@tree.ty.sabi.co.uk>
Date: Mon, 5 Jul 2010 19:21:29 +0100
Subject: Re: Slow delete
In-Reply-To: <AANLkTim5GfiDw63CwrE1QMwQACpWd2OgDgEW8y8bpcSW@mail.gmail.com>
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
	<20100705171338.3bb38e1d@harpe.intellique.com>
	<AANLkTim5GfiDw63CwrE1QMwQACpWd2OgDgEW8y8bpcSW@mail.gmail.com>
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
To: Andrei Deftu <andreideftu@gmail.com>
Cc: xfs@oss.sgi.com

>>> [ ... ] xfs is very slow when deleting a large number of
>>> files. [ ... ]

Not quite -- it is nearly as fast as possible.

> Thanks. Yes, I know about these tricks like 'nobarrier'
> option, separate partition for metadata log, increased size
> for the log, more log buffers or atime disabled. But I was
> interested more in what is the real cause of this slowness.

Tricks like those indicate quite clearly the real cause.

To make it even more explicit, the real cause is that those who
complain tha XFS is slow at deleting lots of files have a storage
subsystem can only do a limited number of committed transactions
per second and XFS does not "cheat".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
