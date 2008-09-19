Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 19:28:11 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J2S8Sf008482
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 19:28:09 -0700
Message-ID: <48D31095.908@sgi.com>
Date: Fri, 19 Sep 2008 12:38:13 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] xail idbg command doesn't increment count in each loop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

count is never incremented on each log item because it is unreachable code.

--- a/fs/xfs/xfsidbg.c	2008-09-19 12:27:05.000000000 +1000
+++ b/fs/xfs/xfsidbg.c	2008-09-16 12:34:12.000000000 +1000
@@ -6249,8 +6249,8 @@ xfsidbg_xaildump(xfs_mount_t *mp)
 		default:
 			kdb_printf("Unknown item type %d\n", lip->li_type);
 			break;
-		count++;
 		}
+		count++;
 	}
 }
