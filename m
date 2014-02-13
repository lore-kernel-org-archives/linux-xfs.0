Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63D527F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 16:26:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35C44304043
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:26:09 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SvAsJFvLSu7he4Iv for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 14:26:07 -0800 (PST)
Date: Fri, 14 Feb 2014 09:26:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
Message-ID: <20140213222602.GK13997@dastard>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
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

On Thu, Feb 13, 2014 at 11:53:05AM -0800, Christian Kujau wrote:
> Hi,
> 
> after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> the WARNING below was printed.
> 
> Shortly after, a lockdep warning appeared (possibly related to my 
> post to the XFS list yesterday[0]).

Unlikely.

> Even later in the log an out-of-memory error appeared, that may or may not 
> be relatd to that WARNING at all but which I'm trying to chase down ever 
> since 3.13, but which tends to appear more often lately.
> 
> Can anyone take a look if this is something to worry about?

Already fixed upstream:

commit 255d0884f5635122adb23866b242b4ca112f4bc8
Author: David Rientjes <rientjes@google.com>
Date:   Mon Feb 10 14:25:39 2014 -0800

    mm/slub.c: list_lock may not be held in some circumstances
    
    Commit c65c1877bd68 ("slub: use lockdep_assert_held") incorrectly
    required that add_full() and remove_full() hold n->list_lock.  The lock
    is only taken when kmem_cache_debug(s), since that's the only time it
    actually does anything.
    
    Require that the lock only be taken under such a condition.
    
    Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
    Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
    Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Acked-by: Christoph Lameter <cl@linux.com>
    Cc: Pekka Enberg <penberg@kernel.org>
    Signed-off-by: David Rientjes <rientjes@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
