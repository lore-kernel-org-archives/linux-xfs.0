Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAH7U7qE023979 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 01:30:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E6EB162651D
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 23:30:05 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QuwZvumooqXc8t6A for <xfs@oss.sgi.com>;
	Wed, 16 Nov 2011 23:30:05 -0800 (PST)
Date: Thu, 17 Nov 2011 02:30:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] [PATCH] xfs: fix attr2 vs large data fork assert
Message-ID: <20111117073004.GB3733@infradead.org>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.498870090@bombadil.infradead.org>
	<20111116231517.GA7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111116231517.GA7046@dastard>
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

On Thu, Nov 17, 2011 at 10:15:17AM +1100, Dave Chinner wrote:
> On Tue, Nov 15, 2011 at 03:14:08PM -0500, Christoph Hellwig wrote:
> > With Dmitry fsstress updates I've seen very reproducible crashes in
> > xfs_attr_shortform_remove because xfs_attr_shortform_bytesfit claims that
> > the attributes would not fit inline into the inode after removing an
> > attribute.  It turns out that we were operating on an inode with lots
> > of delalloc extents, and thus an if_bytes values for the data fork that
> > is larger than biggest possible on-disk storage for it which utterly
> > confuses the code near the end of xfs_attr_shortform_bytesfit.
> 
> We have a test that stresses allocated extents vs attributes in the
> xfs_fsr swapext test (227), but that does not take into account
> delalloc extents. It sounds like it would be relatively easy to
> write a regression test for this particular case - create a file
> with a bunch of attributes, then create a number of delalloc data
> extents, then remove the attributes to trigger the condition in
> xfs_attr_shortform_remove()....

Test 117 with Dmitries new fsstress changes hit it 100% reliably
before

	xfstests: freeze fsstress options for 117'th

I was planning on adding a copy of the test using an explicit
combination of fsstress seeds that reproduce the issue.

> While you are touching that function, can you fix all the whitespace
> damage as well? (lots of trailing whitespace). There's a couple of
> typos I noticed in your changes (below), but otherwise looks good.

I'll fix the tpos and whitespace issues.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
