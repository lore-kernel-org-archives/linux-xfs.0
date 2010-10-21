Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L5YJBJ192563 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 00:34:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDD4F11268B
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 22:35:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	YyAMQyi8b1q5NRHA for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 22:35:32 -0700 (PDT)
Date: Thu, 21 Oct 2010 16:35:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfstests: handle filesystems without FIEMAP support
Message-ID: <20101021053529.GR32255@dastard>
References: <20101015222820.GA3655@infradead.org>
	<20101015222924.GD3781@infradead.org>
	<1287596221.2284.97.camel@doink>
	<20101021050531.GB1752@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101021050531.GB1752@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Thu, Oct 21, 2010 at 01:05:31AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 20, 2010 at 12:37:01PM -0500, Alex Elder wrote:
> > Looks good, but I think if the operation is not
> > supported you want to delete both "${fiemapfile}"
> > and "${fiemaplog}".
> > 
> > While you're at it, make use of the "${fiemapfile}"
> > variable in the fiemap-tester command...  (This
> > appears to be a bug in the original test.)
> 
> Updated version below:
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: [PATCH 4/4] xfstests: handle filesystems without FIEMAP support
> 
> Do a _notrun in 225 if we get EOPNOSUPP back from FIEMAP instead
> of failing the test.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
