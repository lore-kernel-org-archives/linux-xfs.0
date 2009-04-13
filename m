Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3DDwqiW110804 for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 08:59:07 -0500
Date: Mon, 13 Apr 2009 09:58:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix async io error handling in fsx
Message-ID: <20090413135834.GA3196@infradead.org>
References: <1239031576-26279-1-git-send-email-felixb@sgi.com>
	<20090406163331.GA22240@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090406163331.GA22240@infradead.org>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 06, 2009 at 12:33:31PM -0400, Christoph Hellwig wrote:
> On Mon, Apr 06, 2009 at 10:26:16AM -0500, Felix Blyakher wrote:
> > The result of async io returned in the event.res in addition
> > to the number of bytes read/written provides negated error
> > number. The broken libaio defines event.res as unsigned
> > while the same structure in the kernel defines it as signed.
> > The kernel indeed treats it as signed, and returns the
> > negated error number. Till libaio is fixed we provide
> > the signed long temp var.
> > Also set errno for each error condition in aio_rw, as the
> > caller is not aio aware and expects ret(-1)+errno by the
> > traditional libc convention.
> 
> Looks good.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Do you plan to commit this?  Otherwise I'll just suck it into the
xfstests-dev tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
