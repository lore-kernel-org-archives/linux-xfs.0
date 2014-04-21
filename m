Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C46A7F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 11:43:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8969730404E
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 09:43:10 -0700 (PDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
	[210.118.77.11]) by cuda.sgi.com with ESMTP id Lwudvfxm9D3di3Nt
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 09:43:09 -0700 (PDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
	by mailout1.w1.samsung.com
	(Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit
	(built Nov
	17 2011)) with ESMTP id <0N4E00LQ53RUWD30@mailout1.w1.samsung.com> for
	xfs@oss.sgi.com; Mon, 21 Apr 2014 17:43:06 +0100 (BST)
Subject: [PATCH] xfstests: generic/285: fix seek_sanity_test for generic
	SEEK_HOLE/DATA
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Date: Mon, 21 Apr 2014 20:43:05 +0400
Message-id: <20140421164305.22404.92195.stgit@buzz>
MIME-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Generic implementation of SEEK_HOLE/DATA reports whole file as data chunk with
virtual hole at the end (generic_file_llseek, used by ext2/ext3/reiserfs/nfs).

Currently test prepares file smaller than expected for "huge file" testcases
(testcases 10-12). This patch fixes test file layout, now second data chunk
ends right at the expected end of file.

Plus it fixes type of 'filesz' argument, it should be off_t.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 src/seek_sanity_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index fbf5a8c..7cf45c0 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -157,7 +157,7 @@ static int do_create(const char *filename)
 	return fd;
 }
 
-static int do_lseek(int testnum, int subtest, int fd, int filsz, int origin,
+static int do_lseek(int testnum, int subtest, int fd, off_t filsz, int origin,
 		    off_t set, off_t exp)
 {
 	off_t pos, exp2;
@@ -203,7 +203,7 @@ static int huge_file_test(int fd, int testnum, off_t filsz)
 {
 	char *buf = NULL;
 	int bufsz = alloc_size * 16;	/* XFS seems to round allocated size */
-	off_t off = filsz - 2*bufsz;
+	off_t off = filsz - bufsz;
 	int ret = -1;
 
 	buf = do_malloc(bufsz);
@@ -211,6 +211,7 @@ static int huge_file_test(int fd, int testnum, off_t filsz)
 		goto out;
 	memset(buf, 'a', bufsz);
 
+	/* |- DATA -|- HUGE HOLE -|- DATA -| */
 	ret = do_pwrite(fd, buf, bufsz, 0);
 	if (ret)
 		goto out;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
