Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 19:46:35 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L3kQCS001928
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 19:46:28 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D6A9CAAF8E
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 19:46:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id aZfDu9uos8T83coI for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 19:46:41 -0800 (PST)
Message-ID: <4794159F.9070505@sandeen.net>
Date: Sun, 20 Jan 2008 21:46:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: small problem w/ new xfs defaults patch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, Niv Sardi <xaiki@sgi.com>

Index: xfsprogs-2.9.4/growfs/xfs_growfs.c
===================================================================
--- xfsprogs-2.9.4.orig/growfs/xfs_growfs.c
+++ xfsprogs-2.9.4/growfs/xfs_growfs.c
@@ -58,7 +58,6 @@ report_info(
        int             isint,
        char            *logname,
        char            *rtname,
-       int             unwritten,
        int             lazycount,
        int             dirversion,
        int             logversion,
@@ -68,7 +67,7 @@ report_info(
            "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
            "         =%-22s sectsz=%-5u attr=%u\n"
            "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
-           "         =%-22s sunit=%-6u swidth=%u blks, unwritten=%u\n"
+           "         =%-22s sunit=%-6u swidth=%u blks"
            "naming   =version %-14u bsize=%-6u\n"
            "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
            "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"


couple things... you lost a "\n" off the end of the data section there...

Also, do you really want to drop reporting of unwritten extents?  Even
if you're disallowing the selection on new mkfs's there may still be
different flavors of filesystems in existence, should it still be reported?

-Eric
