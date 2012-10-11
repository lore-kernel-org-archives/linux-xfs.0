Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLYlN8242945 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:34:47 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1zAzAyD8eFJab03U (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:36:19 -0700 (PDT)
Date: Thu, 11 Oct 2012 17:36:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/19] xfs: make buffer read verication an IO completion
	function
Message-ID: <20121011213618.GB6346@infradead.org>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349754670-32009-3-git-send-email-david@fromorbit.com>
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

On Tue, Oct 09, 2012 at 02:50:53PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than have to detect if the buffer has just been read from
> disk by futzing with buffer state, supply the read functions with a
> verification callback and attach that to the buffer to be run if the
> buffer has to be read from disk into memory.
> 
> If the verify function fails, then the buffer will be marked with an
> EFSCORRUPTED error to indicate that the buffer did not pass
> verification and should be considered tainted.

The commit message seems to be a bit confusing for a patch that does
nothing but adding a function pointer to the read functions which isn't
set yet.  I suspect it should have a description what's actually going
on just in this patch as well, and just mention the above as the purpose
for it.

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
