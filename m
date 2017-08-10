Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752283AbdHJM2K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Aug 2017 08:28:10 -0400
Date: Thu, 10 Aug 2017 08:28:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] Stop searching for free slots in an inode chunk when
 there are none
Message-ID: <20170810122804.GB3777@bfoster.bfoster>
References: <20170807101710.18734-1-cmaiolino@redhat.com>
 <20170807151954.GB43920@bfoster.bfoster>
 <20170810115617.GN21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810115617.GN21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Aug 10, 2017 at 09:56:18PM +1000, Dave Chinner wrote:
> On Mon, Aug 07, 2017 at 11:19:56AM -0400, Brian Foster wrote:
> > On Mon, Aug 07, 2017 at 12:17:10PM +0200, Carlos Maiolino wrote:
> > Also note that this has potential for performance side effects in the
> > common (non-corruption) case.
> 
> I'm not seeing an issue here once the code is corrected. Probably
> just me being dumb again, but could you point it out for me, Brian?
> 

Oh, I'm just pointing out that this version tweaks the normal runtime
algorithm (by further limiting the record search window in certain
cases) whereas the previous version did not and I didn't see any mention
as to why that is safe. The first sentence below explains why I think
the change has minimal performance impact, if any, and is probably fine.
I'm basically just asking that if we fix this by tweaking the
optimization algorithm, we add a brief justification for why this does
not impact normal runtime performance in the commit log (if my
understanding is correct, feel free to steal the text below).

> > It looks to me that it shouldn't be a major problem because it only
> > affects the situation where the cached search "wraps" to the outside of
> > the tree, and that probably doesn't happen often with a search distance
> > of 10 records and a large tree. I am a bit curious where the
> > searchdistance of 10 comes from though (we fit many more records in a
> > single inobt leaf block)..?
> 
> It was chosen based on CPU profiles and performance measurement to
> limit the CPU usage of the problem case the finobt now solves. i.e.
> finding the frees inode in a tree that indexes several million
> allocated inodes and the free inodes are few and far between. It was
> chosen to cap inode allocation performance degradation when free
> inodes were extremely sparse at around 50% of the "lots of free
> inodes that are easy to find" performance.
> 

Ah, Ok. So it was more of a CPU oriented optimization than an I/O one.
That makes sense, thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
