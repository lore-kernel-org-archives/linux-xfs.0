Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8DD37F80
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 59738AC01E
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id DHrYzolVsejROy6s (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH RESEND] vfs: Return EINVAL for default SEEK_HOLE,
	SEEK_DATA implementation
Date: Fri, 10 Oct 2014 16:23:40 +0200
Message-Id: <1412951028-4085-36-git-send-email-jack@suse.cz>
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

Generic implementation of SEEK_HOLE & SEEK_DATA in
generic_file_llseek_size() and default_llseek() behaved as if everything
within i_size is data and everything beyond i_size is a hole. That makes
sense at the first sight (and definitely is a valid implementation of
the spec) but at the second sight it isn't very useful. If anyone
bothers with looking for holes / data, he should be better told we don't
really know so that he can fall back to his chosen backup strategy
(think of e.g. cp(1)).

This is a userspace API change however the kernel interface is there
only for two years so hopefully userspace is still prepared to handle
EINVAL return value.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/read_write.c | 38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

Al, what do you think about this change?

diff --git a/fs/read_write.c b/fs/read_write.c
index edc5746a902a..71525d75742f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -111,22 +111,8 @@ generic_file_llseek_size(struct file *file, loff_t offset, int whence,
 		spin_unlock(&file->f_lock);
 		return offset;
 	case SEEK_DATA:
-		/*
-		 * In the generic case the entire file is data, so as long as
-		 * offset isn't at the end of the file then the offset is data.
-		 */
-		if (offset >= eof)
-			return -ENXIO;
-		break;
 	case SEEK_HOLE:
-		/*
-		 * There is a virtual hole at the end of the file, so as long as
-		 * offset isn't i_size or larger, return i_size.
-		 */
-		if (offset >= eof)
-			return -ENXIO;
-		offset = eof;
-		break;
+		return -EINVAL;
 	}
 
 	return vfs_setpos(file, offset, maxsize);
@@ -214,28 +200,8 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			offset += file->f_pos;
 			break;
 		case SEEK_DATA:
-			/*
-			 * In the generic case the entire file is data, so as
-			 * long as offset isn't at the end of the file then the
-			 * offset is data.
-			 */
-			if (offset >= inode->i_size) {
-				retval = -ENXIO;
-				goto out;
-			}
-			break;
 		case SEEK_HOLE:
-			/*
-			 * There is a virtual hole at the end of the file, so
-			 * as long as offset isn't i_size or larger, return
-			 * i_size.
-			 */
-			if (offset >= inode->i_size) {
-				retval = -ENXIO;
-				goto out;
-			}
-			offset = inode->i_size;
-			break;
+			return -EINVAL;
 	}
 	retval = -EINVAL;
 	if (offset >= 0 || unsigned_offsets(file)) {
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
