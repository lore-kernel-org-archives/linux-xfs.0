Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFfQpo010148 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:41:27 -0500
Received: from mail.qboosh.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 675BEF80F6D
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:49:29 -0700 (PDT)
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61]) by cuda.sgi.com
	with ESMTP id w59jiKHGCblJkMZh for <xfs@oss.sgi.com>;
	Thu, 20 Oct 2011 08:49:29 -0700 (PDT)
Received: from stranger.qboosh.pl (77-255-49-134.adsl.inetia.pl
	[77.255.49.134])
	by mail.qboosh.pl (Postfix) with ESMTPSA id A5BA5CF9E3
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 17:45:34 +0200 (CEST)
Received: from stranger.qboosh.pl (localhost [127.0.0.1])
	by stranger.qboosh.pl (8.14.3/8.14.3) with ESMTP id p9KFfPnd003043
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 17:41:25 +0200
Received: (from qboosh@localhost)
	by stranger.qboosh.pl (8.14.3/8.14.3/Submit) id p9KFfOjV003042
	for xfs@oss.sgi.com; Thu, 20 Oct 2011 17:41:25 +0200
Date: Thu, 20 Oct 2011 17:41:24 +0200
From: Jakub Bogusz <qboosh@pld-linux.org>
Subject: xfsprogs: Polish translation update + msgid bugs
Message-ID: <20111020154124.GB23961@stranger.qboosh.pl>
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

I've just updated pl.po file for xfsprogs 3.1.6.
It's available at http://qboosh.pl/pl.po/xfsprogs-3.1.6.pl.po


I also found some mistakes in messages used as msgid strings;
they are marked with "# XXX msgid bug:" in the above file.

There are two places with "n" instead of "\n" at the end of file:

#: .././repair/dinode.c:1442
#, c-format
msgid ""
"mismatch between format (%d) and size (%<PRId64>) in symlink inode %<PRIu64>n"

#: .././libxfs/freebsd.c:129
#, c-format
msgid "%s: Not a device or file: \"%s\"n"

one <PRIu64> without leading '%':

#: .././repair/phase6.c:2074
#, c-format
msgid "entry \"%s\" in directory inode %<PRIu64> points to free inode <PRIu64>"

one extra "u" after <PRIu64>:

#: .././repair/dir2.c:1177
#, c-format
msgid "corrected entry count in directory %<PRIu64>u, was %d, now %d\n"

and a few "0x" prefixes to %<PRIu64> (these values used to be printed
with %llx, so either <PRIu64> should be changed to <PRIx64>, or "0x" prefix
removed (I think the second version is better, as the value referred is
inode number, which in all other cases is printed decimal).

#: .././repair/scan.c:292
#, c-format
msgid "inode 0x%<PRIu64>bmap block 0x%<PRIu64> claimed, state is %d\n"

#: .././repair/scan.c:299
#, c-format
msgid "inode 0x%<PRIu64> bmap block 0x%<PRIu64> claimed, state is %d\n"

#: .././repair/scan.c:314
#, c-format
msgid "bad state %d, inode 0x%<PRIu64> bmap block 0x%<PRIu64>\n"

#: .././repair/scan.c:341 .././repair/scan.c:391
#, c-format
msgid "inode 0x%<PRIu64> bad # of bmap records (%u, min - %u, max - %u)\n"


-- 
Jakub Bogusz    http://qboosh.pl/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
