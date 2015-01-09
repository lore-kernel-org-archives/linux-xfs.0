Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 316027F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 14:03:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2002D304043
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:03:09 -0800 (PST)
Received: from mail-qa0-f47.google.com (mail-qa0-f47.google.com
	[209.85.216.47]) by cuda.sgi.com with ESMTP id a7BGh33KIFcHCaHF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2015 12:03:07 -0800 (PST)
Received: by mail-qa0-f47.google.com with SMTP id f12so3519489qad.6
	for <xfs@oss.sgi.com>; Fri, 09 Jan 2015 12:03:06 -0800 (PST)
Received: from yholen.ds (rrcs-97-76-23-49.se.biz.rr.com. [97.76.23.49])
	by mx.google.com with ESMTPSA id w94sm7879929qgw.6.2015.01.09.12.03.05
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 09 Jan 2015 12:03:06 -0800 (PST)
Message-ID: <54B033ED.9010805@gmail.com>
Date: Fri, 09 Jan 2015 15:02:53 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: [RFC] xfs: remedy small writes during wrapped-log recovery
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

Hi!  I like this patch and am confident with it on x86.  However,
a) it has no x86_64 coverage; and b) xfstests xfs/306 in particular
emits more of this output:

    buffer_io_error: nnnn callbacks suppressed

Might someone evaluate this patch or the intent of the patch?

The intent:

For XFS filesystems that don't change much, such as the /boot and
alternate / partitions here, mount times were about 17s instead of
0.4s while the log is in a wrapped state, write caches off.  This 
patch fixes the issue on v4- and v5-superblock XFS filesystems.

xfs_repair can solve this issue short-term and also cut wrapped-log 
mount time in half short-term for v5 file systems.  Don't know if 
that's a mkfs.xfs issue or just coincidence.

A bisect still needs to be done to determine when the slow mount 
behavior started.  It could very well be that somebody fixed the 
buffer_io_error messages that I saw long ago, and the solution made 
some mounts here rather miserable.

Thanks!

Michael

The patch:

xlog_write_log_records() has an algorithm to "Greedily allocate a
buffer big enough...," starting with ffs(blocks), adding two sensible
checks, and then feeding it to a loop with checks of its own.

However, when blocks is an odd number, the number that becomes nbblks
to the xlog_bwrite() function ends up being 2 (1 << 1).  The most
obvious effect is that when the log wraps, a write of two odd-sized
log regions on an 8-GB XFS filesystem will take around 2049 calls 
to xlog_bwrite() instead of the "two separate I/Os" suggested in
xlog_clear_stale_blocks().

Fix this by changing the ffs(blocks) to fls(blocks).

There is a similar ffs(blocks) check in xlog_find_verify_cycle().
This was not investigated.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a5a945f..13381eb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1242,7 +1242,7 @@ xlog_write_log_records(
 	 * a smaller size.  We need to be able to write at least a
 	 * log sector, or we're out of luck.
 	 */
-	bufblks = 1 << ffs(blocks);
+	bufblks = 1 << fls(blocks);
 	while (bufblks > log->l_logBBsize)
 		bufblks >>= 1;
 	while (!(bp = xlog_get_bp(log, bufblks))) {
-- 
1.8.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
