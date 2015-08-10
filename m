Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 700207F51
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:01:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 049A1AC004
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 12:01:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qJqHupP9zDHeVpS2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 12:01:51 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 5C7A9461DC
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 19:01:51 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7AJ1pqN005193
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 15:01:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 09/13] xfs: checksum log record ext headers based on record
	size
Date: Mon, 10 Aug 2015 15:01:45 -0400
Message-Id: <1439233309-19959-10-git-send-email-bfoster@redhat.com>
In-Reply-To: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
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

The first 4 bytes of every basic block in the physical log is stamped
with the current lsn. To support this mechanism, the log record header
(first block of each new log record) contains space for the original
first byte of each log record block before it is replaced with the lsn.
The log record header has space for 32k worth of blocks. The version 2
log adds new extended record headers for each additional 32k worth of
blocks beyond what is supported by the record header.

The log record checksum incorporates the log record header, the extended
headers and the record payload. xlog_cksum() checksums the extended
headers based on log->l_iclog_heads, which specifies the number of
extended headers in a log record based on the log buffer size mount
option. The log buffer size is variable, however, and thus means the
checksum can be calculated differently based on how a filesystem is
mounted. This is problematic if a filesystem crashes and recovery occurs
on a subsequent mount using a different log buffer size. For example,
crash an active filesystem that is mounted with the default (32k)
logbsize, attempt remount/recovery using '-o logbsize=64k' and the mount
fails on or warns about log checksum failures.

To avoid this problem, update xlog_cksum() to calculate the checksum
based on the size of the log buffer according to the log record. The
size is already included in the h_size field of the log record header
and thus is available at log recovery time. Extended log record headers
are also only written when the log record is large enough to require
them. This makes checksum calculation of log records consistent with the
extended record header mechanism as well as how on-disk records are
checksummed with various log buffer size mount options.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3a5592c..aaadee0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1672,8 +1672,13 @@ xlog_cksum(
 	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
 		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
 		int		i;
+		int		xheads;
 
-		for (i = 1; i < log->l_iclog_heads; i++) {
+		xheads = size / XLOG_HEADER_CYCLE_SIZE;
+		if (size % XLOG_HEADER_CYCLE_SIZE)
+			xheads++;
+
+		for (i = 1; i < xheads; i++) {
 			crc = crc32c(crc, &xhdr[i].hic_xheader,
 				     sizeof(struct xlog_rec_ext_header));
 		}
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
