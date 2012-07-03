Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q638P6iO072433
	for <linux-xfs@oss.sgi.com>; Tue, 3 Jul 2012 03:25:07 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id dL1i0vktdWosFtU7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 01:25:05 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1SlyPw-0003WT-Cy
	for linux-xfs@oss.sgi.com; Tue, 03 Jul 2012 10:25:04 +0200
Received: from 44-162.0-85.cust.bluewin.ch ([85.0.162.44])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jul 2012 10:25:04 +0200
Received: from ramonhofer by 44-162.0-85.cust.bluewin.ch with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jul 2012 10:25:04 +0200
From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Use whole disk
Date: Tue, 3 Jul 2012 08:20:06 +0000 (UTC)
Message-ID: <jsu9vm$t01$4@dough.gmane.org>
References: <jsu88p$t01$1@dough.gmane.org>
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
To: linux-xfs@oss.sgi.com

On Tue, 03 Jul 2012 07:50:49 +0000, Ramon Hofer wrote:

> Is it ok to use the disk instead of the partition or why do I have to
> create the filesystem on a partition?

I was told that it's possible to use the whole disk. But it's safer 
because the user (me) and some tools see that the disk is already used 
because of the valid partition table.

Another reason would be the filesystem alignment that could cause 
performance issues.


Best regards
Ramon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
