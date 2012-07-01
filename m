Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q61EsDVS090682 for <xfs@oss.sgi.com>; Sun, 1 Jul 2012 09:54:13 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9ckMntfOUYfbXvCU for
	<xfs@oss.sgi.com>; Sun, 01 Jul 2012 07:54:12 -0700 (PDT)
Message-ID: <4FF06480.6030109@redhat.com>
Date: Sun, 01 Jul 2012 16:53:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<4FE1BDF3.4080702@shiftmail.org> <20120620225327.GL30705@dastard>
	<20120621174742.GA27837@redhat.com>
In-Reply-To: <20120621174742.GA27837@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, hch@infradead.org, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, linux-ext4@vger.kernel.org

Il 21/06/2012 19:47, Mike Snitzer ha scritto:
> Paolo Bonzini fixed blkdev_issue_discard to properly align some time
> ago; unfortunately the patches slipped through the cracks (cc'ing Paolo,
> Jens, and Christoph).
> 
> Here are references to Paolo's patches:
> 0/2 https://lkml.org/lkml/2012/3/14/323
> 1/2 https://lkml.org/lkml/2012/3/14/324
> 2/2 https://lkml.org/lkml/2012/3/14/325
> 
> Patch 2/2 specifically addresses the case where:
>  discard_max_bytes == discard_granularity 
> 
> Paolo, any chance you could resend to Jens (maybe with hch's comments on
> patch#2 accounted for)?  Also, please add hch's Reviewed-by when
> reposting.

Sure, I'll do it this week.  I just need to retest.

Paolo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
