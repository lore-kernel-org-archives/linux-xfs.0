Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D84CF7F3F
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 07:37:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9B2A8F8059
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 05:37:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sPyQWh0aSld1WHWy for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 05:37:42 -0700 (PDT)
Date: Tue, 17 Jun 2014 22:37:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: V5 format and man mkfs.xfs
Message-ID: <20140617123738.GH9508@dastard>
References: <20140617082651.GA27971@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140617082651.GA27971@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On Tue, Jun 17, 2014 at 10:26:51AM +0200, Matthias Schniedermeyer wrote:
> Hi
> 
> How seriously meant is "V5 isn't experimental anymore"?

"Fully supported" isn't a clear enough statement?

> I ask because the man-page only mentions the syntax to enable it by 
> accident. A.k.a. the backport of ftype to V4.
> (man-page of xfsprogs 3.2.0 in Debian-SID)

That's intentional. V5 superblocks are an implementation detail that
most users don't even need to know about. They care about the name
of the features they are enabling at mkfs time, not the details of
the on-disk implementation of those features.

> And you still have to know that crc means V5.

Why do you care about the format mkfs.xfs chooses for you - it's
based on the features you requested. V5 isn't magically faster than
V4 - there are many cases where it is slower due to CRC overhead
or the overhead of the larger inode it requires. So unless you
request a feature that requires it at mkfs time, you don't get that
format.

In a year or so we'll change the mkfs default so that CRCs are
enabled by default, but we can't do that until all the distro's have
had time to pick up a kernel that fully supports the CRC feature....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
