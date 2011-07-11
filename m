Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6B9prgD206828 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 04:51:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCFF7167D1E1
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 02:51:52 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9zfICtccWvbmHq7u for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 02:51:52 -0700 (PDT)
Date: Mon, 11 Jul 2011 05:51:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [regression, 3.0-rc] xfs: freeze hang in 068
Message-ID: <20110711095147.GA19354@infradead.org>
References: <20110711010357.GD23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110711010357.GD23038@dastard>
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
Cc: hch@lst.de, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 11:03:57AM +1000, Dave Chinner wrote:
> Christoph,
> 
> The recent changes to the active transaction accounting to close a
> race on freeze can hang the freeze process and hence the filesystem.

That commit isn't in 3.0-rc, but I guess it's just the subject line
that is incorrect.

> So effective we cannot sleep waiting for SB_FREEZE_TRANS to go away
> while holding an active transaction reference because the freeze
> process does not set and check SB_FREEZE_TRANS/mp->m_active_trans
> atomically.
> 
> I haven't put any thought into how to solve this problem yet, so I'd
> suggest that at this late stage we need to revert 315fdfa (xfs: fix
> filesystsem freeze race in xfs_trans_alloc) because the race it
> fixes is far less critical (i.e. doesn't hang the filesystem) and
> harder to hit than the regression introduced here.

Yes, I guess we need to revert it for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
