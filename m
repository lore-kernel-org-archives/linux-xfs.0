Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jan 2008 02:38:10 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0SAc1ae000642
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 02:38:04 -0800
Received: from ninsei.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A97456B588
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 02:38:21 -0800 (PST)
Received: from ninsei.hu (ninsei.hu [212.92.23.158]) by cuda.sgi.com with ESMTP id ke4gGBe8w0QtS1eK for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 02:38:21 -0800 (PST)
Received: from luba (pb-d-128-141-48-100.cern.ch [128.141.48.100])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id 8AD6C7A79
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2008 11:38:17 +0100 (CET)
Date: Mon, 28 Jan 2008 11:38:15 +0100
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: [PATCH][DOC] xfs_stats.pl: xs_log_blocks counts in basic blocks
Message-ID: <20080128103815.GA1777@luba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xs_log_blocks is counting in basic blocks, update documentation as
discussed with Eric Sandeen on #xfs.

Index: xfsmisc/xfs_stats.pl
===================================================================
RCS file: /cvs/xfs-cmds/xfsmisc/xfs_stats.pl,v
retrieving revision 1.5
diff -u -u -r1.5 xfs_stats.pl
--- xfsmisc/xfs_stats.pl	10 Feb 2004 17:10:22 -0000	1.5
+++ xfsmisc/xfs_stats.pl	28 Jan 2008 10:34:05 -0000
@@ -337,7 +337,7 @@
 
 =head2 B<xs_log_blocks> (I<xfs.log.blocks>)
 
-This variable counts the number of Kbytes of information being written
+This variable counts (in 512-byte units) the information being written
 to the physical log partitions of all XFS filesystems. Log data traffic
 is proportional to the level of meta-data updating. The rate with which
 log data gets written depends on the size of internal log buffers and
