Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7CMAGkk254317 for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 17:10:17 -0500
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FC3B14CDC41
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 15:19:30 -0700 (PDT)
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) by cuda.sgi.com
	with ESMTP id OJAvY0iEXroFrJKS for <xfs@oss.sgi.com>;
	Thu, 12 Aug 2010 15:19:30 -0700 (PDT)
Message-ID: <4C64715F.8060000@msgid.tls.msk.ru>
Date: Fri, 13 Aug 2010 02:10:39 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Alignment size?
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

Hello.

I used XFS for a long time on many different
servers, and it works well.  But now I encountered
an.. unexpected problem.

The question is: on one of our servers, XFS requires
different alignment size for O_DIRECT operations than
on others.  Usually it's 512 bytes, but on this server
it is 4096 - both min_io and alignment (this is from
XFS_IOC_DIOINFO ioctl).

I'm not sure what the reason for this is.
On this server, the underlying block device is raid5
(linux sw raid), but we had other machines with raid5
which didn't have that alignment requiriments.

The problem with that is that Oracle db, which we use
with XFS alot, refuses to work on this machine, or,
rather, XFS refuses to process I/O in 512-byte chunks
from oracle (control files and redolog files).

I know it is a frequent combination which is used in
production in many places, and is used here alot too,
but I haven't seen anyone mentioning this issue we
have now, with "larger than usual" alignment size
requiriments.

Is there a way to remedy this somehow, without
reformatting whole 600+ gb?

Thank you!

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
