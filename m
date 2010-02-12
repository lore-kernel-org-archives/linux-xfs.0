Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CHhNv1009934 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:43:24 -0600
Received: from vms173013pub.verizon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 123CA13A398A
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:44:36 -0800 (PST)
Received: from vms173013pub.verizon.net (vms173013pub.verizon.net
	[206.46.173.13]) by cuda.sgi.com with ESMTP id EYy53tFiYVt9pElD
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:44:36 -0800 (PST)
Received: from [192.168.10.2] ([unknown] [98.114.168.230])
	by vms173013.mailsrvcs.net
	(Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16
	2009)) with ESMTPA id <0KXQ00KZ0PAZRJF2@vms173013.mailsrvcs.net> for
	xfs@oss.sgi.com; Fri, 12 Feb 2010 11:44:59 -0600 (CST)
Subject: xfs_repair doesn't fix sb versionnum missing attr
From: C Linus Hicks <linush@verizon.net>
Date: Fri, 12 Feb 2010 12:44:34 -0500
Message-id: <1265996674.7755.7.camel@lh10.linush.net>
MIME-version: 1.0
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

I run:

xfs_check /dev/sdc10

And it reports:

sb versionnum missing attr bit 10

Then I run:

xfs_repair /dev/sdc10

And it reports output from 7 phases and "done".

Again I run:

xfs_check /dev/sdc10

And it reports:

sb versionnum missing attr bit 10

Is this how it's supposed to work?
Thanks for any help.
Linus


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
