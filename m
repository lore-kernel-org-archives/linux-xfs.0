Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Mar 2008 20:04:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2O33ub2002328
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 20:03:59 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C210C1004FE5
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 20:04:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id PiFNCdRI2b8vOZ4T for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 20:04:30 -0700 (PDT)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id BD3D318004B4A
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 22:04:29 -0500 (CDT)
Message-ID: <47E71A3D.9040707@sandeen.net>
Date: Sun, 23 Mar 2008 22:04:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsqa: make 054 _require_quota
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

054 needs quota support to run, but doesn't make that explicit.

Index: xfstests/054
===================================================================
--- xfstests.orig/054
+++ xfstests/054
@@ -38,6 +38,7 @@ cp /dev/null $seq.full
 chmod ugo+rwx $seq.full
 
 _require_scratch
+_require_quota
 
 _filter_stat()
 {
