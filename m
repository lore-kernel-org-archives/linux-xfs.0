Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4H7WG2t234824 for <xfs@oss.sgi.com>; Mon, 17 May 2010 02:32:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B43734A410
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 00:34:33 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id oinoHZYbFUXT7sg0 for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 00:34:33 -0700 (PDT)
Date: Mon, 17 May 2010 03:34:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/12] xfs: Introduce delayed logging core code
Message-ID: <20100517073432.GA28836@infradead.org>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
	<1273210860-23414-10-git-send-email-david@fromorbit.com>
	<20100510114435.GA27624@infradead.org>
	<20100510121628.GD7165@dastard> <20100517055101.GK8120@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100517055101.GK8120@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, May 17, 2010 at 03:51:01PM +1000, Dave Chinner wrote:
> Unfortunately, it's still not a totally clean separation - either
> way something has to be exported. I'd prefer not to export the CIL
> context or the context lock outside xfs_log_cil.c, so that kind of
> rules out moving xfs_log_commit_cil(). I moved a couple of things
> from there back to xfs_trans_commit_cil(), but we still need
> xfs_trans_item_committed() and xfs_trans_unreserve_and_mod_sb()
> exported. That seems to be the cleanest I can come up with right
> now...

Ok let's go with that for now and make sure we have the delayed logging
code in before the merge window closes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
