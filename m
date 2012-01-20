Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KKZ4n3125612 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 14:35:04 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id k6aZw7WDGySCGirq for <xfs@oss.sgi.com>;
	Fri, 20 Jan 2012 12:35:03 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 8/8] vfs: Document s_frozen state through freeze_super
Date: Fri, 20 Jan 2012 21:34:46 +0100
Message-Id: <1327091686-23177-9-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org, Valerie Aurora <val@vaaconsulting.com>

From: Valerie Aurora <val@vaaconsulting.com>

[kamal@canonical.com: patch restructure]
[jack@suse.cz: updated comments to reflect new situation]

Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 4aaad7e..557a4ef 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1312,6 +1312,24 @@ static void sb_freeze_to_level(struct super_block *sb, int level)
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
  * freeze_fs.  Subsequent calls to this without first thawing the fs will return
  * -EBUSY.
+ *
+ * During this function, sb->s_frozen goes through these values:
+ *
+ * SB_UNFROZEN: File system is normal, all writes progress as usual.
+ *
+ * SB_FREEZE_WRITE: The file system is in the process of being frozen.
+ * New writes should be blocked, we wait for in-progress writes (using
+ * s_writers[SB_FREEZE_WRITE-1]) and then sync the file system.
+ *
+ * SB_FREEZE_TRANS: The file system is frozen. We wait for all metadata writes
+ * to finish using s_writers[SB_FREEZE_TRANS-1] and after that call ->freeze_fs
+ * to finish filesystem freezing. After ->freeze_fs is done nothing should be
+ * dirty and all modifications are blocked until the file system is thawed.
+ *
+ * sb->s_frozen is protected by sb->s_umount.  Additionally,
+ * SB_FREEZE_WRITE is only temporarily set during freeze/thaw while
+ * holding sb->s_umount for writing, so any other callers holding
+ * sb->s_umount will never see this state.
  */
 int freeze_super(struct super_block *sb)
 {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
