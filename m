Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F04Qj5155155 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 19:04:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2323917F509A
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:05:13 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	aZP0RSFwZjMfFMoM for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 17:05:13 -0700 (PDT)
Date: Wed, 15 Sep 2010 10:05:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/18] xfs: add a lru to the XFS buffer cache
Message-ID: <20100915000511.GH15695@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-18-git-send-email-david@fromorbit.com>
	<20100914231644.GB29338@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100914231644.GB29338@infradead.org>
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

On Tue, Sep 14, 2010 at 07:16:44PM -0400, Christoph Hellwig wrote:
> 
> Looks correct to me, although probably indeed a bit simplistic.
>
> > +		/* add to LRU */
> > +		spin_lock(&btp->bt_lru_lock);
> > +		list_add_tail(&new_bp->b_lru, &btp->bt_lru);
> > +		btp->bt_lru_nr++;
> > +		atomic_inc(&new_bp->b_hold);
> > +		spin_unlock(&btp->bt_lru_lock);
> 
> Just for clarity it would be nice to have this as an xfs_buf_lru_add
> helper.
> 
> > +			/* remove from LRU */
> > +			spin_lock(&btp->bt_lru_lock);
> > +			list_del_init(&bp->b_lru);
> > +			btp->bt_lru_nr--;
> > +			spin_unlock(&btp->bt_lru_lock);
> 
> And this ad xfs_buf_lru_del.

Yes, will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
