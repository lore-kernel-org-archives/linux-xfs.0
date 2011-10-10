Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9ADQHB0179638 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 08:26:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAFBD1F1EC40
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 06:26:16 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UCReo5pI7NYhelNj for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 06:26:16 -0700 (PDT)
Date: Mon, 10 Oct 2011 09:26:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
Message-ID: <20111010132611.GA1248@infradead.org>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
	<20111010014509.GT3159@dastard>
	<20111010055546.GA1641@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010055546.GA1641@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 07:55:46AM +0200, Markus Trippelsdorf wrote:
> Wouldn't it be possible to verify that the problem also goes away with
> this simple one liner?

We've been through a few variants, and none fixed it while Stefan had
to try them on production machines.

To be honest I'm not convinced at all that a workqueue was such a good
idea for the ail in particular.  It works extremly well for things were
we can easily define a work item, e.g. an object that gets queued up
and a method on it gets exectured.  But for the AIL we really have
a changing target that needs more or less constant pushing, and the
target keeps changing while executing our work.  Conceptually it fits
the idea of an thread much better, with the added benefit of not relying
on finding a combination of workqueue flags that gets the exact
behaviour (exectuion ASAP without any limits because of other items
or required memory allocation).

And unlike the various per-cpu threads we used to have it is only one
thread per filesystem anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
