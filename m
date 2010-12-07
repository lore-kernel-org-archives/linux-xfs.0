Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7AG0P5130685 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 04:16:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE3EF1C9DEC0
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 02:17:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zgCck5NhE37CF9WS for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 02:17:48 -0800 (PST)
Date: Tue, 7 Dec 2010 05:17:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: dynamic speculative EOF preallocation
Message-ID: <20101207101746.GB25995@infradead.org>
References: <1290991431-20519-1-git-send-email-david@fromorbit.com>
	<1290991431-20519-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290991431-20519-2-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

I need the patch below to make the new code link on 32-bit systems:

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2010-12-07 11:01:50.394021585 +0100
+++ xfs/fs/xfs/xfs_mount.c	2010-12-07 11:02:46.231256257 +0100
@@ -1111,7 +1111,10 @@ xfs_set_low_space_thresholds(
 	int i;
 
 	for (i = 0; i < XFS_LOWSP_MAX; i++) {
-		mp->m_low_space[i] = mp->m_sb.sb_dblocks / 100 * (i + 1);
+		__uint64_t space = mp->m_sb.sb_dblocks;
+		do_div(space, 100);
+
+		mp->m_low_space[i] = space * (i + 1);
 	}
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
