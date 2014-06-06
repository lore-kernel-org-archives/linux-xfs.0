Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFFC87F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 20:43:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B62968F8035
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 18:43:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Jl9FUizPVbUHVh9b for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 18:43:00 -0700 (PDT)
Date: Fri, 6 Jun 2014 11:42:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_mdrestore: initialize sb prior to xfs_sb_from_disk()
Message-ID: <20140606014256.GD4453@dastard>
References: <5390F89C.2050305@redhat.com> <20140605235633.GC4453@dastard>
	<53910482.1030909@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53910482.1030909@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 05, 2014 at 07:00:02PM -0500, Eric Sandeen wrote:
> On 6/5/14, 6:56 PM, Dave Chinner wrote:
> > On Thu, Jun 05, 2014 at 06:09:16PM -0500, Eric Sandeen wrote:
> 
> ...
> 
> >> But ... should we maybe just do this once and for all in
> >> xfs_sb_from_disk?  I'm not sure leaving it up to every
> >> caller is a good idea, unless somebody ahs a reason to
> >> pre-populate some fields - I can't imagine why that would
> >> be, though...
> > 
> > We don't ever read in the CRC field into the in-memory structures
> > because it has no meaning in memory. Simiarly, we don't ever write
> > the CRC field from the in-core structure because we always
> > re-calculate it in the IO path if CRCs are configured. That is
> > consistent behaviour across the entire code-base.
> 
> <snip stuff>
> 
> > Perhaps we should move the memset() to within xfs_sb_from_disk()
> > to make this explicit?
> 
> Yes, that's what I meant by "this" in "do this once and for all" - 
> sorry, that wasn't clear.  memset(0) in xfs_sb_from_disk().

I didn't read it clearly. my fault.

> Yeah, the more I think about it, the more I think that's probably
> the obviously correct thing to do.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
