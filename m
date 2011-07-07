Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67809wW140787 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 03:00:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43AEF52501
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 01:00:08 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BpXZPcd8ijVpYQ8V for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 01:00:08 -0700 (PDT)
Date: Thu, 7 Jul 2011 04:00:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/27] xfs: use generic get_unaligned_beXX helpers
Message-ID: <20110707080006.GA14041@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.763430916@bombadil.infradead.org>
	<20110706034421.GQ1026@dastard>
	<20110706090754.GI19861@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706090754.GI19861@infradead.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

One interestin caveat about inode numers is that the we use the
XFS_DIR2_DATA_FREE_TAG magic number in the firt two bytes of
struct xfs_dir2_data_unused to detect this free space header in all
non-shortform directory formats.  These two bytes overlap with
the inode number in struct xfs_dir2_data_entry.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
