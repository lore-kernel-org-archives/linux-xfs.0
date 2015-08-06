Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5671E7F80
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 16:26:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 340368F8049
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 14:26:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GWkAGxF7MRz7Zz4G for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 14:26:34 -0700 (PDT)
Date: Fri, 7 Aug 2015 07:26:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump doesn't compile: undefined reference to 'min'
Message-ID: <20150806212620.GD3902@dastard>
References: <55C312CF.2040408@vollmann.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C312CF.2040408@vollmann.ch>
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
To: Detlef Vollmann <dv@vollmann.ch>
Cc: xfs@oss.sgi.com

On Thu, Aug 06, 2015 at 09:54:55AM +0200, Detlef Vollmann wrote:
> > commit 5a2985233c390d59d2a9757b119cb0e001c87a96
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Fri Jul 18 08:02:26 2014 +1000
> >
> >     dump: don't redefine min() or max()
> >
> >     They are included from other header files.
> The message doesn't say from which header and configure doesn't test
> for it.
> If I compile it (cross-compilation, gcc, uclibc, xfsprogs 3.1.11,
> xfsdump 3.1.4), I get lots of errors:
> warning: implicit declaration of function 'max'
> undefined reference to 'min'

#include <xfs/xfs.h>
  -> /usr/include/xfs/xfs.h
     #include <xfs/platform_defs.h>
       -> /usr/include/xfs/platform_defs.h
          #define min(a,b)	(((a)<(b))?(a):(b))

These headers come from xfsprogs, and you'll need to upgrade that
package to 3.2.x....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
