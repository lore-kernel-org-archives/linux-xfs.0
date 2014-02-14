Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D3AA7F67
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 19:20:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C9BC8F804B
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 17:20:12 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sMeTYWSJTsuDDk9o for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 17:20:10 -0800 (PST)
Date: Fri, 14 Feb 2014 12:14:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
Message-ID: <20140214011453.GP13997@dastard>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
	<20140213222602.GK13997@dastard>
	<alpine.DEB.2.19.4.1402131531290.6233@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.19.4.1402131531290.6233@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Feb 13, 2014 at 03:34:19PM -0800, Christian Kujau wrote:
> On Fri, 14 Feb 2014 at 09:26, Dave Chinner wrote:
> > > after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> > > the WARNING below was printed.
> > > 
> > > Shortly after, a lockdep warning appeared (possibly related to my 
> > > post to the XFS list yesterday[0]).
> > 
> > Unlikely.
> 
> OK, so the "possible irq lock inversion dependency detected" is a lockdep 
> regression, as you explained in the xfs-list thread. What about the 
> "RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected" warning - I 
> haven't seen it again though, only once with 3.14.0-rc2.

That was also an i_lock/mmapsem issue, so it's likely to be the same
root cause. I'm testing a fix for it at the moment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
