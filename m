Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1256DxA223752 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 23:06:14 -0600
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 212701BFEFE2
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2009 21:05:32 -0800 (PST)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by
	cuda.sgi.com with ESMTP id lFCmvA6Foc1mL9u4 for
	<xfs@oss.sgi.com>; Sun, 01 Feb 2009 21:05:32 -0800 (PST)
Received: from mailgate3.nec.co.jp ([10.7.69.192])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id n1255VHu008956
	for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 14:05:31 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp
	(8.11.7/3.7W-MAILGATE-NEC) id n1255Ve17114 for xfs@oss.sgi.com;
	Mon, 2 Feb 2009 14:05:31 +0900 (JST)
Received: from mail03.kamome.nec.co.jp (mail03.kamome.nec.co.jp [10.25.43.7])
	by mailsv.nec.co.jp (8.13.8/8.13.4) with ESMTP id n1255VgT012193
	for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 14:05:31 +0900 (JST)
Message-ID: <49867F0A.30300@sx.jp.nec.com>
Date: Mon, 02 Feb 2009 14:05:14 +0900
From: Kazuya Mio <k-mio@sx.jp.nec.com>
MIME-Version: 1.0
Subject: [PATCH] fix xfsctl man page typo
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

Hi,

This patch gets rid of the unnecessary period in xfsctl(3) man page.

Regards,
Kazuya Mio

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 64e18df..d586ea0 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -564,7 +564,7 @@ value of zero means that the inode table has been exhausted
 .B XFS_IOC_FSBULKSTAT_SINGLE
 This interface is a variant of the
 .B XFS_IOC_FSBULKSTAT
-interface, used to obtain information about a single inode.
+interface, used to obtain information about a single inode
 for an open file in the filesystem of interest.
 The same structure is used to pass information in and out of
 the kernel, except no output count parameter is used (should

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
