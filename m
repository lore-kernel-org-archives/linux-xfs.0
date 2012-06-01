Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51JMHUs172273 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 14:22:17 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF88C30408E
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 12:22:13 -0700 (PDT)
Received: from arenaud-laptop (cf-vpn-hw-arenaud-1.corp.sgi.com [134.15.95.98])
	by estes.americas.sgi.com (Postfix) with ESMTP id 478E17001DD2
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 14:22:13 -0500 (CDT)
From: Alain Renaud <arenaud@sgi.com>
Date: Fri, 1 Jun 2012 15:18:26 -0400
Subject: [PATCH] xfs: using extsize cause corruption with multi buffer page.
Message-Id: <20120601192207.D6DE99F997@arenaud-laptop>
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
To: xfs@oss.sgi.com

  This mod make sure that buffer in a xfs_ioend are all in the
same extent. This is actually similar to what is done in
xfs_convert_page() already.

This solve the problem of having multiple extent in one page.

With the current kernel if we have a page that look like this:
buffer  content
0       empty  b_state = 0
1       DATA   b_state = 0x1023
2       DATA   b_state = 0x1023
3       empty  b_state = 0
4       empty  b_state = 0
5       DATA   b_state = 0x1023
6       DATA   b_state = 0x1023
7       empty  b_state = 0


We endup with buffer 1-4 been tag as real and 5-EOF tag as unwritten.
Instead of 1-2 real, 3-4 unwritten, 5-6 real, 7-EOF unwritten.

Signed-off-by: Alain Renaud <arenaud@sgi.com>

---
 fs/xfs/xfs_aops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ae31c31..88df6cb 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -896,6 +896,7 @@ xfs_vm_writepage(
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
 	int			nonblocking = 0;
+	int			new_ioend = 0;
 
 	trace_xfs_writepage(inode, page, 0);
 
@@ -947,7 +948,6 @@ xfs_vm_writepage(
 		nonblocking = 1;
 
 	do {
-		int new_ioend = 0;
 
 		if (offset >= end_offset)
 			break;
@@ -962,6 +962,7 @@ xfs_vm_writepage(
 		 */
 		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
 			imap_valid = 0;
+			new_ioend = 1;
 			continue;
 		}
 
@@ -985,6 +986,7 @@ xfs_vm_writepage(
 				ASSERT(buffer_mapped(bh));
 				imap_valid = 0;
 			}
+			new_ioend = 1;
 			continue;
 		}
 
@@ -1013,6 +1015,7 @@ xfs_vm_writepage(
 			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
 					 new_ioend);
 			count++;
+			new_ioend = 0;
 		}
 
 		if (!iohead)
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
