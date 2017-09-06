Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:3195 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752943AbdIFMMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 08:12:05 -0400
Date: Wed, 6 Sep 2017 22:12:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Message-ID: <20170906121200.GU17782@dastard>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170903085602.GF32385@infradead.org>
 <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
 <20170906034443.GQ17782@dastard>
 <9729DF06-8F96-4F93-BF50-133F9BA2770F@fb.com>
 <20170906114305.GC54570@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906114305.GC54570@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Richard Wareing <rwareing@fb.com>, Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

On Wed, Sep 06, 2017 at 07:43:05AM -0400, Brian Foster wrote:
> That said, while the implementation improvement makes sense, I'm still
> not necessarily convinced that this has a place in the upstream realtime
> feature. I'll grant you that I'm not terribly familiar with the
> historical realtime use case.. Dave, do you see value in such a
> heuristic as it relates to the realtime feature (not this tiering
> setup)? Is there necessarily a mapping between a large file size and a
> file that should be tagged realtime?

I don't see it much differently to the inode32 allocator policy.
That separates metadata from data based on the type of allocation
that is going to take place.  inode32 decides on the AG for the
inode data on the first data allocation (via the ag rotor), so
there's already precedence for this sort of "locality selection at
initial allocation" policy in the XFS allocation algorithms. 

Some workloads run really well on inode32 because the metadata ends
up tightly packed and you can keep lots of disks busy with a dm
concat because data IO is effectively distributed over all AGs.
We've never done that automatically with the rt device before, but
if it allows hybrid setups to be constructed easily then I can see
it being beneficial to those same sorts of worklaods....

And, FWIW, auto rtdev selection might also work quite nicely with
write once large file workloads (i.e. archives) on SMR drives - data
device for the PMR region for metadata and small or temporary files,
rt device w/ appropriate extent size for larges files in the SMR
region...

> E.g., I suppose somebody who is
> using traditional realtime (i.e., no SSD) and has a mix of legitimate
> realtime (streaming media) files and large sparse virt disk images or
> something of that nature would need to know to not use this feature
> (i.e., this requires documentation)..?

It wouldn't be enabled by default. We can't break existing rt device
setups, so I don't see any issue here. And, well, someone mixing
realtime and sparse virt in the same filesystem and storage isn't
going to get reliable realtime response. i.e. nobody in their right
mind mixes realtime streaming workloads with anything else - it's
always dedicated hardware for RT....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
