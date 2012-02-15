Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1F2VoPu142352 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 20:31:50 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6647mkLdwzOXXmTH (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Feb 2012 18:31:49 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RxUeq-0004SI-EW
	for xfs@oss.sgi.com; Wed, 15 Feb 2012 02:31:48 +0000
Message-Id: <20120215023148.399729881@bombadil.infradead.org>
Date: Tue, 14 Feb 2012 21:29:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/9] quota: make Q_XQUOTASYNC a noop
References: <20120215022926.577682146@bombadil.infradead.org>
Content-Disposition: inline; filename=quota-disable-Q_XQUOTASYNC
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Now that XFS takes quota reservations into account there is no need to flush
anything before reporting quotas - in addition to beeing fully transactional
all quota information is also 100% coherent with the rest of the filesystem
now.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/quota/quota.c
===================================================================
--- xfs.orig/fs/quota/quota.c	2012-02-02 13:06:30.693396524 +0100
+++ xfs/fs/quota/quota.c	2012-02-02 13:23:23.181244741 +0100
@@ -282,10 +282,9 @@ static int do_quotactl(struct super_bloc
 	case Q_XGETQUOTA:
 		return quota_getxquota(sb, type, id, addr);
 	case Q_XQUOTASYNC:
-		/* caller already holds s_umount */
 		if (sb->s_flags & MS_RDONLY)
 			return -EROFS;
-		writeback_inodes_sb(sb, WB_REASON_SYNC);
+		/* XFS quotas are fully coherent now, making this call a noop */
 		return 0;
 	default:
 		return -EINVAL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
