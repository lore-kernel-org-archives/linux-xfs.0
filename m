Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9Q8klFn215814 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 03:46:47 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	axOpfYt8TuczACvw (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 01:48:26 -0700 (PDT)
Date: Fri, 26 Oct 2012 04:48:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/25] xfs: uncached buffer reads need to return an error
Message-ID: <20121026084826.GB3035@infradead.org>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-5-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:33:53PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With verification being done as an IO completion callback, different
> errors can be returned from a read. Uncached reads only return a
> buffer or NULL on failure, which means the verification error cannot
> be returned to the caller.
> 
> Split the error handling for these reads into two - a failure to get
> a buffer will still return NULL, but a read error will return a
> referenced buffer with b_error set rather than NULL. The caller is
> responsible for checking the error state of the buffer returned.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I'd still prefer the error as return value, but in case you don't want
that yet:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
