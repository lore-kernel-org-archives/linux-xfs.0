Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3AD9A7FF5
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A8E48F8049
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DVYyegCHKo9mfFVh for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCj-0001U2-Gm
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCj-0005iH-Dy
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/13] xfstests: disable tests that typically fail on large
	filesystems
Date: Fri, 15 Mar 2013 22:53:28 +1100
Message-Id: <1363348411-21867-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1363348411-21867-1-git-send-email-david@fromorbit.com>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
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

Test 017 typically fails due to the OOM killer kicking in and
killing everything but xfs_db so panics the machine.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
---
 017 |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/017 b/017
index fb92375..65ddce1 100755
--- a/017
+++ b/017
@@ -48,6 +48,10 @@ _supported_os Linux
 
 _require_scratch
 
+# xfs_db will OOM kill the machine if you don't have huge amounts of RAM, so
+# don't run this on large filesystems.
+_require_no_large_scratch_dev
+
 echo "*** init FS"
 
 rm -f $seq.full
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
