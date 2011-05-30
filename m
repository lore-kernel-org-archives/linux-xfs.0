Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4U8xqTd237159 for <xfs@oss.sgi.com>; Mon, 30 May 2011 03:59:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5269114DF661
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 01:59:50 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BHLuBiWh2pIuLcvL for <xfs@oss.sgi.com>;
	Mon, 30 May 2011 01:59:50 -0700 (PDT)
Date: Mon, 30 May 2011 04:59:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [git pull] dentry_unhash() breakage
Message-ID: <20110530085922.GA11336@infradead.org>
References: <20110530020604.GC561@dastard> <20110530034741.GD561@dastard>
	<Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
	<20110530055601.GK11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110530055601.GK11521@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Sage Weil <sage@newdream.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 30, 2011 at 06:56:01AM +0100, Al Viro wrote:
> A couple of dentry_unhash fallout fixes

Shouldn't we do the shrink_dcache_parent only after a successfull
rmdir or rename?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
