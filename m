Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 16:34:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3NNYTPM024452
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 16:34:32 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AED67AB7FD7
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 16:35:09 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id ACl0Uegd3J26EtYC for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 16:35:09 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m3NNYhUE029354
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 16:34:45 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m3NNYhsF017189
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 16:34:43 -0700
Message-ID: <480FC7AA.5060401@agami.com>
Date: Wed, 23 Apr 2008 16:35:06 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: [PATCH] fix xfs kernel so  2GiB logs work
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: XFS Mailing List <xfs@oss.sgi.com>

I hope that I've got everything now.

Ensure that 2 GiB xfs logs work properly.

We found this while experimenting with 2GiB xfs logs.
The previous code never assumed that xfs logs would
ever get so large.

Signed-off-by: Michael Nishimoto <miken@agami.com>
===========================================================
--- xfs_log.2.c 2008-04-01 11:55:45.000000000 -0700
+++ xfs_log.3.c 2008-04-01 11:56:53.000000000 -0700
@@ -230,20 +230,24 @@
  static void
  xlog_grant_add_space_write(struct log *log, int bytes)
  {
-       log->l_grant_write_bytes += bytes;
-       if (log->l_grant_write_bytes > log->l_logsize) {
-               log->l_grant_write_bytes -= log->l_logsize;
-               log->l_grant_write_cycle++;
+       int tmp = log->l_logsize - log->l_grant_write_bytes;
+       if (tmp > bytes)
+               log->l_grant_write_bytes += bytes;
+       else {
+               log->l_grant_write_cycle++;
+               log->l_grant_write_bytes = bytes - tmp;
         }
  }

  static void
  xlog_grant_add_space_reserve(struct log *log, int bytes)
  {
-       log->l_grant_reserve_bytes += bytes;
-       if (log->l_grant_reserve_bytes > log->l_logsize) {
-               log->l_grant_reserve_bytes -= log->l_logsize;
-               log->l_grant_reserve_cycle++;
+       int tmp = log->l_logsize - log->l_grant_reserve_bytes;
+       if (tmp > bytes)
+               log->l_grant_reserve_bytes += bytes;
+       else {
+               log->l_grant_reserve_cycle++;
+               log->l_grant_reserve_bytes = bytes - tmp;
         }
  }
