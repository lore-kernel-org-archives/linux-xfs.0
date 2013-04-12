Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 130F829DFA
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 10:48:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 758108F808E
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 08:48:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id q9Bd5u0rkouFXW62 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 08:48:39 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r3CFmcNF024293
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 15:48:38 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r3CFmbdY009744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 15:48:37 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r3CFma1D025844 for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 15:48:36 GMT
Message-ID: <51682CCC.308@oracle.com>
Date: Fri, 12 Apr 2013 23:48:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't return 0 if generic_segment_checks() find nothing
	to write
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

At xfs_file_aio_write(), we just return 0 which means a successfully operation if the ocount
is evaluated to 0 at generic_segment_checks().  Generally, it'll occurred if the specified
write count is 0 from the user space.  However, for example, if the given offset is over the
maximum file size limitation although nothing would be written into the file, in this case,
the underlying file system should detect this issue and return a proper errno instead.
Hence, the beginning pre-checking up against ocount would conceal some real cause and confuse
the user space program maybe.

To fix it, we can delay the write count verification until xfs_file_aio_write_checks() is done.

This test is performed on 32-bit system without CONFIG_LBADF is enabled.
Before patching:
xfs_io -f -c "pwrite 17592186040320 0" /storage/test_file
wrote 0/0 bytes at offset 17592186040320
0.000000 bytes, 0 ops; 0.0000 sec (0.000000 bytes/sec and 0.0000 ops/sec)

After patching:
xfs_io -f -c "pwrite 17592186040320 0" /storage/test_file
pwrite64: File too large

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f03bf1a..f8a933e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -671,6 +671,9 @@ xfs_file_dio_aio_write(
 	if (ret)
 		goto out;
 
+	if (ocount == 0)
+		goto out;
+
 	if (mapping->nrpages) {
 		ret = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 						    pos, -1);
@@ -725,6 +728,9 @@ xfs_file_buffered_aio_write(
 	if (ret)
 		goto out;
 
+	if (ocount == 0)
+		goto out;
+
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
@@ -772,9 +778,6 @@ xfs_file_aio_write(
 	if (ret)
 		return ret;
 
-	if (ocount == 0)
-		return 0;
-
 	sb_start_write(inode->i_sb);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
