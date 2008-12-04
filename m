Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB475oqd031481 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 01:05:50 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 7130B304085
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 23:05:46 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id SAA21339 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 18:05:44 +1100
Message-ID: <4937815F.5010500@sgi.com>
Date: Thu, 04 Dec 2008 18:06:07 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Fix bug in xlogitm idbg command
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Print out the correct field for the back pointer in the
xlogitm idbg command.

--- a/fs/xfs/xfsidbg.c	2008-12-04 13:57:45.000000000 +1100
+++ b/fs/xfs/xfsidbg.c	2008-12-03 17:16:55.000000000 +1100
@@ -6373,7 +6250,7 @@ xfsidbg_xlogitem(xfs_log_item_t *lip)
  	printflags((uint)(lip->li_flags), li_flags,"log");
  	kdb_printf("\n");
  	kdb_printf("ail forw 0x%p ail back 0x%p lsn %s\ndesc %p ops 0x%p",
-		lip->li_ail.next, lip->li_ail.next,
+		lip->li_ail.next, lip->li_ail.prev,
  		xfs_fmtlsn(&(lip->li_lsn)), lip->li_desc, lip->li_ops);
  	kdb_printf(" iodonefunc &0x%p\n", lip->li_cb);
  	if (lip->li_type == XFS_LI_BUF) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
