Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MHRBoH073895 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 12:27:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6B5E183C7AB
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:28:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hfdHGjuSCYW0nIeY for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:28:05 -0700 (PDT)
Date: Wed, 22 Sep 2010 13:28:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/16] xfs: split inode AG walking into separate code for
	reclaim
Message-ID: <20100922172805.GD5697@infradead.org>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285137869-10310-12-git-send-email-david@fromorbit.com>
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

On Wed, Sep 22, 2010 at 04:44:24PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The reclaim walk requires different locking and has a slightly
> different walk algorithm, so separate it out so that it can be
> optimised separately.

Yeah, the code was getting far too cruft already with all the
conditionals.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
