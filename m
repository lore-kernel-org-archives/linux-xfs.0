Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 294947F3F
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 08:30:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 076E530408E
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 06:30:54 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id 80HDHNvj2lkhYus5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Mar 2013 06:30:54 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Sat, 23 Mar 2013 09:30:53 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 3AC3E38C801A
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 09:30:51 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2NDUp1q297894 for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 09:30:51 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r2NDUoPU026300 for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 10:30:50 -0300
From: zwu.kernel@gmail.com
Subject: [PATCH] xfstests: fix the seq number in README
Date: Sat, 23 Mar 2013 21:29:51 +0800
Message-Id: <1364045391-28476-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Although it is one very trivial bug, one patch is worth to
make it perfect.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README b/README
index b70f75d..2d231de 100644
--- a/README
+++ b/README
@@ -177,7 +177,7 @@ Test script environment:
 				  and the content of the NIS database
 				  if it is likely to be present)
 
-     4. General recommendations, usage conventions, etc.:
+     5. General recommendations, usage conventions, etc.:
 	- When the content of the password or group file is
 	  required, get it using the _cat_passwd and _cat_group
 	  functions, to ensure NIS information is included if NIS
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
