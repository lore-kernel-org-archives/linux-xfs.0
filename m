Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n83FoptX112119 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 10:51:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47DAF15C0EE2
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 08:51:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2eRd6SaI86FzSQP2 for
	<xfs@oss.sgi.com>; Thu, 03 Sep 2009 08:51:49 -0700 (PDT)
Date: Thu, 3 Sep 2009 11:48:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Mounted xfs slows down block device
Message-ID: <20090903154839.GC16715@infradead.org>
References: <alpine.LSU.2.00.0908251325410.9492@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0908251325410.9492@fbirervta.pbzchgretzou.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

Strange, as XFS doesn't actually use the block device mapping at all,
so all the caching doesn't interact with each other.  Maybe some
throtteling code in the VM doesn't like these parallel accesses.

But I need to add that reading the block device on a mounted filesystem
is not a good idea anyay - you will not get any sort of concistency
guarantee.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
