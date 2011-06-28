Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SFXlOH236547 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:33:48 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BC173675F
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JXaMNZvMiKyo9Kzl for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:26 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/4] Ext4: handle SEEK_HOLE/SEEK_DATA generically
Date: Tue, 28 Jun 2011 11:33:17 -0400
Message-Id: <1309275199-10801-3-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk

Since Ext4 has its own lseek we need to make sure it handles
SEEK_HOLE/SEEK_DATA.  For now just do the same thing that is done in the generic
case, somebody else can come along and make it do fancy things later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext4/file.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2c09723..ce766f9 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -236,6 +236,27 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
 		}
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+		/*
+		 * In the generic case the entire file is data, so as long as
+		 * offset isn't at the end of the file then the offset is data.
+		 */
+		if (offset >= inode->i_size) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+		break;
+	case SEEK_HOLE:
+		/*
+		 * There is a virtual hole at the end of the file, so as long as
+		 * offset isn't i_size or larger, return i_size.
+		 */
+		if (offset >= inode->i_size) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+		offset = inode->i_size;
+		break;
 	}
 
 	if (offset < 0 || offset > maxbytes) {
-- 
1.7.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
