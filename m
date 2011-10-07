Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97MIAeK002314 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 17:18:10 -0500
Subject: Re: [PATCH 1/4] xfs: do not update xa_last_pushed_lsn for locked items
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006183549.399127499@bombadil.infradead.org>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.399127499@bombadil.infradead.org>
Date: Fri, 7 Oct 2011 17:18:05 -0500
Message-ID: <1318025885.2810.77.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Thu, 2011-10-06 at 14:32 -0400, Christoph Hellwig wrote:
> If an item was locked we should not update xa_last_pushed_lsn and thus skip
> it when restarting the AIL scan as we need to be able to lock and write it
> out as soon as possible.  Otherwise heavy lock contention might starve AIL
> pushing too easily, especially given the larger backoff once we moved
> xa_last_pushed_lsn all the way to the target lsn.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Stefan Priebe <s.priebe@profihost.ag>
> Tested-by: Stefan Priebe <s.priebe@profihost.ag>

I remember wondering about that one line during review, but
I believe I reasoned something about the "already being
reflushed or relogged" made it the right thing to do.

Your explanation makes sense though (but what do I know,
the original code seemed OK too...).

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
