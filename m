Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBSLdnKp225924 for <xfs@oss.sgi.com>; Wed, 28 Dec 2011 15:39:51 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wy7VAOyS6wG2xXfO for <xfs@oss.sgi.com>;
	Wed, 28 Dec 2011 13:39:48 -0800 (PST)
Date: Wed, 28 Dec 2011 16:39:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] xfs: log the inode in ->write_inode calls for kupdate
Message-ID: <20111228213946.GA23791@infradead.org>
References: <20111218154936.GA17626@infradead.org>
	<20111218154955.GB17626@infradead.org>
	<201112282235.57645.hpj@urpla.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201112282235.57645.hpj@urpla.net>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Christoph Hellwig <hch@infradead.org>, Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, xfs@oss.sgi.com

On Wed, Dec 28, 2011 at 10:35:56PM +0100, Hans-Peter Jansen wrote:
> On Sunday 18 December 2011, 16:49:55 Christoph Hellwig wrote:
> > If the writeback code writes back an inode because it has expired we
> > currently use the non-blockin ->write_inode path.  This means any
> > inode that is pinned is skipped.  With delayed logging and a workload
> > that has very little log traffic otherwise it is very likely that an
> > inode that gets constantly written to is always pinned, and thus we
> > keep refusing to write it.  The VM writeback code at that point
> > redirties it and doesn't try to write it again for another 30
> > seconds.  This means under certain scenarious time based metadata
> > writeback never happens.
> 
> Wouldn't this qualify as STABLE material then?

Yes, it does.  But for something as complicated as XFS I'm not going to
do a simple Cc: to stable but will apply each patch individually and do
explicit testing of the backport.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
