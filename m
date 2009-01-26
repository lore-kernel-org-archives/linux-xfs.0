Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q70raY201840 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:00:54 -0600
Received: from tyo200.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72A2B17CCEF4
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:00:09 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by cuda.sgi.com with ESMTP id ak0JRceL5PB8EMNj for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:00:09 -0800 (PST)
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id n0Q5r0Yr002925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 14:53:00 +0900 (JST)
Received: from mailgate3.nec.co.jp ([10.7.69.193])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id n0Q5okSn025991
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 14:50:46 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp
	(8.11.7/3.7W-MAILGATE-NEC) id n0Q5oka20117 for xfs@oss.sgi.com;
	Mon, 26 Jan 2009 14:50:46 +0900 (JST)
Received: from mail03.kamome.nec.co.jp (mail03.kamome.nec.co.jp [10.25.43.7])
	by mailsv4.nec.co.jp (8.13.8/8.13.4) with ESMTP id n0Q5oiXv027338
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 14:50:46 +0900 (JST)
Message-ID: <497D4F35.2050506@sx.jp.nec.com>
Date: Mon, 26 Jan 2009 14:50:45 +0900
From: Kazuya Mio <k-mio@sx.jp.nec.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix mkfs man page typo
References: <1232777420.13684.14.camel@verge.scott.net.au>
In-Reply-To: <1232777420.13684.14.camel@verge.scott.net.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

The period after "xfs_growfs(8)" hasn't been displayed yet by your fix.
How about the following patch?

Regards,
Kazuya Mio

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
diff -uprN a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
--- a/man/man8/mkfs.xfs.8	2009-01-23 13:10:55.000000000 +0900
+++ b/man/man8/mkfs.xfs.8	2009-01-23 15:45:14.000000000 +0900
@@ -322,8 +322,7 @@ Setting the value to 0 means that essent
  can become inode blocks, subject to inode32 restrictions.
  .IP
  This value can be modified with
-.Ixfs_growfs(8)
-.
+.IR xfs_growfs (8).
  .TP
  .BI align[= value ]
  This is used to specify that inode allocation is or is not aligned. The

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
