Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5AE57F6D
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 09:09:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C5DCA8F8049
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 07:09:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uQnEB8rWIc82bzoA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 07:09:19 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 632478E7A9
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 14:09:19 +0000 (UTC)
Received: from hades.maiolino.org.com ([10.3.112.11])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t5OE9GFd020379
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 10:09:18 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_quota: Better describe quota verbose output
Date: Wed, 24 Jun 2015 11:09:09 -0300
Message-Id: <1435154949-14223-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Due historical reasons, and to be compliant with the generic quota command,
xfs_quota does not output any information when there is no used percentage of
the available quota. Such behavior might make users confused, so, I believe it's
better to have the reasons for such behavior better documented.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/xfs_quota.8 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 9b555e9..ef90bfb 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -197,7 +197,9 @@ option reports the numeric IDs rather than the name. The
 .B \-N
 option omits the header. The
 .B \-v
-option outputs verbose information. The
+option outputs verbose information, displaying quota values even when there is
+no used space. Such behavior was chosen to be compliant with the 'quota' command
+and for historical reasons. The
 .B \-f
 option sends the output to
 .I file
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
