Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE7A87F82
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:12:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B534304067
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:19 -0800 (PST)
Received: from mail-ie0-f202.google.com (mail-ie0-f202.google.com
	[209.85.223.202]) by cuda.sgi.com with ESMTP id
	TbGMSFJGMgMUSfLe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 12:12:18 -0800 (PST)
Received: by mail-ie0-f202.google.com with SMTP id lx4so1115766iec.5
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:18 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH 04/10] xfstests: increase tmpfs memory size
Date: Tue, 10 Dec 2013 12:11:55 -0800
Message-Id: <1386706321-15795-5-git-send-email-jayr@google.com>
In-Reply-To: <1386706321-15795-1-git-send-email-jayr@google.com>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
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
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

512M is not enough for generic/129, generic/213 and generic/247.  Raise
default tmpfs size to 1G.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Junho Ryu <jayr@google.com>
---
 common/rc | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 83d56a1..57f7ccd 100644
--- a/common/rc
+++ b/common/rc
@@ -113,8 +113,8 @@ _mount_opts()
 	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
 	;;
     tmpfs)
-	# We need to specify the size at mount, use 512 MB by default
-	export MOUNT_OPTIONS="-o size=512M $TMPFS_MOUNT_OPTIONS"
+	# We need to specify the size at mount
+	export MOUNT_OPTIONS="-o size=${DEFAULT_TMPFS_SIZE_MB}M $TMPFS_MOUNT_OPTIONS"
 	;;
     *)
 	;;
@@ -168,6 +168,8 @@ _fsck_opts()
 }
 
 [ -z "$FSTYP" ] && FSTYP=xfs
+# Default tmpfs size in megabytes.
+[ -z "$DEFAULT_TMPFS_SIZE_MB" ] && DEFAULT_TMPFS_SIZE_MB=1024
 [ -z "$MOUNT_OPTIONS" ] && _mount_opts
 [ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 [ -z "$FSCK_OPTIONS" ] && _fsck_opts
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
