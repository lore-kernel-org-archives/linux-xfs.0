Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OH8n22068890 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 12:08:49 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iA1HftKMYvgICq9W (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Mar 2012 10:08:48 -0700 (PDT)
Date: Sat, 24 Mar 2012 13:08:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: implement freezing by emptying the AIL
Message-ID: <20120324170848.GA32591@infradead.org>
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175636.554421689@bombadil.infradead.org>
	<20120321235738.GB5091@dastard>
	<20120324170618.GD21708@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120324170618.GD21708@infradead.org>
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

On Sat, Mar 24, 2012 at 01:06:18PM -0400, Christoph Hellwig wrote:
> On Thu, Mar 22, 2012 at 10:57:38AM +1100, Dave Chinner wrote:
> > > +	 * threshold.
> > > +	 */
> > > +	if (atomic_read(&ailp->xa_wait_empty))
> > > +		target = xfs_ail_max(ailp)->li_lsn;
> > 
> > I don't think this is safe - we may have finished pushing the AIL to
> > empty, but the waiter that decrements xa_wait_empty may not have run
> > yet and we can race with that. In that case, xfs_ail_max() will
> > return NULL as the AIL is empty.
> 
> True - I'll add a check for that.

Actually - we do the xfs_trans_ail_cursor_first check just above - if
the AIL is empty we'll already exit after that and never reach this
code, so we should be fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
