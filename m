Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 17:59:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q0x85T011783
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 17:59:08 -0700
Received: from ninsei.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08B2A1AF23BD
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 18:00:42 -0700 (PDT)
Received: from ninsei.hu (ninsei.hu [212.92.23.158]) by cuda.sgi.com with ESMTP id gE9YxmCQSRK14vnK for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 18:00:42 -0700 (PDT)
Received: from kyra (lns-bzn-35-82-250-248-91.adsl.proxad.net [82.250.248.91])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id 221E3785E
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 03:00:39 +0200 (CEST)
Date: Fri, 26 Sep 2008 03:00:38 +0200
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: [PATCH][DOC] xfs_stats.pl: xs_log_blocks counts in basic blocks
Message-ID: <20080926010038.GG13108@kyra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_stats.pl: xs_log_blocks counts in basic blocks.
Fix up documentation to match reality as discussed on #xfs .

Index: xfsmisc/xfs_stats.pl
===================================================================
RCS file: /cvs/xfs-cmds/xfsmisc/xfs_stats.pl,v
retrieving revision 1.5
diff -u -u -r1.5 xfs_stats.pl
--- xfsmisc/xfs_stats.pl	10 Feb 2004 17:10:22 -0000	1.5
+++ xfsmisc/xfs_stats.pl	26 Sep 2008 00:56:54 -0000
@@ -337,7 +337,7 @@
 
 =head2 B<xs_log_blocks> (I<xfs.log.blocks>)
 
-This variable counts the number of Kbytes of information being written
+This variable counts (in 512-byte units) the information being written
 to the physical log partitions of all XFS filesystems. Log data traffic
 is proportional to the level of meta-data updating. The rate with which
 log data gets written depends on the size of internal log buffers and
