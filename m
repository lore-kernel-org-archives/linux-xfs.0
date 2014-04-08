Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FA4280EE
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:25:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 491D28F8087
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:25:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id af072kPwL2yXZ68g for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:25:21 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/14] mkfs: catch unknown format in protofile parsing
Date: Tue,  8 Apr 2014 18:25:03 -0500
Message-Id: <1396999504-13769-14-git-send-email-sandeen@redhat.com>
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

As the code stands today we can't get an unknown format in the
last case statement, but Coverity warns that if we ever do, we'll
use an uninitialized "ip" in the call to libxfs_trans_log_inode().

Adding a default: case to catch unknown formats is defensive and
makes the checker happy.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 mkfs/proto.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 95583c9..308325b 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -591,6 +591,9 @@ parseproto(
 		}
 		libxfs_iput(ip, 0);
 		return;
+	default:
+		ASSERT(0);
+		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
 	error = libxfs_bmap_finish(&tp, &flist, &committed);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
