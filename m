Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o524gpJT048328 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 23:42:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB1EF130D5AD
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 21:47:38 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	MD83QNtFAVjYNs1V for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 21:47:38 -0700 (PDT)
Date: Wed, 2 Jun 2010 14:45:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/17] xfs: drop dmapi hooks
Message-ID: <20100602044514.GD7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160859.618170031@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160859.618170031@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:31PM -0400, Christoph Hellwig wrote:
> Dmapi support was never merged upstream, but we still have a lot of hooks
> bloating XFS for it, all over the fast pathes of the filesystem.
> 
> This patch drops over 700 lines of dmapi overhead.  If we'll ever get HSM
> support in mainline at least the namespace events can be done much saner
> in the VFS instead of the individual filesystem, so it's not like this
> is much help for future work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks pretty good to me, and it runs through QA just fine.
There are still a couple of references to dmapi in comments,
but I don't think that's a big issue.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
