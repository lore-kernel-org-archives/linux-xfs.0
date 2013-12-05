Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 873DE7F5E
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 15:04:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 612C8304051
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 13:04:04 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5dH0sf7RA5FclTPT for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 13:04:02 -0800 (PST)
Date: Fri, 6 Dec 2013 08:03:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: use xfs_ilock_map_shared in xfs_qm_dqtobp
Message-ID: <20131205210356.GE29897@dastard>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.330689967@bombadil.infradead.org>
	<20131205204108.GB29897@dastard>
	<20131205205345.GA12393@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205205345.GA12393@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 05, 2013 at 12:53:45PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2013 at 07:41:08AM +1100, Dave Chinner wrote:
> > However, it raises a bigger question about dquot allocation sanity
> > to me: what makes the map returned valid after we've unlocked the
> > extent list?
> > 
> > We then use it to determine whether to allocate a
> > dquot or not, and xfs_qm_dqalloc() then does this after calling
> > xfs_bmapi_write():
> > 
> > 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> > 	       (map.br_startblock != HOLESTARTBLOCK));
> > 
> > What's to prevent someone coming in between the xfs_bmapi_read()
> > and *write() calls and allocating a different dquot in the same
> > cluster and therefore beating the first thread to the allocation?
> > 
> > This read/write race exists elsewhere - e.g. xfs_iomap_write_allocate
> > documents it for the data path - and it has to be specifically
> > handled to prevent corruption.....
> 
> Yeah, we'll need to read-read the extent map in xfs_qm_dqalloc. I  I
> think this is efficiently paper over by the buffer lock - we take
> it right after the xfs_bmapi_write over the period of initialization
> the on-disk dquots and copying the one we were called for into the
> in-memory one.  So while we might have been corrupting dquots all
> over no one has noticed because we had a non-corrupted version
> in-memory that overwrote the corrupted one again later.  Uhh..

Hmmm - I didn't think of the "rewrite dquot form memory into buffer"
aspect of it. That makes it even more subtle and less likely to be
seen unless we crash at exactly the wrong time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
