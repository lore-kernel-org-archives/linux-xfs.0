Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o891cZG0076166 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 20:38:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3FDF5AE97
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 18:39:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GiI2usGF2sUiEo6X for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 18:39:20 -0700 (PDT)
Date: Wed, 8 Sep 2010 21:39:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: remove buftarg hash for external devices
Message-ID: <20100909013920.GA11362@infradead.org>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283958778-28610-4-git-send-email-david@fromorbit.com>
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

On Thu, Sep 09, 2010 at 01:12:57AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For RT and external log devices, we never use hashed buffers on them now.
> Remove the buftarg hash tables that are set up for them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
