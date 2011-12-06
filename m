Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6EhuoO230509 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 08:43:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CF701F3E107
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 06:43:52 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HoeQ1rsUCIJV3yp8 for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 06:43:52 -0800 (PST)
Date: Tue, 6 Dec 2011 09:43:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/16] xfs: remove XFS_DQ_INACTIVE
Message-ID: <20111206144350.GA16767@infradead.org>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.441012540@bombadil.infradead.org>
	<20111205042351.GN7046@dastard>
	<20111205083741.GB29401@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205083741.GB29401@infradead.org>
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

On Mon, Dec 05, 2011 at 03:37:41AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 05, 2011 at 03:23:51PM +1100, Dave Chinner wrote:
> > > +	xfs_qm_dqdestroy(dqp);
> > >  	return (0);
> > >  }
> > 
> > While there, you may as well make that a "return 0;"
> 
> Indeed.
> 
> > > -	mutex_unlock(&xqm->qm_dqfrlist_lock);
> > > -	mutex_destroy(&xqm->qm_dqfrlist_lock);
> > >  	kmem_free(xqm);
> > >  }
> > 
> > Don't we still need that mutex_destroy() call there?
> 
> We never needed it - Linux does an implicit mutex_destory when freeing
> memory containing a mutex.

Does this count as a revied-by now?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
