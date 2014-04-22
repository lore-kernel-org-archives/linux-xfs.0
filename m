Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1FF8D7F51
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:04:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E472F8F8066
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 15:04:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AzsiNhuPmbGeHo4r for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 15:04:43 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wcinv-0002PN-Ea
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wcinv-0000oM-Du
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] filter: xfs_repair emits new corruption messagse
Date: Wed, 23 Apr 2014 08:04:34 +1000
Message-Id: <1398204274-2113-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1398204274-2113-1-git-send-email-david@fromorbit.com>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
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

xfs_repair now dumps metadata and CRC corruption information to the
output from the verifier infrastrcuture. Filter this out so that it
doesn't cause spurious test failures such as in xfs/030 and xfs/033.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/repair | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/repair b/common/repair
index db160bb..3e73c1d 100644
--- a/common/repair
+++ b/common/repair
@@ -80,6 +80,9 @@ s/\s+- \d+:\d\d:\d\d:.*\n//g;
 # crc enabled filesystem output
 /XFS_CORRUPTION_ERROR/ && next;
 /^bad uuid/ && next;
+/^Metadata corruption detected/ && next;
+/^Metadata CRC error detected/ && next;
+/^agfl has bad CRC/ && next;
 	print;'
 }
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
