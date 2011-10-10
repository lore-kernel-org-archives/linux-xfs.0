Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9ADEqOQ178922 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 08:14:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4DA41F1EF28
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 06:14:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BtvlIL2Zl5hcNRyG for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 06:14:51 -0700 (PDT)
Date: Mon, 10 Oct 2011 09:14:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] repair: fix some valgrind reported errors on i686
Message-ID: <20111010131449.GA15671@infradead.org>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-3-git-send-email-david@fromorbit.com>
	<20111009234529.GA13527@infradead.org>
	<20111010002017.GQ3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010002017.GQ3159@dastard>
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

On Mon, Oct 10, 2011 at 11:20:17AM +1100, Dave Chinner wrote:
> > Call me stupid, but I can't see how this could actually be a real
> > life issue.  The first thing we do in the loop is to to write
> > to fsbno in btree_find.  I'm fine adding this to shut up warnins,
> > but I can't see a real issue.
> 
> If btree_find() fails to find the key being looked up, it returns
> without having initialised fsbno.

Indeed.  The normal pattern for btree_find seems to be:

	obj = btree_find(tree, key, &key_ptr);
	if (!obj)
		return;

which makes this fine.

The code in pf_batch_read effectively boils down to that due to
the 

	while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {

loop which stops executing the first conditional that evaluated to
false.  So I can't see how this actually ever had an affect, but I'm
fine with fixing the warnings.

Btw, did I mention that the while loop over the bplist is completely
non-intuitive?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
