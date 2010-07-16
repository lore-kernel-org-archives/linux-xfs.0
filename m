Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6G5KWWe246111 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 00:20:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC69D44F726
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:23:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PLLsMwWAvUeWT7Je for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 22:23:29 -0700 (PDT)
Date: Fri, 16 Jul 2010 01:23:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] xfs: reclaim bug fixes
Message-ID: <20100716052329.GF29915@infradead.org>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279154300-2018-1-git-send-email-david@fromorbit.com>
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

On Thu, Jul 15, 2010 at 10:38:15AM +1000, Dave Chinner wrote:
> The following patches fix excessive CPU consumption during inode
> cache shrinking when filesystems have lots of allocation groups as
> well as prevent a couple of lockdep reports that were found during
> testing. Also included is a fix for a reclaim recursion deadlock
> when allocating memory during inode initialisation.

Wa the overlap of patch 1 with the for-2.6.35 shrinker series
intentional?  In addition to patch 1 patches 3 to 5 are also for-2.6.35
material in my opinion.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
