Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFEE67F8B
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 03:29:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C67DAC002
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 01:29:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id UmrmFQi5ggTnwizG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jun 2015 01:29:30 -0700 (PDT)
Date: Wed, 10 Jun 2015 01:29:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150610082929.GA8496@infradead.org>
References: <20150610070604.GA9855@infradead.org>
	<20150610081914.GV9143@dastard>
	<20150610082415.GA23860@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150610082415.GA23860@infradead.org>
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

On Wed, Jun 10, 2015 at 01:24:15AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 10, 2015 at 06:19:14PM +1000, Dave Chinner wrote:
> > Does the problem go away after a 'make distclean'?
> 
> No. Neither a distclean nor a fresh clone fixes the issue.
> 
> Also disabling the crc32ctest target I get similar error in other
> code.
> 
> Note that the master branch is doing fine.

I've biscted it to:

commit 2fe8a24dda8a2942a1168c745bf6743ae21991c0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 5 10:13:30 2015 +1000

    libxfs: restructure to match kernel layout

but I still don't understand why it happens.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
