Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BACF67F3F
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 14:18:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B7D58F8050
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:18:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l0MkAFIoSlA8m3Uf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:17:59 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id DE7F9C0B7AA2
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 20:17:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-225.bos.redhat.com [10.18.41.225])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAPKHwjf015467
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 15:17:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/4] logprint: use correct ext. header count for unaligned size
Date: Wed, 25 Nov 2015 15:17:54 -0500
Message-Id: <1448482677-44364-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
References: <1448482677-44364-1-git-send-email-bfoster@redhat.com>
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

A log record has 1 record header and up to 7 additional extended record
headers depending on the size of the record. This is required for log
record packing. A header is required for each 32k of record data.

The header count for a particular record is fixed, based on the log
buffer size (h_size) specified in the record header. logprint calculates
the expected extended header count based on h_size, but does not account
for a log buffer size not aligned with 32k. This results in spurious
invalid header count errors for an otherwise valid log. This can be
reproduced by mounting a filesystem with '-o logbsize=16k' and running
xfs_logprint after a subsequent unmount.

Update xlog_print_extended_headers() to incorporate a non-32k aligned
log buffer size in the expected extended record header count
calculation. This is consistent with how the header count is calculated
in the kernel.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 logprint/log_misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 4cdcbec..7378fe1 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1294,6 +1294,8 @@ xlog_print_extended_headers(
 
 	num_required = howmany(len, XLOG_HEADER_CYCLE_SIZE);
 	num_hdrs = be32_to_cpu(hdr->h_size) / XLOG_HEADER_CYCLE_SIZE;
+	if (be32_to_cpu(hdr->h_size) % XLOG_HEADER_CYCLE_SIZE)
+		num_hdrs++;
 
 	if (num_required > num_hdrs) {
 	    print_xlog_bad_reqd_hdrs((*blkno)-1, num_required, num_hdrs);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
