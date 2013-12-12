Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45A747F3F
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:57:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8009AC002
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:57:01 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FtTU660XjK0n4Pyd for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 12:56:59 -0800 (PST)
Date: Fri, 13 Dec 2013 07:56:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] libxfs: buffer cache hashing is suboptimal
Message-ID: <20131212205657.GA10988@dastard>
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-5-git-send-email-david@fromorbit.com>
	<52AA078E.90800@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52AA078E.90800@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 01:59:26PM -0500, Brian Foster wrote:
> On 12/12/2013 02:22 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The hashkey calculation is very simplistic,and throws away an amount
> > of entropy that should be folded into the hash. The result is
> > sub-optimal distribution across the hash tables. For example, with a
> > default 512 entry table, phase 2 results in this:
> > 
> ...
> > Modify the hash to be something more workable - steal the linux
> > kernel inode hash calculation and try that:
> > 
> ...
> > 
> > Kinda says it all, really...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Results look nice and the algorithm seems to match the kernel variant,
> but what about the 32-bit alternate prime/cache line values? Safe to
> leave out..?

The buffer cache uses a 64 bit key, regardless of the platform.
Therefore the 64 bit variant is always needed. The kernel inode hash
uses a 32 bit key on 32 bit systems, which is why there are two
variants for it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
