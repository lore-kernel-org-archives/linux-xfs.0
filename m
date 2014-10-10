Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14B197F47
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B50AFAC010
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hTdhsxr2ZJKnH9VJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:08 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] fs: Avoid userspace mounting anon_inodefs filesystem
Date: Fri, 10 Oct 2014 16:23:22 +0200
Message-Id: <1412951028-4085-18-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

anon_inodefs filesystem is a kernel internal filesystem userspace
shouldn't mess with. Remove registration of it so userspace cannot
even try to mount it (which would fail anyway because the filesystem is
MS_NOUSER).

This fixes an oops triggered by trinity when it tried mounting
anon_inodefs which overwrote anon_inode_inode pointer while other CPU
has been in anon_inode_getfile() between ihold() and d_instantiate().
Thus effectively creating dentry pointing to an inode without holding a
reference to it.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/anon_inodes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 24084732b1d0..4b4543b8b894 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -177,9 +177,6 @@ static int __init anon_inode_init(void)
 {
 	int error;
 
-	error = register_filesystem(&anon_inode_fs_type);
-	if (error)
-		goto err_exit;
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
 	if (IS_ERR(anon_inode_mnt)) {
 		error = PTR_ERR(anon_inode_mnt);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
