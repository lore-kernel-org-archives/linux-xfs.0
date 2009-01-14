Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0EN7Rmv008165 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 17:07:27 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 701A517FDE65
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 15:07:25 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	DBsWZHtYcn0Wa3Y1 for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2009 15:07:25 -0800 (PST)
Date: Thu, 15 Jan 2009 09:48:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump support for 64K page size
Message-ID: <20090114224857.GA8071@disturbed>
References: <4964C5EF.3060308@sgi.com> <4965629C.2000703@sgi.com>
	<20090108222800.GG9448@disturbed> <4967A73E.9020907@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4967A73E.9020907@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

On Fri, Jan 09, 2009 at 01:36:30PM -0600, Bill Kendall wrote:
> Dave Chinner wrote:
> > BTW, these changes are the *exact* patches I sent back in March.
> > I note that the change logs from those patches have been dropped
> > on the floor. i.e.:
> 
> Right, only difference is that I removed the asserts rather than
> just having them commented out. In my determination the asserts
> are totally bogus -- there isn't a dependency on the system's
> page size in the inomap code.

.....

> The inomap code uses xfsdump's PGSZ variable, which is fixed at 4K.
> There's no dependency here on the system's actual page size. I was
> able to dump and then restore on a system with a different page size.

Ok, that looks fine. however, there is a dependency that HNKSZ >=
PGSZ, right? And that is currently hardwired to (4 * PGSZ)?

And given that the intent of the PGSZ was to be made variable at
some point, isn't this really trying to ensure that HNKSZ is always
greater than the PGSZ the program was built with?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
