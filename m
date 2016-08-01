Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E26197D2A
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 14:00:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1C5D30405F
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 12:00:51 -0700 (PDT)
Received: from mx144.netapp.com (mx144.netapp.com [216.240.21.25]) by
	cuda.sgi.com with ESMTP id DgJYZdtxvljDPyNg (version=TLSv1.2
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Aug 2016 12:00:49 -0700 (PDT)
From: Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: [PATCH] xfs_io: Update man page for copy_range command
Date: Mon, 1 Aug 2016 15:00:42 -0400
Message-ID: <20160801190042.8652-1-Anna.Schumaker@Netapp.com>
MIME-Version: 1.0
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
To: david@fromorbit.com
Cc: anna.schumaker@netapp.com, xfs@oss.sgi.com

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
---
 man/man8/xfs_io.8 | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index b0300bb..2c56f09 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -556,6 +556,39 @@ Print timing statistics in a condensed format.
 .TP
 .B \-q
 Do not print timing statistics at all.
+.RE
+.PD
+.TP
+.TP
+.BI "copy_range [ -s " src_offset " ] [ -d " dst_offset " ] [ -l " length " ] src_file"
+On filesystems that support the
+.BR copy_file_range (2)
+system call, copies data from the
+.I src_file
+into the open file.  If
+.IR src_offset ,
+.IR dst_offset ,
+and
+.I length
+are omitted the contents of src_file will be copied to the beginning of the
+open file, overwriting any data already there.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-s
+Copy data from
+.I src_file
+beginning from
+.IR src_offset .
+.TP
+.B \-d
+Copy data into the open file beginning at
+.IR dst_offset .
+.TP
+.B \-l
+Copy up to
+.I length
+bytes of data.
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP
-- 
2.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
