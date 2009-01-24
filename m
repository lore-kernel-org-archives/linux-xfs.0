Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O6Tc8K255062 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 00:29:39 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AEBCB3DB8
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 22:28:55 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id z9YjtTScLiC6L2r7 for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 22:28:55 -0800 (PST)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id B9CD4220AF
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:13:23 +1100 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id NtXkjiveFfZXhwgC for
	<xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:13:23 +1100 (EST)
Received: from [192.168.0.100] (c220-239-214-222.fernt2.vic.optusnet.com.au
	[220.239.214.222])
	by postoffice.aconex.com (Postfix) with ESMTP id 9286C92C295
	for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 17:13:23 +1100 (EST)
Subject: [PATCH] fix mkfs man page typo
From: Nathan Scott <nscott@aconex.com>
Date: Sat, 24 Jan 2009 17:10:20 +1100
Message-Id: <1232777420.13684.14.camel@verge.scott.net.au>
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
To: xfs@oss.sgi.com

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 242f287..2dcefbe 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -322,7 +322,7 @@ Setting the value to 0 means that essentially all of
the filesystem
 can become inode blocks, subject to inode32 restrictions.
 .IP
 This value can be modified with
-.Ixfs_growfs(8)
+.IR xfs_growfs (8)
 .
 .TP
 .BI align[= value ]


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
