Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ0ajRB021867 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 18:36:45 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 448D130405F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 16:36:41 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com
	[134.14.54.237]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA07044 for
	<xfs@oss.sgi.com>; Wed, 26 Nov 2008 11:36:39 +1100
Subject: TAKE - xfsdump: don't redeclare offsetoff
Message-Id: <20081126003639.9C3B959391F9@chook.melbourne.sgi.com>
Date: Wed, 26 Nov 2008 11:36:39 +1100 (EST)
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

Don't redeclare offsetof, we already include <stddef.h> to get it and
modern gcc will complain about the redeclaration.
 
 
Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Nov 26 11:35:28 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-clean
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32547a
xfsdump/common/getdents.c - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/common/getdents.c.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- don't redeclare offsetoff


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
