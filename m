Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5CEB78000
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 04:59:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3404930405F
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 02:59:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 0i9Z4WbDz14puRFN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 02:59:28 -0700 (PDT)
Date: Fri, 26 Sep 2014 02:59:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: annotate user variables passed as void
Message-ID: <20140926095927.GF10692@infradead.org>
References: <1411601863-19594-1-git-send-email-david@fromorbit.com>
	<1411601863-19594-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411601863-19594-5-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 09:37:43AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Some argument callbacks can contain user buffers, and sparse warns
> about passing them as void pointers. Cast appropriately to remove
> the sparse warnings.

Looks okay.  I don't really like the games we're playing there, but this
isn't the time to fix them up..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
