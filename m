Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C2fkbE209481 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 20:41:46 -0600
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH] xfs: show uuid when mount fails due to duplicate uuid
Date: Thu, 12 Jan 2012 11:47:20 +0900
Message-ID: <20120112024720.3952.73517.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>
Cc: Alex Elder <elder@kernel.org>, Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, yrl.pp-manager.tt@hitachi.com

When a system tries to mount a filesystem (FS) using UUID, the xfs
returns -EINVAL and shows a message if a FS with the same UUID has
been already mounted. It is useful to output the duplicate UUID
with it.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
---

 fs/xfs/xfs_mount.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..6b96d6e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -158,7 +158,10 @@ xfs_uuid_mount(
 
  out_duplicate:
 	mutex_unlock(&xfs_uuid_table_mutex);
-	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
+	xfs_warn(mp,
+		"Filesystem has duplicate UUID - can't mount: uuid = %pU",
+		uuid);
+
 	return XFS_ERROR(EINVAL);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
