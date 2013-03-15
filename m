Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C753C7FEC
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55230AC008
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qAgEaETBQ3uR3AWq for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:46 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCj-0001TY-9Z
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCZ-0005ho-7r
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/13] xfstests: rename RETAIN_AG_BYTES
Date: Fri, 15 Mar 2013 22:53:22 +1100
Message-Id: <1363348411-21867-5-git-send-email-david@fromorbit.com>
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

Rename the $RETAIN_AG_BYTES variable to be more generic so that it
reflects the fact that it is designed to retain a certain amount of
extra free space above the default amount in the filesystem when
doing large scratch device testing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
---
 common.rc |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common.rc b/common.rc
index edf0318..42d2ddc 100644
--- a/common.rc
+++ b/common.rc
@@ -311,8 +311,8 @@ _scratch_mkfs_xfs()
     rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
 
     if [ "$LARGE_SCRATCH_DEV" = yes ]; then
-        [ -z "$RETAIN_AG_BYTES" ] && RETAIN_AG_BYTES=0
-        ./tools/ag-wipe -q -r $RETAIN_AG_BYTES $SCRATCH_DEV
+        [ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
+        ./tools/ag-wipe -q -r $SCRATCH_DEV_EMPTY_SPACE $SCRATCH_DEV
     fi
 
     return $mkfs_status
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
