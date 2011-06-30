Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U2C3Na165278 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 21:12:03 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3B1C4C280D
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 19:12:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1HAknkIPsdBdFZiC for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 19:12:01 -0700 (PDT)
Date: Thu, 30 Jun 2011 12:11:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/27] xfs: split xfs_setattr
Message-ID: <20110630021159.GA561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140337.641422449@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140337.641422449@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:15AM -0400, Christoph Hellwig wrote:
> Split up xfs_setattr into two functions, one for the complex truncate
> handling, and one for the trivial attribute updates.  Also move both
> new routines to xfs_iops.c as they are fairly Linux-specific.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
