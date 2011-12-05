Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB58biT7122636 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 02:37:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 960FA107D91D
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 00:37:42 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	u2k4kqF85J9yDW3q for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 00:37:42 -0800 (PST)
Date: Mon, 5 Dec 2011 03:37:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/16] xfs: remove XFS_DQ_INACTIVE
Message-ID: <20111205083741.GB29401@infradead.org>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.441012540@bombadil.infradead.org>
	<20111205042351.GN7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205042351.GN7046@dastard>
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

On Mon, Dec 05, 2011 at 03:23:51PM +1100, Dave Chinner wrote:
> > +	xfs_qm_dqdestroy(dqp);
> >  	return (0);
> >  }
> 
> While there, you may as well make that a "return 0;"

Indeed.

> > -	mutex_unlock(&xqm->qm_dqfrlist_lock);
> > -	mutex_destroy(&xqm->qm_dqfrlist_lock);
> >  	kmem_free(xqm);
> >  }
> 
> Don't we still need that mutex_destroy() call there?

We never needed it - Linux does an implicit mutex_destory when freeing
memory containing a mutex.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
