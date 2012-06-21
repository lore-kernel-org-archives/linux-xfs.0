Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5L7BfeY006734 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 02:11:43 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CAkiIEp2NE1yIg3M (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 00:11:38 -0700 (PDT)
Date: Thu, 21 Jun 2012 03:11:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120621071135.GA5106@infradead.org>
References: <1339087793-45731-1-git-send-email-bfoster@redhat.com>
	<20120620080523.GA26167@infradead.org>
	<4FE1F37E.6090706@redhat.com> <20120620223548.GK30705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620223548.GK30705@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Jun 21, 2012 at 08:35:48AM +1000, Dave Chinner wrote:
> writes are single instructions on 64 bit systems. The lock is
> required for 32 bit systems because the write requires separate 32
> bit writes to the LSN which can result in unlocked accesses seeing
> partially updated (and hence incorrect) LSN values.
> 
> So the memory barriers are definitely needed for 64 bit machines
> because there is no locking on the update and spinlocks only provide
> memory barriers via unlock->lock transitions, not via a single
> spin_lock() call.

Indeed.  So we'll either need the barriers, or just always take xa_lock
in xfs_ail_push.  Given that xa_lock and xa_target appear in the same
cache line it probably wouldn't even make much of a difference.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
