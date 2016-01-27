Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1529C7CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:50:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC65C304067
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 14:50:24 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XHT7DBBOP3yzSSHy for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2016 14:50:22 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 889DB6612D71
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 16:50:22 -0600 (CST)
Subject: [PATCH 1/2] xfs_quota: remove extra 30 seconds from time limit
	reporting
References: <56A9497C.9070400@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A949AD.9020903@sandeen.net>
Date: Wed, 27 Jan 2016 16:50:21 -0600
MIME-Version: 1.0
In-Reply-To: <56A9497C.9070400@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The addition of 30s makes little sense; it's only added to the
values reported via the userspace tool, and doesn't reflect the
actual values used in the kernel. Setting a time limit to
"00:30:00" and reporting back "00:30:30" makes little sense to me.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/util.c b/quota/util.c
index 179aafd..7c43fbd 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -42,8 +42,6 @@ time_to_string(
 		time(&now);
 		timer = MAX(origin - now, 0);
 	}
-	if (timer > 60)	/* roundup */
-		timer += 30;
 
 	days = timer / SECONDS_IN_A_DAY;
 	if (days)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
