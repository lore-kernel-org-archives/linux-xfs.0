Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58JYh5L249184 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 14:34:43 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FBB68F808F
	for <xfs@oss.sgi.com>; Fri,  8 Jun 2012 12:34:40 -0700 (PDT)
Received: from [134.15.95.99] (cf-vpn-hw-arenaud-2.corp.sgi.com [134.15.95.99])
	by estes.americas.sgi.com (Postfix) with ESMTP id 1683B7001A79
	for <xfs@oss.sgi.com>; Fri,  8 Jun 2012 14:34:40 -0500 (CDT)
Message-ID: <4FD253D6.9060909@sgi.com>
Date: Fri, 08 Jun 2012 15:34:46 -0400
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: xfs_vm_writepage clear iomap_valid when !buffer_uptodate
	(REV2)
References: <20120601192207.D6DE99F997@arenaud-laptop>
	<20120605114516.GM4347@dastard> <4FCDFCE5.5020702@sgi.com>
In-Reply-To: <4FCDFCE5.5020702@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


   On filesytems with a block size smaller than PAGE_SIZE we currently have
a problem with unwritten extents.  If a we have multi-block page for
which an unwritten extent has been allocated, and only some of the
buffers have been written to, and they are not contiguous, we can expose
stale data from disk in the blocks between the writes after extent
conversion.

Example of a page with unwritten and real data.
buffer  content
0       empty  b_state = 0
1       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
2       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
3       empty  b_state = 0
4       empty  b_state = 0
5       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
6       DATA   b_state = 0x1023 Uptodate,Dirty,Mapped,Unwritten
7       empty  b_state = 0

Buffers 1, 2, 5, and 6 have been written to, leaving 0, 3, 4, and 7 empty.
Currently buffers 1, 2, 5, and 6 are added to a single ioend, and when IO has
completed, extent conversion creates a real extent from block 1 through block
6, leaving 0 and 7 unwritten.  However buffers 3 and 4 were not written to
disk, so stale data is exposed from those blocks on a subsequent read.

Fix this by setting iomap_valid = 0 when we find a buffer that is not
Uptodate.  This ensures that buffers 5 and 6 are not added to the same
ioend as buffers 1 and 2.  Later these blocks will be converted into two
separate real extents, leaving the blocks in between unwritten.

Signed-off-by: Alain Renaud <arenaud@sgi.com>

---
  fs/xfs/xfs_aops.c |   11     8 +    3 -    0 !
  1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_aops.c
===================================================================
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -981,10 +981,15 @@
                  imap_valid = 0;
              }
          } else {
-            if (PageUptodate(page)) {
+            if (PageUptodate(page))
                  ASSERT(buffer_mapped(bh));
-                imap_valid = 0;
-            }
+            /*
+             * This buffer is not uptodate and will not be
+             * written to disk.  Ensure that we will put any
+             * subsequent writeable buffers into a new
+             * ioend.
+             */
+            imap_valid = 0;
              continue;
          }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
