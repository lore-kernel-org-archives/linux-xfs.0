Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5FAE07F4E
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F6968F8066
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id w3i1vv1u6RFG16du (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext3: Speedup WB_SYNC_ALL pass
Date: Fri, 10 Oct 2014 16:23:12 +0200
Message-Id: <1412951028-4085-8-git-send-email-jack@suse.cz>
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

When doing filesystem wide sync, there's no need to force transaction
commit separately for each inode because ext3_sync_fs() takes care of
forcing commit at the end. Most of the time this slowness doesn't
manifest because previous WB_SYNC_NONE writeback doesn't leave much to
write but when there are processes aggressively creating new files and
several filesystems to sync, the sync slowness can be noticeable. In the
following test script sync(1) takes around 6 minutes when there are two
ext3 filesystems mounted on a standard SATA drive. After this patch sync
takes a couple of seconds so we have about two orders of magnitude
improvement.

function run_writers
{
  for (( i = 0; i < 10; i++ )); do
    mkdir $1/dir$i
    for (( j = 0; j < 40000; j++ )); do
      dd if=/dev/zero of=$1/dir$i/$j bs=4k count=4 &>/dev/null
    done &
  done
}

for dir in "$@"; do
  run_writers $dir
done

sleep 40
time sync

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 384b6ebb655f..14c2faf3c312 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3253,7 +3253,12 @@ int ext3_write_inode(struct inode *inode, struct writeback_control *wbc)
 		return -EIO;
 	}
 
-	if (wbc->sync_mode != WB_SYNC_ALL)
+	/*
+	 * No need to force transaction in WB_SYNC_NONE mode. Also
+	 * ext3_sync_fs() will force the commit after everything is
+	 * written.
+	 */
+	if (wbc->sync_mode != WB_SYNC_ALL || wbc->for_sync)
 		return 0;
 
 	return ext3_force_commit(inode->i_sb);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
