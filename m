Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0089B7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 15:02:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C461AC007
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 13:02:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zJ1Jc2HtQwY8Y7fn for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 13:02:11 -0800 (PST)
Message-ID: <54F772D2.2030602@sandeen.net>
Date: Wed, 04 Mar 2015 15:02:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/4] xfs_repair: set *parent if process_dir2_data() fixes
	root inode's parent
References: <54F77199.8030708@redhat.com>
In-Reply-To: <54F77199.8030708@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

process_dir2_data() may fix the root dir's parent inode:

"bad .. entry in root directory inode 6912, was 7159: correcting"

But we don't update the *parent passed in in that case; this then leads to
an assert later in process_dir2, because *parent is still the wrong value:

xfs_repair: dir2.c:2039: process_dir2:
  Assertion `(ino != mp->m_sb.sb_rootino && ino != *parent) ||
  (ino == mp->m_sb.sb_rootino && (ino == *parent || need_root_dotdot == 1))'
  failed.

Updating the value of *parent when we fix the parent value resolves this
problem.  Do it whether or not we're in no_modify mode.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dir2.c b/repair/dir2.c
index 6b8964d..67cd9d1 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1468,6 +1468,7 @@ _("bad .. entry in root directory inode %" PRIu64 ", was %" PRIu64 ": "),
 					} else {
 						do_warn(_("would correct\n"));
 					}
+					*parent = ino;
 				}
 			}
 			/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
