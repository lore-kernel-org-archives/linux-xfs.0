Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 902B77F67
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 11:41:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6545A304032
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 09:41:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BL0XxqGmH1vDU7PL for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 09:41:06 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/5] xfs_repair: clear bad flgs in process_dinode_int
Date: Sun,  7 Sep 2014 11:41:01 -0500
Message-Id: <1410108065-18156-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
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

process_dinode_int() reports bad flags if
dino->di_flags & ~XFS_DIFLAG_ANY - i.e. if
any flags are set outside the known set.  But
then instead of clearing them, it does
flags &= ~XFS_DIFLAG_ANY which keeps *only*
the bad flags.  This leads to persistent,
unrepairable errors of the form:

"Bad flags set in inode XXX"

Fix this.

While we are at it, fix a couple lines which
look like they used to be continuation lines,
but are no longer.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/dinode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 8891e84..38a6562 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2456,7 +2456,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	_("Bad flags set in inode %" PRIu64 "\n"),
 					lino);
 			}
-			flags &= ~XFS_DIFLAG_ANY;
+			flags &= XFS_DIFLAG_ANY;
 		}
 
 		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
@@ -2513,11 +2513,11 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 		if (!verify_mode && flags != be16_to_cpu(dino->di_flags)) {
 			if (!no_modify) {
-				do_warn(_(", fixing bad flags.\n"));
+				do_warn(_("fixing bad flags.\n"));
 				dino->di_flags = cpu_to_be16(flags);
 				*dirty = 1;
 			} else
-				do_warn(_(", would fix bad flags.\n"));
+				do_warn(_("would fix bad flags.\n"));
 		}
 	}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
