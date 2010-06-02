Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o525Bvgh052179 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 00:11:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC5DD1B15F6E
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 22:14:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	iutwIblgCFOLrJs9 for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 22:14:23 -0700 (PDT)
Date: Wed, 2 Jun 2010 15:14:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/17] xfs: merge iop_unpin_remove into iop_unpin
Message-ID: <20100602051421.GG7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160900.602159529@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160900.602159529@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:34PM -0400, Christoph Hellwig wrote:
> The unpin_remove item operation instances always share most of the
> implementation with the respective unpin implementation.  So instead
> of keeping two different entry points add a remove flag to the unpin
> operation and share the code more easily.
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
