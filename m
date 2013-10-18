Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0CF267F4E
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 22:00:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E175D304048
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 20:00:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xiwhEZDFHp4mFg8R for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 20:00:43 -0700 (PDT)
Date: Fri, 18 Oct 2013 14:00:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfstests: add a multithreaded mode to bstat
Message-ID: <20131018030039.GS4446@dastard>
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
	<1370610398-14630-7-git-send-email-david@fromorbit.com>
	<526056AC.4000307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <526056AC.4000307@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Oct 17, 2013 at 04:29:16PM -0500, Eric Sandeen wrote:
> On 6/7/13 8:06 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For benchmarking of bulkstat, add a multithreaded mode that spawns a
> > thread per AG and runs bulkstat on every AG in parallel. There is a
> > small amount of overlap between each AG because of the way the
> > interface works only on inode numbers, so some inodes are reported
> > twice. A real implementation of this sort of parallelism would be
> > greatly helped by adding an AG parameter to the bulkstat interface.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> At least w/ older xfsprogs[[qa]-devel] packages, I get:
> 
> bstat.c:41: error: redefinition of 'fls'
> /usr/include/xfs/bitops.h:8: note: previous definition of 'fls' was here
> bstat.c:70: error: redefinition of 'xfs_highbit32'
> /usr/include/xfs/xfs_bit.h:50: note: previous definition of 'xfs_highbit32' was here
> 
> w/ the new functions you've added here...

Ok, so I need autoconf magic here to detect this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
