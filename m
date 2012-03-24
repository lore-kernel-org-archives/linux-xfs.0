Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ODmD6I029250 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 08:48:14 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	eAKMlAK44vfjfZeQ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 06:48:12 -0700 (PDT)
Date: Sat, 24 Mar 2012 09:48:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: allow assigning the tail lsn with the AIL lock
	held
Message-ID: <20120324134811.GB4674@infradead.org>
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175636.373605151@bombadil.infradead.org>
	<20120321232956.GA5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120321232956.GA5091@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 10:29:56AM +1100, Dave Chinner wrote:
> On Fri, Mar 16, 2012 at 01:55:44PM -0400, Christoph Hellwig wrote:
> > Provide a variant of xlog_assign_tail_lsn that has the AIL lock already
> > held.  By doing so we do an additional atomic_read + atomic_set under
> > the lock, which comes down to two instructions.
> > 
> > Switch xfs_trans_ail_update_bulk and xfs_trans_ail_delete_bulk to the
> > new version to reduce the number of lock roundtrips, and prepare for
> > a new addition that would require a third lock roundtrip in
> > xfs_trans_ail_delete_bulk.
> 
> What new addition is that? I don't see it in this patchset (maybe
> I'm just blind), so maybe this isn't necessary in the commit
> message?

The check for an empty AIL before waking up thread thread waiting for
it.  I'll add it to the commit log.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
