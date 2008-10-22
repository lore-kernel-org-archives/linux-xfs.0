Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 16:40:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MNdw83003034
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 16:39:59 -0700
Received: from ninsei.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0317530EE1
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 16:41:43 -0700 (PDT)
Received: from ninsei.hu (ninsei.hu [212.92.23.158]) by cuda.sgi.com with ESMTP id D9uVRJ0oekFPJAwC for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 16:41:43 -0700 (PDT)
Received: from kyra (lns-bzn-35-82-250-224-246.adsl.proxad.net [82.250.224.246])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id 51FF17830
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 01:41:35 +0200 (CEST)
Date: Thu, 23 Oct 2008 01:41:28 +0200
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: [PATCH V2] xfs_repair: print superblock offsets and why they can't
	be verified
Message-ID: <20081022234128.GC4395@kyra>
References: <20081022183636.GE20550@kyra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022183636.GE20550@kyra>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Eric has pointed out that verify_set_primary_sb() will either
return 1 or XR_INSUFF_SEC_SB.  Move the check lower into
verify_set_primary_sb() by checking the return value of
verify_sb().  Example output:

found candidate secondary superblock...
verifying sb at 31249334272: bad magic number (1)
verifying sb at 62498668544: bad magic number (1)
verifying sb at 93748002816: bad magic number (1)
verifying sb at 124997337088: bad magic number (1)
unable to verify superblock, continuing...


Signed-off-by: KELEMEN Peter <Peter.Kelemen@cern.ch>

Index: xfsprogs/repair/sb.c
===================================================================
RCS file: /cvs/xfs-cmds/xfsprogs/repair/sb.c,v
retrieving revision 1.22
diff -u -u -r1.22 sb.c
--- xfsprogs/repair/sb.c	8 Sep 2008 06:18:43 -0000	1.22
+++ xfsprogs/repair/sb.c	22 Oct 2008 23:17:27 -0000
@@ -683,6 +683,7 @@
 	int		num_ok;
 	int		retval;
 	int		round;
+	int		reason;	/* why the sb check failed */
 
 	/*
 	 * select the number of secondaries to try for
@@ -727,7 +728,7 @@
 				goto out;
 			}
 
-			if (verify_sb(sb, 0) == XR_OK)  {
+			if ((reason = verify_sb(sb, 0)) == XR_OK)  {
 				/*
 				 * save away geometry info.
 				 * don't bother checking the sb
@@ -740,6 +741,9 @@
 				get_sb_geometry(&geo, sb);
 				list = add_geo(list, &geo, agno);
 				num_ok++;
+			} else {
+				do_warn("verifying sb at %Lu: %s (%d)\n",
+					off, err_string(reason), reason);
 			}
 		}
 	}
