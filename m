Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Nov 2008 14:42:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA3MQ83i002655
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 14:26:08 -0800
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF14C5762C7
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2008 14:26:10 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id tN8oW63H0xJ0FlSE for <xfs@oss.sgi.com>; Mon, 03 Nov 2008 14:26:10 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mA3MQ90W026566
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 17:26:09 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3MQ9kq012736
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 17:26:09 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mA3MQ74e007512
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 17:26:08 -0500
Message-ID: <490F7A7F.9010102@sandeen.net>
Date: Mon, 03 Nov 2008 16:26:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix buffer overflow in lstat64.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

lstat64.c was putting an 11-byte string into a 10-byte buffer.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/src/lstat64.c
===================================================================
--- xfs-cmds.orig/xfstests/src/lstat64.c
+++ xfs-cmds/xfstests/src/lstat64.c
@@ -57,7 +57,7 @@ int
 main(int argc, char **argv)
 {
 	struct stat64	sbuf;
-	char		mode[10];
+	char		mode[11];
 	int		i, c;
 	int		terse_flag = 0;
 
