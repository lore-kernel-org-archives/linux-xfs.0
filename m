Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85A557F5D
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65D5F304048
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id M0KipvzTMQ17USpS for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:20 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/13] xfs_repair: set *parent if process_dir2_data() fixes
	root inode
Date: Tue, 17 Mar 2015 15:33:13 -0500
Message-Id: <1426624395-8258-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
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

process_dir2_data() may fix the root dir's parent inode:

"bad .. entry in root directory inode 6912, was 7159: correcting"

But we don't update the *parent passed in in that case; this then leads to
an assert later in process_dir2:

xfs_repair: dir2.c:2039: process_dir2:
  Assertion `(ino != mp->m_sb.sb_rootino && ino != *parent) ||
  (ino == mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
  failed.

Updating the value of *parent when we fix the parent value resolves this
problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 repair/dir2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index b1816f4..9e6c67d 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1407,6 +1407,7 @@ _("bad .. entry in root directory inode %" PRIu64 ", was %" PRIu64 ": "),
 					} else {
 						do_warn(_("would correct\n"));
 					}
+					*parent = ino;
 				}
 			}
 			/*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
