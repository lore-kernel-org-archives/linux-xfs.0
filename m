Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C04027F9C
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 17:23:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A37748F8040
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 15:23:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	liEK5Cepnlx0s6rm for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 15:23:08 -0800 (PST)
Date: Fri, 21 Feb 2014 10:23:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: testing flink (aka linkat(..., AT_EMPTY_PATH)
Message-ID: <20140220232305.GT4916@dastard>
References: <20140220221245.GA32288@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140220221245.GA32288@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 02:12:45PM -0800, Christoph Hellwig wrote:
> Turns out so far we aren't really do metadata operation in xfs_io
> and don't even have link/unlink.  Should we starting adding these or
> where else should I start looking into adding support for exercising
> flink?

I think we need a tool that aggregates such functionality, otherwise
we just end up with a prolification of small helper utilities in
xfstests/src directory.  There's the new renameat2 code that would
dearly love a helper function, reflink support woul be useful, etc.
And for O_TMPFILE, is just doesn't make sense to duplicate what
xfs_io does just so that flinkat() support can be tested.

Hence I'm happy to see such metadata operations added to xfs_io from
a functionality point of view.  I also can't see any problems with
being able to integrate them into the command structure or the
source layout structure that xfs_io uses, so I'm not finding an
reason why we shouldn't be adding things like this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
