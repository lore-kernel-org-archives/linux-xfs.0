Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24E267F4E
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 00:02:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 111958F8040
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 22:02:53 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id xPGBUK9vC9STEYW1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 22:02:49 -0800 (PST)
Date: Mon, 25 Nov 2013 22:02:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: let iop_format write directly into the linear
	buffer
Message-ID: <20131126060248.GA5802@infradead.org>
References: <20131123151151.716201348@bombadil.infradead.org>
	<20131123151533.726941044@bombadil.infradead.org>
	<20131125091527.GD8803@dastard>
	<20131125133755.GB21992@infradead.org>
	<20131125204525.GF8803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131125204525.GF8803@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 07:45:25AM +1100, Dave Chinner wrote:
> I think the current code could be changed first, just to remove the
> special cases (i.e. the ifdef NATIVE_HOST/else conditionals) by
> always calling xfs_inode_item_format_extents(). That's easy enough
> to do and then the iop_format change can simple change it to calling
> xfs_iextent_copy() directly...

Ok, I can do that.

> I'd prefer to have a helper than have the same boilerplate code
> repeated 14 times purely from a maintenance POV. It's easy to find
> all the callers, it's easy to check that they do the right thing,
> and in future there's only one piece of code to modify for all the
> simple log item formatting operations....

I'll resent with it re-added.  The reason it confused me is that only
the len argument ever got used twice in the helper, otherwise it's
just a bunch of assignment using a disjoint arguments.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
