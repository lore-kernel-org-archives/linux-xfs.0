Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 321467F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 16:26:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3291AC005
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 14:26:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	grF5VGYr6Un0kxpf for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 14:26:32 -0700 (PDT)
Date: Thu, 27 Aug 2015 07:26:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump: prevent segfault in cb_add_inogrp
Message-ID: <20150826212618.GA3902@dastard>
References: <20150924193241.975348815@gulag1.americas.sgi.com>
	<55DDEC60.4040509@sandeen.net> <55DDF312.1050402@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55DDF312.1050402@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Aug 26, 2015 at 12:10:42PM -0500, Rich Johnston wrote:
> On 08/26/2015 11:42 AM, Eric Sandeen wrote:
> >On 8/26/15 9:33 AM, rjohnston@sgi.com wrote:
> >>The call to memset will segfault because the offset for the first
> >>parameter is done twice. We are using pointer math to do the
> >>calculation.
> >>The first time is when calculating oldsize, the size of i2gseg_t
> >>is accounted for.
> >>	oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
> >>Then in the call to memset, oldsize is again multiplied by the size
> >>of i2gmap_t.
> >>	memset(inomap.i2gmap + oldsize, ...)
> >>	
> >>i2gmap holds the used inodes in each chunk. When there are 2^31 chunk
> >>entries, it could describe 2^31 (1 inode/chunk)- 2^40 (64 inodes/chunk).
> >>
> >>With 100s of millions of inodes there are enough entries to wrap the
> >>32 bit variable oldsize.
> >>
> >>Switching to use array index notation instead of calculating the
> >>pointer address twice ;) would resolve this issue. The unneeded
> >>local variable oldsize can be removed as well.
> >
> >Ok, this doesn't explain the type change for numsegs, does it?
> Nope that was a typo, as it is an array index I meant to change it from
> a signed int (intgen_t) to an unsigned (uint32_t).

That doesn't fix anything. If you push the index down through zero
by decrementing it too much, it will still result in an array bound
overrun. i.e. It will index array element UINT_MAX rather than -1.
And the compiler still won't catch it because it can't bounds check
runtime calculated index values...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
