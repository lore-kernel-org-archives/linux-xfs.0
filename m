Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 18:40:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m381dphd008554
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 18:39:53 -0700
Date: Tue, 8 Apr 2008 11:40:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa 185 - remove uninitialised variables in golden output.
Message-ID: <20080408014023.GO108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Kill the output of uninitialised values when punching a hole.
This prevents the test from passing on just about everything.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/185.out                                        |    5 -----
 xfstests/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: xfs-cmds/xfstests/185.out
===================================================================
--- xfs-cmds.orig/xfstests/185.out	2008-03-13 17:49:31.000000000 +1100
+++ xfs-cmds/xfstests/185.out	2008-04-08 11:31:30.520670188 +1000
@@ -12,7 +12,6 @@ roffp is 0, rlenp is 16384
 Method:	dmapi_punch
 Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
   offset = '0', length = '16384', sid = '0'
-roffp is 4200149, rlenp is 47820330485640
 =======================================================
 =======================================================
 Testing with length = 1k, offset = 0
@@ -27,7 +26,6 @@ roffp is 0, rlenp is 1024
 Method:	dmapi_punch
 Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
   offset = '0', length = '1024', sid = '0'
-roffp is 4200149, rlenp is 47194545715080
 =======================================================
 =======================================================
 Testing with length = 1k, offset = 4k
@@ -42,7 +40,6 @@ roffp is 4096, rlenp is 1024
 Method:	dmapi_punch
 Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
   offset = '4096', length = '1024', sid = '0'
-roffp is 4200149, rlenp is 47256598480776
 =======================================================
 =======================================================
 Testing with length = 4k, offset = 1k
@@ -57,7 +54,6 @@ roffp is 1024, rlenp is 4096
 Method:	dmapi_punch
 Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
   offset = '1024', length = '4096', sid = '0'
-roffp is 4200149, rlenp is 47292581427080
 =======================================================
 =======================================================
 Testing with length = 1024k, offset = 512k
@@ -72,5 +68,4 @@ roffp is 524288, rlenp is 1048576
 Method:	dmapi_punch
 Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
   offset = '524288', length = '1048576', sid = '0'
-roffp is 4200149, rlenp is 47016592795528
 =======================================================
Index: xfs-cmds/xfstests/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
===================================================================
--- xfs-cmds.orig/xfstests/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c	2008-03-13 17:49:31.000000000 +1100
+++ xfs-cmds/xfstests/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c	2008-04-08 11:30:32.032200700 +1000
@@ -176,6 +176,7 @@ main(
 				strerror(errno));
 			exit(1);
 		}
+		fprintf(stdout, "roffp is %lld, rlenp is %lld\n", roffp, rlenp);
 		break;
 	case METHOD_DMAPI_PUNCH:
 		if (dm_punch_hole(sid, hanp, hlen, DM_NO_TOKEN, offset, length)) {
@@ -185,7 +186,6 @@ main(
 		}
 		break;			
 	}
-	fprintf(stdout, "roffp is %lld, rlenp is %lld\n", roffp, rlenp);
 	dm_handle_free(hanp, hlen);
 	
 	return 0;
