Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 693A28001
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:21:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4712D304053
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 03:21:50 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id K4bSL9vDALgjImOx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 03:21:49 -0700 (PDT)
Date: Fri, 26 Sep 2014 03:21:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/11] xfs: check xfs_buf_read_uncached returns correctly
Message-ID: <20140926102148.GF22194@infradead.org>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648461-29003-11-git-send-email-david@fromorbit.com>
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

On Thu, Sep 25, 2014 at 10:34:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_buf_read_uncached() has two failure modes. If can either return
> NULL or bp->b_error != 0 depending on the type of failure, and not
> all callers check for both. Fix it up.

This changelog still seems to be for your previous version and needs
an update now tha xfs_buf_read_uncached always returns the error
directly.

> -		return NULL;
> +		return ENOMEM;

Should be -ENOMEM these days, shouldn't it?

>  release_buf:
> -	xfs_buf_relse(bp);
> +	if (bp)
> +		xfs_buf_relse(bp);

Shouldn't bp always be valid at this point?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
