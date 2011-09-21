Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LBQRCO137519 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:26:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F86717B68A
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 04:26:26 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sB0EZbmkhqtSQkVD for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 04:26:26 -0700 (PDT)
Date: Wed, 21 Sep 2011 07:26:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: convert xfsbufd to use a workqueue
Message-ID: <20110921112624.GA30934@infradead.org>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
	<1314341497-23910-5-git-send-email-david@fromorbit.com>
	<20110826082515.GD3551@infradead.org>
	<20110921062539.GN15688@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110921062539.GN15688@dastard>
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

On Wed, Sep 21, 2011 at 04:25:39PM +1000, Dave Chinner wrote:
> Which is precisely what I want here - to wait for all the delwri
> buffers that were promoted to be submitted before continuing
> onwards.  This makes the scanning algorithm self throttling -
> instead of simply pushing the buffers to the delwri queue and
> kicking a background thread and hoping it can flush buffers faster
> than we can promote them from the AIL, it explicitly pushes the
> delwri buffers before the next round of AIL scanning. The ensures we
> start timely IO on the buffers and don't simple continue to scan the
> AIL while we wait for the background thread to send them off to
> disk and complete.

I didn't say I'm against it.  The important bit is that such changes
in behaviour get documented in the patch description, including
a rationale like the on in this mail.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
