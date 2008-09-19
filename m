Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 19:37:24 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J2bMfM009026
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 19:37:22 -0700
Message-ID: <48D312BF.5000208@sgi.com>
Date: Fri, 19 Sep 2008 12:47:27 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] Fix buffer flag definitions for xbp idbg command
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

PARTIAL no longer exists
NONE is actually DONE
FS_DATAIOD no longer exists
FORCEIO no longer exists
FLUSH is actually ORDERED
DIRECTIO no longer exists
KMEM_ALLOC is actually PAGES
PRIVATE_BH no longer exists
PAGE_LOCKED is a new flag

--- a/fs/xfs/xfsidbg.c	2008-09-19 12:29:57.000000000 +1000
+++ b/fs/xfs/xfsidbg.c	2008-09-16 12:34:12.000000000 +1000
@@ -1925,11 +1925,11 @@ static int	kdbm_iptraceaddr(
 
 
 static char	*bp_flag_vals[] = {
-/*  0 */ "READ", "WRITE", "MAPPED", "PARTIAL", "ASYNC",
-/*  5 */ "NONE", "DELWRI",  "STALE", "FS_MANAGED", "FS_DATAIOD",
-/* 10 */ "FORCEIO", "FLUSH", "READ_AHEAD", "DIRECTIO", "LOCK",
-/* 15 */ "TRYLOCK", "DONT_BLOCK", "PAGE_CACHE", "KMEM_ALLOC", "RUN_QUEUES",
-/* 20 */ "PRIVATE_BH", "DELWRI_Q",
+/*  0 */ "READ", "WRITE", "MAPPED", "<unknown(3)>", "ASYNC",
+/*  5 */ "DONE", "DELWRI",  "STALE", "FS_MANAGED", "<unknown(9)>",
+/* 10 */ "<unknown(10)>", "ORDERED", "READ_AHEAD", "<unknown(13)>", "LOCK",
+/* 15 */ "TRYLOCK", "DONT_BLOCK", "PAGE_CACHE", "PAGES", "RUN_QUEUES",
+/* 20 */ "<unknown(20)>", "DELWRI_Q", "PAGE_LOCKED",
 	 NULL };
 
 static char	*iomap_flag_vals[] = {
