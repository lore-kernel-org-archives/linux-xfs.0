Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5F6JVBA075725 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 01:19:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F432AE9730
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 23:25:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NC3MDTQanp3HhOlx for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 23:25:39 -0700 (PDT)
Date: Tue, 15 Jun 2010 02:22:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: simplify xfs_vm_releasepage
Message-ID: <20100615062204.GA6974@infradead.org>
References: <20100611161312.446670249@bombadil.infradead.org>
	<20100611161511.791495868@bombadil.infradead.org>
	<20100615013737.GN6590@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100615013737.GN6590@dastard>
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

On Tue, Jun 15, 2010 at 11:37:37AM +1000, Dave Chinner wrote:
> > +	/*
> > +	 * VM calculation for nr_to_write seems off.  Bump it way
> > +	 * up, this gets simple streaming writes zippy again.
> > +	 * To be reviewed again after Jens' writeback changes.
> > +	 */
> > +	wbc->nr_to_write *= 4;
> > +
> 
> That's gone in mainline as of as of .35-rc3. We need to get the
> xfs-dev tree updated.

It's still in the XFS tree.  Either we need to rebase that one, or sort
it out during a merge.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
