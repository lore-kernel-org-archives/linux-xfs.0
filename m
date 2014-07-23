Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 047CF7F37
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2014 17:19:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86216AC006
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2014 15:19:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	J7zLZMg3DhpDxWEc for <xfs@oss.sgi.com>;
	Wed, 23 Jul 2014 15:19:27 -0700 (PDT)
Date: Thu, 24 Jul 2014 08:19:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem building xfsprogs
Message-ID: <20140723221923.GV4453@dastard>
References: <20140722160641.GU17967@beardog.cce.hp.com>
	<20140722205605.GJ20518@dastard>
	<20140722210951.GE14599@beardog.cce.hp.com>
	<20140722214727.GP4453@dastard>
	<20140723140118.GI14599@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140723140118.GI14599@beardog.cce.hp.com>
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
To: scameron@beardog.cce.hp.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 23, 2014 at 09:01:18AM -0500, scameron@beardog.cce.hp.com wrote:
> On Wed, Jul 23, 2014 at 07:47:27AM +1000, Dave Chinner wrote:
> > Can you please attach the built include/builddefs and
> > include/platform_defs.h files that autoconf built?
.....
> 
> PKG_NAME	= xfsprogs
> PKG_USER	= relliott
> PKG_GROUP	= relliott
> PKG_RELEASE	= 1
> PKG_VERSION	= 3.2.1
> PKG_PLATFORM	= srcv

I'd say that's your problem right there - your system is not
identifying itself as a linux machine according to autoconf. i.e.
that should say "linux", not "srcv".  That'll make the rest of the
makefiles behave strangely, as nothing that is conditional for the
linux build to work will be added or run.

I guess we now need to look into why autoconf is giving
this result. Can you look in the autoconf output and config.* files
to see why it's coming up with this platform?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
