Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 15:23:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m32MNH2a006373
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 15:23:19 -0700
Date: Thu, 3 Apr 2008 08:23:47 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [Patch] Cacheline align xlog_t
Message-ID: <20080402222347.GK103491721@sgi.com>
References: <20080401231552.GV103491721@sgi.com> <47F3293C.6090708@sgi.com> <20080402054403.GF103491721@sgi.com> <87myocek4o.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87myocek4o.fsf@basil.nowhere.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 02, 2008 at 10:28:07AM +0200, Andi Kleen wrote:
> David Chinner <dgc@sgi.com> writes:
> > 
> > This just means that the start of the structure is cacheline
> > aligned.  I don't think the internal alignment commands force the
> > entire structure to be cacheline aligned, merely pad the struture
> > internally. In that case, even though the specific internal parts of
> > the structure are on separate cache lines, there's no guarantee that
> > all the related members are on the same cacheline. Hence I'm
> > explicitly stating the exact alignment I want for the structure....
> 
> Isn't the structure dynamically allocated anyways? 
> The full type alignment really only matters for statics/globals
> where the linker can handle it.

Ah, right you are. My bad.

> For the dynamic allocation you would rather need to make sure it
> starts at a cache line boundary explicitely because the allocator doesn't
> know the alignment of the target type, otherwise your careful
> padding might be useless.

Yup. Is there an allocator function gives us cacheline aligned
allocation (apart from a slab initialised with SLAB_HWCACHE_ALIGN)?
There isn't one, right?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
