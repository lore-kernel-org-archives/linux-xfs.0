Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L50oMK187372 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 00:00:52 -0500
Date: Thu, 21 Oct 2010 01:02:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfstests: add _require_attrs
Message-ID: <20101021050202.GA1752@infradead.org>
References: <20101015222820.GA3655@infradead.org>
	<20101015222902.GB3781@infradead.org>
	<1287597791.2284.99.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287597791.2284.99.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 20, 2010 at 01:03:11PM -0500, Alex Elder wrote:
> On Fri, 2010-10-15 at 18:29 -0400, Christoph Hellwig wrote:
> > Add a new helper to check if extended attributes are supported.  It
> > errors out if any of the attr tools are not found, or if a filesystem
> > does not support setting attributes.
> > 
> > Remove the opencoded checks for the attr tools from various tests
> > now that we do them in common code.
> 
> Generally this looks good.
> 
> I was going to just make a few suggestions and ask you
> to fix them before committing, but  I think there are
> enough that I think it would be good to re-submit this.

I'd rather commit the patch as-is and fix up the attr/getfattr
references separately.  I'll submit a patch to do ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
