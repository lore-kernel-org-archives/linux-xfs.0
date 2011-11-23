Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANJBDLv230622 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 13:11:15 -0600
Received: from mail.qboosh.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CC811D2FA40
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:11:08 -0800 (PST)
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61]) by cuda.sgi.com
	with ESMTP id vrny9S3htvyMZHIF for <xfs@oss.sgi.com>;
	Wed, 23 Nov 2011 11:11:08 -0800 (PST)
Received: from stranger.qboosh.pl (77-253-113-243.adsl.inetia.pl
	[77.253.113.243])
	by mail.qboosh.pl (Postfix) with ESMTPSA id 45519FB0C1
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 20:12:49 +0100 (CET)
Received: from stranger.qboosh.pl (localhost [127.0.0.1])
	by stranger.qboosh.pl (8.14.3/8.14.3) with ESMTP id pANJBt07017190
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 20:11:55 +0100
Received: (from qboosh@localhost)
	by stranger.qboosh.pl (8.14.3/8.14.3/Submit) id pANJBskt017186
	for xfs@oss.sgi.com; Wed, 23 Nov 2011 20:11:54 +0100
Date: Wed, 23 Nov 2011 20:11:54 +0100
From: Jakub Bogusz <qboosh@pld-linux.org>
Subject: Polish translation update for xfsprogs 3.1.7
Message-ID: <20111123191153.GE14429@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Disposition: inline
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

Hello,

I've just updated pl.po file for xfsprogs 3.1.7.
It's available at http://qboosh.pl/pl.po/xfsprogs-3.1.7.pl.po


Note that there are still two msgid issues (hex vs decimal formatting):

#: .././repair/scan.c:314
#, c-format
msgid "bad state %d, inode 0x%<PRIu64> bmap block 0x%<PRIx64>\n"

#: .././repair/scan.c:391
#, c-format
msgid "inode 0x%<PRIu64> bad # of bmap records (%u, min - %u, max - %u)\n"

I'd suggest:

-"bad state %d, inode 0x%<PRIu64> bmap block 0x%<PRIx64>\n"
+"bad state %d, inode %<PRIu64> bmap block 0x%<PRIx64>\n"

-"inode 0x%<PRIu64> bad # of bmap records (%u, min - %u, max - %u)\n"
+"inode %<PRIu64> bad # of bmap records (%u, min - %u, max - %u)\n"


-- 
Jakub Bogusz    http://qboosh.pl/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
