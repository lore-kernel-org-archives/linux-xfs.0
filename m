Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8415C7F5A
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 09:39:15 -0600 (CST)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DA5E8F8039
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 07:39:15 -0800 (PST)
Message-Id: <20130129153915.237058478@sgi.com>
Date: Tue, 29 Jan 2013 09:39:17 -0600
From: rjohnston@sgi.com
Subject: [PATCH 3/3] --- sys-utils/mount.8 | 12 ++++++++++++ 1 file changed,
	12 insertions(+)
References: <20130129153914.801475275@sgi.com>
Content-Disposition: inline;
	filename=util-linux-add-xfs-agskip-mount-option.patch
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

Index: b/sys-utils/mount.8
===================================================================
--- a/sys-utils/mount.8
+++ b/sys-utils/mount.8
@@ -2587,6 +2587,18 @@ None.
 
 .SH "Mount options for xfs"
 .TP
+.BI agskip= value
+Specifies the allocation group, (AG) for a new file, relative to the
+start of the last created file. agskip has the opposite effect of the
+rotorstep system tunable parameter.  Each new file to be placed in the
+location lastAG + agskipValue, where lastAG is the allocation group
+of the last created file.
+
+For example, agskip=3 means each new file will be allocated three AGs
+away from the starting AG of the most recently created file.
+
+The agskip mount option disables the rotorstep system tunable parameter.
+.TP
 .BI allocsize= size
 Sets the buffered I/O end-of-file preallocation size when
 doing delayed allocation writeout (default size is 64KiB).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
