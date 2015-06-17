Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD14B7F92
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 384DBAC002
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:31:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 96QLQ6HOP1T5T9V7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:31:26 -0700 (PDT)
Date: Wed, 17 Jun 2015 03:31:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150617103125.GA4043@infradead.org>
References: <20150610070604.GA9855@infradead.org>
	<20150610081914.GV9143@dastard>
	<20150610082415.GA23860@infradead.org>
	<20150610083441.GW9143@dastard>
	<20150610084043.GA31392@infradead.org>
	<20150610091952.GE24666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150610091952.GE24666@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 10, 2015 at 07:19:52PM +1000, Dave Chinner wrote:
> On Wed, Jun 10, 2015 at 01:40:43AM -0700, Christoph Hellwig wrote:
> > Here is the fix.  Since that commit the build accidentally relied on the
> > installed platform_defs.h:
> > 
> > ---
> > From e406bcdcdad80ca491d5b854cde5ad893bef6f8c Mon Sep 17 00:00:00 2001
> > From: Christoph Hellwig <hch@lst.de>
> > Date: Wed, 10 Jun 2015 10:34:45 +0200
> > Subject: xfsprogs: fix platform_defs.h include path
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > 
> > Since 2fe8a2 ("libxfs: restructure to match kernel layout") platform_defs.h
> > the xfs subdirectory under include/ only contains selected headers instead
> > of being a directory symlink.
> > 
> > Because of this the build does not properly pick up platform_defs.h, which
> > isn't symlinked into include/xfs.  Builds only work if a recent enough
> > platform_defs.h is available under /usr/include/xfs.
> > 
> > Fix this by including platform_defs.h without the xfs/ prefix.
> 
> Actually, I think that platform_defs.h needs to be symlinked into
> include/xfs. that was the intent, but I bet I missed it because
> the build wasn't failing and so I didn't notice that I'd failed to
> put it into the the include/Makefile rule for installed headers.
> 
> Yeah, there we are - the install-dev rule has a specific install
> rule for platform_defs.h as well, so it was being included in the
> package builds correctly (i.e. installed in /usr/include/xfs)
> without being mentioned in the HFILES definition that defines header
> files to be packaged for /usr/include/xfs....
> 
> Patch below (which uncovers another issue to do with include files
> on the distclean side, but is not fatal and I'll fix tomorrow).

Can you apply this one to get the build back working?  I have
another large one to deal with splitting the generated files on top of
it.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
