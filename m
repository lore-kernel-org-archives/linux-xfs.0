Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28NrUN6104116 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 17:53:30 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cqKTUObzLlLn3Z9g for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 15:53:28 -0800 (PST)
Date: Fri, 9 Mar 2012 10:53:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Safe to use XFS in production in Linux 3.2.9?
Message-ID: <20120308235326.GQ5091@dastard>
References: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
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
To: Sean Thomas Caron <scaron@umich.edu>
Cc: xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 02:06:00PM -0500, Sean Thomas Caron wrote:
> Hi all,
> 
> We're currently using Linux 3.0.12 with Cristoph's
> xfs-bulletproof-sync patch and it seems to be working very well for
> us. Unfortunately this kernel is vulnerable to the recent
> CVE-2012-0056 no permission checking on writes to /proc/(pid)/mem
> local root exploit, so we've got to leave it behind.

Hasn't it been fixed in 3.0.23? root exploits are the sort of thing
that are supposed to be fixed in long term stable kernels....

> I see that the newest recommended stable kernel on kernel.org is
> 3.2.9. Have there been any major changes to XFS between 3.0.12 and
> 3.2.9 that would be considered "risky" in a production environment?

The 3.2.x kernels really haven't been run in production environments
for that long for us to be able to tell if there are problems or
not.

> I assume the xfs-bulletproof-sync patch has already been committed
> to the code base in 3.2-train, so we shouldn't have to worry about
> that any longer?

Should have been, but I'm not exactly sure what is in that patch
Christoph gave you, so you'll have to verify that yourself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
