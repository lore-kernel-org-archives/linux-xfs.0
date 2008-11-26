Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ0Kxdh020548 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 18:20:59 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id 608C2AC015
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 16:20:58 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com
	[134.14.54.237]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA06619 for
	<xfs@oss.sgi.com>; Wed, 26 Nov 2008 11:20:56 +1100
Subject: TAKE - fix xfsqa on whole disks
Message-Id: <20081126002056.81F1359391F9@chook.melbourne.sgi.com>
Date: Wed, 26 Nov 2008 11:20:56 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

mkfe2fs unfortunately hasn't heard about real enterprise setups using
whole disks and needs the -F option to create a filesystem on those
without asking stupid questions that make the testcases block forever.
 
 
Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Nov 26 11:18:44 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-clean
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32546a
xfstests/032 - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/032.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- fix xfsqa on whole disks

xfstests/049 - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/049.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- fix xfsqa on whole disks


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
