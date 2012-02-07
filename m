Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17IT4NO251639 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 12:29:04 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ObeXz7E6IC2FSU4Z (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 10:29:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Rupmo-0005se-GD
	for xfs@oss.sgi.com; Tue, 07 Feb 2012 18:29:02 +0000
Date: Tue, 7 Feb 2012 13:29:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: rfc: drop support for historic fs formats from xfsprogs
Message-ID: <20120207182902.GA22486@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

While doing a lot of xfs_repair work I noticed that there's a lot of
effort spent on handling historic filesystem features.  The two that
make my life in repair hard are mostly:

 - unaligned inodes
 - dirv1

none of which every made it to production on Linux.  I'd like to suggest
to drop support for old filesystem features before a certain cut off
date after we release the currently pending xfsprogs 3.1.8 release.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
