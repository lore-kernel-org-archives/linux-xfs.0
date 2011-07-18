Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6IG1Uvu108262 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 11:01:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA9AF7A035
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 09:01:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8EAtFaHyMaVc7NEw for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 09:01:29 -0700 (PDT)
Date: Mon, 18 Jul 2011 12:01:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: convert xfsbufd to use a workqueue
Message-ID: <20110718160129.GB14094@infradead.org>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310960989-10284-3-git-send-email-david@fromorbit.com>
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

On Mon, Jul 18, 2011 at 01:49:48PM +1000, Dave Chinner wrote:
> control flushing. While there, group all the delayed write list and
> buffer handling functions into the same section of code to make it
> easier to find all the relevant code.

Any chance you could make the re-grouping a separate patch?  It's
really hard to read it right now as the actual changes are hidden too
much.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
