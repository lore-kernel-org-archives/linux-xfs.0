Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6KYdWa259957 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 14:34:40 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B60181A3536F
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 12:34:37 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zGSkHhfkHs0lC6FY for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 12:34:37 -0800 (PST)
Date: Wed, 7 Dec 2011 07:34:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/16] xfs: remove XFS_DQ_INACTIVE
Message-ID: <20111206203432.GE28326@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.441012540@bombadil.infradead.org>
	<20111205042351.GN7046@dastard>
	<20111205083741.GB29401@infradead.org>
	<20111206144350.GA16767@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206144350.GA16767@infradead.org>
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

On Tue, Dec 06, 2011 at 09:43:50AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 05, 2011 at 03:37:41AM -0500, Christoph Hellwig wrote:
> > On Mon, Dec 05, 2011 at 03:23:51PM +1100, Dave Chinner wrote:
> > > > +	xfs_qm_dqdestroy(dqp);
> > > >  	return (0);
> > > >  }
> > > 
> > > While there, you may as well make that a "return 0;"
> > 
> > Indeed.
> > 
> > > > -	mutex_unlock(&xqm->qm_dqfrlist_lock);
> > > > -	mutex_destroy(&xqm->qm_dqfrlist_lock);
> > > >  	kmem_free(xqm);
> > > >  }
> > > 
> > > Don't we still need that mutex_destroy() call there?
> > 
> > We never needed it - Linux does an implicit mutex_destory when freeing
> > memory containing a mutex.
> 
> Does this count as a revied-by now?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
