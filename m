Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 11:45:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MIjFdO002822
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 11:45:17 -0700
Received: from ninsei.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D03C810D04C6
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 11:46:58 -0700 (PDT)
Received: from ninsei.hu (ninsei.hu [212.92.23.158]) by cuda.sgi.com with ESMTP id ZekjUvkL9CIqZs76 for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 11:46:58 -0700 (PDT)
Received: from kyra (pb-d-128-141-48-108.cern.ch [128.141.48.108])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id A03B97833
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 20:46:53 +0200 (CEST)
Date: Wed, 22 Oct 2008 20:36:36 +0200
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: [PATCH] xfs_repair: print superblock offsets and denial reasons
Message-ID: <20081022183636.GE20550@kyra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Example output (without the scanning dots):

Phase 1 - find and verify superblock.
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
found candidate secondary superblock...
offset: 62498275328
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 156246212608
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 249994149888
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 343742087168
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 437490024448
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 531237961728
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 624985899008
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 718733836288
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 812481773568
reason: 16
unable to verify superblock, continuing...
found candidate secondary superblock...
offset: 906229710848
reason: 16
unable to verify superblock, continuing...
Sorry, could not find valid secondary superblock
Exiting now.

Signed-off-by: KELEMEN Peter <Peter.Kelemen@cern.ch>

Index: xfsprogs/repair/sb.c
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/repair/sb.c,v
retrieving revision 1.22
diff -u -r1.22 sb.c
--- xfsprogs/repair/sb.c	8 Sep 2008 06:18:43 -0000	1.22
+++ xfsprogs/repair/sb.c	22 Oct 2008 18:13:26 -0000
@@ -96,6 +96,7 @@
 	int		dirty;
 	int		retval;
 	int		bsize;
+	int		reason;		/* why sb cannot be verified */
 
 	do_warn(_("\nattempting to find secondary superblock...\n"));
 
@@ -140,6 +141,7 @@
 				continue;
 
 			do_warn(_("found candidate secondary superblock...\n"));
+			do_warn("offset: %Lu\n", off);
 
 			/*
 			 * found one.  now verify it by looking
@@ -149,12 +151,13 @@
 			rsb->sb_inprogress = 0;
 			clear_sunit = 1;
 
-			if (verify_set_primary_sb(rsb, 0, &dirty) == XR_OK)  {
+			if ((reason = verify_set_primary_sb(rsb, 0, &dirty)) == XR_OK)  {
 				do_warn(
 			_("verified secondary superblock...\n"));
 				done = 1;
 				retval = 1;
 			} else  {
+				do_warn("reason: %d\n", reason);
 				do_warn(
 			_("unable to verify superblock, continuing...\n"));
 			}
