Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17IBuqt250492 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 12:11:56 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6XXEGwsmshlRcVn6 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 10:11:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RupWE-00026r-SX
	for xfs@oss.sgi.com; Tue, 07 Feb 2012 18:11:54 +0000
Message-Id: <20120207181037.745771452@bombadil.infradead.org>
Date: Tue, 07 Feb 2012 13:10:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] RFC: log all inode updates
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

This is my current state of the series to log all inode updates.  I
haven't really touched it for a while, and it's been solid in testing.
What is still missing is putting back an fdatasync that is optimized
over fsync, so this isn't quite ready for primetime yet.  But given
that the existing patches shouldn't change additional review and testing
is more than welcome.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
