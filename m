Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q66060xp112365 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 19:06:00 -0500
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id iO8ZGNXiRCddKQqZ for
	<xfs@oss.sgi.com>; Thu, 05 Jul 2012 17:05:58 -0700 (PDT)
Date: Thu, 5 Jul 2012 17:05:56 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
Subject: Re: [PATCH 0/5] do not take the iolock in inode reclaim context
In-Reply-To: <20120704151328.928543446@bombadil.infradead.org>
Message-ID: <Pine.LNX.4.64.1207051702290.21201@cobra.newdream.net>
References: <20120704151328.928543446@bombadil.infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: sage@newdream.net, xfs@oss.sgi.com

Hi Christoph,

On Wed, 4 Jul 2012, Christoph Hellwig wrote:
> This series should fix the (false-positive) lockdep warnings Sage
> has seen while testing ceph workloads with heavy attr usage.

I tried this out (minus the last patch, which didn't apply to 
linus/master) and it does make the warnings go away, thanks!  I'll run it 
through a larger test run to make sure nothing else comes up.
 
> Btw, you probably should create the XFS filesystems for Ceph usage
> with large inodes to avoid going out of line for the attributes.

Oh, right.  The qa stuff is still just doing mkfs.xfs defaults.

Thanks!
sage

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
