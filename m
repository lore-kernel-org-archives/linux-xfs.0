Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB58ZfAq122562 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 02:35:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A9DE1F418FA
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 00:35:37 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	bYAJ47QmUxz3eAgh for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 00:35:37 -0800 (PST)
Date: Mon, 5 Dec 2011 03:35:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: cleanup the transaction commit path a bit
Message-ID: <20111205083534.GA29401@infradead.org>
References: <20111128082522.224645690@bombadil.infradead.org>
	<20111128082557.082085349@bombadil.infradead.org>
	<20111205035516.GF7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205035516.GF7046@dastard>
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

On Mon, Dec 05, 2011 at 02:55:16PM +1100, Dave Chinner wrote:
> > + *
> > + * Note that this format differs from the old log vector format in that there
> > + * is no transaction header in these log vectors.
> 
> Do we even need this comment given the old itransaction commit code
> that did this is now gone?

We could probably drop this, yes.

> Would it make sense to have IOP_FORMAT return the length of the
> vectors (calculated as itis built) rather than having to add them up
> after the fact? That would avoid an extra pass across the vector
> array. Regardless, it can be done as a future patch...

I have a WIP patch for that, but it's not quite ready yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
