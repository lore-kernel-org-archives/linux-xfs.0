Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 77AEE29DF8
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 03:47:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F8B68F8049
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:47:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1fpXSjuGe0kee1CU for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 01:47:52 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXShb-00089D-Dx
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:47:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXShb-0000ok-9b
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:47:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: generic/241 requires dbench
Date: Wed,  1 May 2013 18:47:51 +1000
Message-Id: <1367398071-3112-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

common/config doesn't configure DBENCH_PROG so it doesn't run.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/config |    1 +
 1 file changed, 1 insertion(+)

diff --git a/common/config b/common/config
index dfbb5c2..b55a528 100644
--- a/common/config
+++ b/common/config
@@ -177,6 +177,7 @@ export FIO_PROG="`set_prog_path fio`"
 export FILEFRAG_PROG="`set_prog_path filefrag`"
 export E4DEFRAG_PROG="`set_prog_path e4defrag`"
 export LOGGER_PROG="`set_prog_path logger`"
+export DBENCH_PROG="`set_prog_path dbench`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
