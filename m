Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3674B7F58
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 05:58:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FD148F8035
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 03:58:27 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id LMX1EhC7Jc4sErAA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 03:58:25 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/12] xfs: Set allowed quota types
Date: Tue,  4 Nov 2014 12:19:45 +0100
Message-Id: <1415099993-18034-5-git-send-email-jack@suse.cz>
In-Reply-To: <1415099993-18034-1-git-send-email-jack@suse.cz>
References: <1415099993-18034-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

We support user, group, and project quotas. Tell VFS about it.

CC: xfs@oss.sgi.com
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9f622feda6a4..206b97fd1d8a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1425,6 +1425,7 @@ xfs_fs_fill_super(
 	sb->s_export_op = &xfs_export_operations;
 #ifdef CONFIG_XFS_QUOTA
 	sb->s_qcop = &xfs_quotactl_operations;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	sb->s_op = &xfs_super_operations;
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
