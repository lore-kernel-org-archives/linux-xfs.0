Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p54E8xgj084161 for <xfs@oss.sgi.com>; Sat, 4 Jun 2011 09:09:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A370D76435
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2011 07:08:56 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7lxQCNFvstscwyG3 for <xfs@oss.sgi.com>;
	Sat, 04 Jun 2011 07:08:56 -0700 (PDT)
Date: Sat, 4 Jun 2011 10:08:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/12] superblock: introduce per-sb cache shrinker
	infrastructure
Message-ID: <20110604140848.GA20404@infradead.org>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-9-git-send-email-david@fromorbit.com>
	<20110604004231.GV11521@ZenIV.linux.org.uk>
	<20110604015212.GD561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110604015212.GD561@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 11:52:12AM +1000, Dave Chinner wrote:
> I wanted to put it early on in the unmount path so that the shrinker
> was guaranteed to be gone before evict_inodes() was called. That
> would mean that it is obviously safe to remove the iprune_sem
> serialisation in that function.

The iprune_sem removal is fine as soon as you have a per-sb shrinker
for the inodes which keeps an active reference on the superblock until
all the inodes are evicted.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
