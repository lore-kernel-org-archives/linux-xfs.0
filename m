Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB140nKR168886 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 22:00:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C2E6140122D
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:02:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	W7W24iggBrlJMQem for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 20:02:29 -0800 (PST)
Date: Wed, 1 Dec 2010 15:02:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfs: remove some dead bio handling code
Message-ID: <20101201040226.GC16922@dastard>
References: <20101122130506.868076797@bombadil.infradead.org>
	<20101122130903.350647429@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101122130903.350647429@bombadil.infradead.org>
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

On Mon, Nov 22, 2010 at 08:05:08AM -0500, Christoph Hellwig wrote:
> We'll never have BIO_EOPNOTSUPP set after calling submit_bio as
> this can only happen for discards, and used to happen for barriers,
> none of which is every submitted by xfs_submit_ioend_bio.  Also
> remove the loop around bio_alloc as it will never fail due to it's
> mempool backing.
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
