Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U6b4tl187025 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:37:04 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AB844C287F
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 23:37:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qrtqXKVAHBBDNP7d for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 23:37:02 -0700 (PDT)
Date: Thu, 30 Jun 2011 16:36:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/27] patch queue for Linux 3.1
Message-ID: <20110630063658.GI561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140109.003209430@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Wed, Jun 29, 2011 at 10:01:09AM -0400, Christoph Hellwig wrote:
> This is my current patch queue for Linux 3.1.  It includes the previously
> all previously sent patches I'm planning for Linux 3.1 inclusion through
> the XFS tree and a few new ones.  The most important new bits is a cleanup
> of the structures describing the dir2 on-disk format, which got a bit
> more urgent due to more recent gcc versions complaining about the hacks
> used in the current version.
> 
> The sync lifelock fix is included only in a minimal version that removes
> the data syncs.  I plan to sort out the iocount waiting via the i_alloc_sem
> removal patches that have been sent for inclusion in the VFS tree.  I'll
> cc the XFS list on the updated version with XFS chances.

With this series I'm seeing test 180 fail relatively frequently with
1k block size filesystem. I shall try to debug this given the other
reports of 180 failing that have recently come to light...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
