Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGkkb6128383 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:46 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yxRvsir1AHZ3N05y (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXg-00078u-4O
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:44 +0000
Message-Id: <20120327164400.967415009@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/10] remove xfsbufd
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

Now that we all dirty metadata is tracked in the AIL, and except for few
special cases only written through it there is no point to keep the current
delayed buffers list and xfsbufd around.

This series remove a few more of the remaining special cases and then
replaced the global delwri buffer list with a local on-stack one.  The
main consumer is xfsaild, which is used more often now.

Besides removing a lot of code this change reduce buffer cache lookups
on loaded systems from xfsaild because we can figure out that a buffer
already is under writeback entirely locally now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
