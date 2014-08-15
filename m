Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EDCEB7F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 07:56:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CB56AC006
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 05:56:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AbSJb1D9BNaeIYSL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 05:56:09 -0700 (PDT)
Date: Fri, 15 Aug 2014 05:56:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: check xfs_buf_read_uncached returns correctly
Message-ID: <20140815125608.GA27856@infradead.org>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-10-git-send-email-david@fromorbit.com>
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

On Fri, Aug 15, 2014 at 04:39:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_buf_read_uncached() has two failure modes. If can either return
> NULL or bp->b_error != 0 depending on the type of failure, and not
> all callers check for both. Fix it up.

I'd rather get rid of these annoying calling conventions.  Make it
return and errno, and the bp in a pointer argument, with the bp
never non-NULL in case of error.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
