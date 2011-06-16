Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GGWwJ7046272 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 11:32:58 -0500
Subject: Re: [PATCH v2] xfs: make log devices with write back caches work
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110616120223.GA9854@infradead.org>
References: <20110616120223.GA9854@infradead.org>
Date: Thu, 16 Jun 2011 11:32:54 -0500
Message-ID: <1308241974.2717.1.camel@doink>
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
Cc: xfs@oss.sgi.com

On Thu, 2011-06-16 at 08:02 -0400, Christoph Hellwig wrote:
> There's no reason not to support cache flushing on external log devices.
> The only thing this really requires is flushing the data device first
> both in fsync and log commits.  A side effect is that we also have to
> remove the barrier write test during mount, which has been superflous
> since the new FLUSH+FUA code anyway.  Also use the chance to flush the
> RT subvolume write cache before the fsync commit, which is required
> for correct semantics.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for the explanations and update.  This looks good.
I'm testing now and barring a problem should be to Linus
this weekend.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
