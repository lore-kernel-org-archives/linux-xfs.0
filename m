Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668ZrhV094086 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:35:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA41813207BC
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 01:35:31 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2nCvtREdM6VbXqMB for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2011 01:35:31 -0700 (PDT)
Date: Wed, 6 Jul 2011 04:35:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/27] xfs: avoid usage of struct xfs_dir2_block
Message-ID: <20110706083530.GD19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.621819832@bombadil.infradead.org>
	<20110706021935.GK1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706021935.GK1026@dastard>
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

On Wed, Jul 06, 2011 at 12:19:35PM +1000, Dave Chinner wrote:
> Took me a moment to realise what this does - turns the byte swap
> into a compile-time operation rather than a runtime operation.
> Nice.
> 
> Perhaps we should do that same optimisation in other magic number
> checks around the place?

We should, and I should have been more consistant about it.  In fact
I probably should split it into a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
