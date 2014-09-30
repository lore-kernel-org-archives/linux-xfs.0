Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 16E567F81
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 13:22:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 061A3304048
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 11:22:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FmBmjag5kgW7C2KG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 11:22:52 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8UIMpUr007368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 14:22:51 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8UIMoMx015218
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 14:22:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix check for maximum allowable extent record file offset
Date: Tue, 30 Sep 2014 14:22:49 -0400
Message-Id: <1412101369-52751-1-git-send-email-bfoster@redhat.com>
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

The maximum allowable file size on XFS is 2^63-1 (0x7fffffffffffffff).
This value is unaligned with respect to typical order of 2 block sizes.
Therefore, the maximum allowable block offset in a file is (2^63-1) /
blocksize. xfs_repair calculates the max file offset as such in
parse_sb_version().

However, if we write to the maximum byte offset of a file:

$ xfs_io -fc "pwrite `echo "2^63-1-1" | bc` 1" /mnt/file
wrote 1/1 bytes at offset 9223372036854775806
1.000000 bytes, 1 ops; 0.0000 sec (21.230 KiB/sec and 21739.1304 ops/sec)

... xfs_repair complains that the file contains an invalid extent (4k
blocks):

...
inode 99 - extent offset too large - start 9, count 1, offset 2251799813685247
...

This occurs because xfs_repair uses a >= comparison against the start
offset of the record. Byte offset 2251799813685247 is 2^63-4096, and
thus is the maximum valid block offset in the file. Fix the comparison
to complain only if the start offset of the record is greater than the
maximum allowable start offset.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This allows xfstests test xfs/071 to pass without a post-test corruption
(repair) failure.

Brian

 repair/dinode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 38a6562..f734a18 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -667,7 +667,7 @@ _("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
 					irec.br_startoff);
 				goto done;
 		}
-		if (irec.br_startoff >= fs_max_file_offset)  {
+		if (irec.br_startoff > fs_max_file_offset)  {
 			do_warn(
 _("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
   "count %" PRIu64 ", offset %" PRIu64 "\n"),
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
