Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KFgRRj098247 for <xfs@oss.sgi.com>; Fri, 20 May 2011 10:42:27 -0500
Subject: Re: [PATCH 1/4 v2] xfs: add online discard support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110520134531.GA30013@infradead.org>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.156999943@bombadil.infradead.org>
	<20110520134531.GA30013@infradead.org>
Date: Fri, 20 May 2011 10:42:23 -0500
Message-ID: <1305906143.1964.10.camel@doink>
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

On Fri, 2011-05-20 at 09:45 -0400, Christoph Hellwig wrote:
> Now that we have reliably tracking of deleted extents in a transaction
> we can easily implement "online" discard support which calls
> blkdev_issue_discard once a transaction commits.
> 
> The actual discard is a two stage operation as we first have to mark
> the busy extent as not available for reuse before we can start the
> actual discard.  Note that we don't bother supporting discard for
> the non-delaylog mode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Given Lukas' note about EOPNOTSUPP getting reported only
if 100% of the underlying storage does not (at the moment)
support discard:
- You might as well drop out of the loop in xfs_discard_extents()
  once EOPNOTSUPP gets reported for any extent.
- It might be nice to report something the first time that
  happens on a particular mount point, record that fact,
  then report again if it begins to *not* happen at some
  point thereafter (due to the underlying support being
  changed via dmsetup while still mounted).

But I'm not going to wait for that.  I'll take in this
patch as-is and if you care to act on those suggestions
will rely on you to do so by sending a new patch.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
