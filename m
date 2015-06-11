Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 86F387F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 11:03:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CC83AC005
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 09:03:37 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Oz4YRohqzMtua3GP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 09:03:36 -0700 (PDT)
Date: Thu, 11 Jun 2015 09:03:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150611160335.GA28312@infradead.org>
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

This works fine for me.

Btw, we really shouldn't be installing generated files, that's a major
PITA for multiarch setups.  I'll see how much of the autoconf magic
we even need here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
