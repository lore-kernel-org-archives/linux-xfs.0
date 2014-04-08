Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8848F80D3
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:25:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 810AF30408C
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:25:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id M0R1qt3CbEsE84dB for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:25:19 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/14] xfsprogs: annotate a case fallthrough in libxfs_ialloc
Date: Tue,  8 Apr 2014 18:24:59 -0500
Message-Id: <1396999504-13769-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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

This is all working as intended, but add a comment to
make it more obvious to readers and static code
checkers.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index f1aa4c6..1e48079 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -265,6 +265,7 @@ libxfs_ialloc(
 	case S_IFSOCK:
 		/* doesn't make sense to set an rdev for these */
 		rdev = 0;
+		/* FALLTHROUGH */
 	case S_IFCHR:
 	case S_IFBLK:
 		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
