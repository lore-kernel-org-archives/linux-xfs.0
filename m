Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F7EA7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 13:23:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 071D6304053
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 11:22:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2yDOa8ogaaD56sjk for
	<xfs@oss.sgi.com>; Fri, 28 Feb 2014 11:22:57 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1SJMqAb000400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 14:22:52 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1SJMpqb016097
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 14:22:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: check all buffers in xfs_check_page_type()
Date: Fri, 28 Feb 2014 14:22:49 -0500
Message-Id: <1393615369-41882-1-git-send-email-bfoster@redhat.com>
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

xfs_aops_discard_page() was introduced in the following commit:

  xfs: truncate delalloc extents when IO fails in writeback

... to clean up left over delalloc ranges after I/O failure in
->writepage(). generic/224 tests for this scenario and occasionally
reproduces panics on sub-4k blocksize filesystems.

The cause of this is failure to clean up the delalloc range on a
page where the first buffer does not match one of the expected
states of xfs_check_page_type(). If a buffer is not unwritten,
delayed or dirty&mapped, xfs_check_page_type() stops and
immediately returns 0.

The stress test of generic/224 creates a scenario where the first
several buffers of a page with delayed buffers are mapped&uptodate
and some subsequent buffer is delayed. If the ->writepage() happens
to fail for this page, xfs_aops_discard_page() incorrectly skips
the entire page.

Modify xfs_aops_discard_page() to iterate all of the page buffers
to ensure a delayed buffer does not go undetected.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

The only other caller to xfs_check_page_type() is xfs_convert_page(). I
think this is safe with respect to that codepath, given the additional
imap checks therein and whatnot, but thoughts appreciated.

Brian

 fs/xfs/xfs_aops.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index db2cfb0..5962a9f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -655,8 +655,6 @@ xfs_check_page_type(
 				acceptable += (type == XFS_IO_DELALLOC);
 			else if (buffer_dirty(bh) && buffer_mapped(bh))
 				acceptable += (type == XFS_IO_OVERWRITE);
-			else
-				break;
 		} while ((bh = bh->b_this_page) != head);
 
 		if (acceptable)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
