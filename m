Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E6AF7F76
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 17:52:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 768458F8081
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 15:52:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rpzDMAwcTPEWuJpl for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 15:52:32 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 8/9] xfs: print useful caller information in xfs_error_report
Date: Tue, 18 Feb 2014 17:52:28 -0600
Message-Id: <1392767549-25574-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
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

xfs_error_report used to just print the hex address of the caller;
%pF will give us something more human-readable.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_error.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 8733c59..04d8e65 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -156,7 +156,7 @@ xfs_error_report(
 {
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
-		"Internal error %s at line %d of file %s.  Caller 0x%p",
+		"Internal error %s at line %d of file %s.  Caller %pF",
 			    tag, linenum, filename, ra);
 
 		xfs_stack_trace();
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
