Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3304E29DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:18:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D722D8F8071
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:55 -0800 (PST)
Received: from mail-gg0-f201.google.com (mail-gg0-f201.google.com
	[209.85.161.201]) by cuda.sgi.com with ESMTP id
	ek72iiSZTRkxKEaS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 14:18:54 -0800 (PST)
Received: by mail-gg0-f201.google.com with SMTP id k5so76760ggd.0
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:54 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v2 03/12] xfstests: increase tmpfs memory size
Date: Tue, 17 Dec 2013 14:18:33 -0800
Message-Id: <1387318722-3050-3-git-send-email-jayr@google.com>
In-Reply-To: <1387318722-3050-1-git-send-email-jayr@google.com>
References: <1387318722-3050-1-git-send-email-jayr@google.com>
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

v2: same as v1

 common/rc | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index c78356e..45a45b0 100644
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
