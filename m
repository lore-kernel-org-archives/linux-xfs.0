Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 08:58:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA1Fwdei027082
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 08:58:40 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FE311314FF6
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 08:58:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id GVVxcgtgOeA6ZAbw for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 08:58:39 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E4B9DAC3590
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 10:58:37 -0500 (CDT)
Message-ID: <490C7CAC.2070902@sandeen.net>
Date: Sat, 01 Nov 2008 10:58:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: create tape group
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Create a tape group for anything which expects
to dump to tape (I guess this is a superset
of "remote" and a few others).

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/group
===================================================================
--- xfs-cmds.orig/xfstests/group
+++ xfs-cmds/xfstests/group
@@ -35,6 +35,9 @@ v2log		tes@sgi.com
 # xfsdump, xfsrestore, xfsinvutil
 dump		tes@sgi.com ivanr@sgi.com
 
+# xfsdump, xfsrestore to tapes
+tape		tes@sgi.com ivanr@sgi.com
+
 # xfsdump, xfsrestore to remote tapes
 remote		tes@sgi.com ivanr@sgi.com
 
@@ -118,10 +121,10 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 019 mkfs auto
 020 metadata attr udf auto
 021 db attr auto
-022 dump ioctl auto
-023 dump ioctl auto
-024 dump ioctl auto
-025 dump ioctl auto
+022 dump ioctl tape auto
+023 dump ioctl tape auto
+024 dump ioctl tape auto
+025 dump ioctl tape auto
 026 dump ioctl auto
 027 dump ioctl auto
 028 dump ioctl auto
@@ -131,15 +134,15 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 032 mkfs auto
 033 repair auto
 034 other auto
-035 dump ioctl auto
-036 dump ioctl remote auto
-037 dump ioctl remote auto
-038 dump ioctl remote auto
-039 dump ioctl remote auto
+035 dump ioctl tape auto
+036 dump ioctl remote tape auto
+037 dump ioctl remote tape auto
+038 dump ioctl remote tape auto
+039 dump ioctl remote tape auto
 040 other auto
 041 growfs ioctl auto
 042 fsr ioctl auto
-043 dump ioctl auto
+043 dump ioctl tape auto
 044 other auto
 045 other auto
 046 dump ioctl auto
@@ -151,7 +154,7 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 052 quota db auto
 053 acl repair auto
 054 quota auto
-055 dump ioctl remote auto
+055 dump ioctl remote tape auto
 056 dump ioctl auto
 057 acl auto
 058 acl auto
