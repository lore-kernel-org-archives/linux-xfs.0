Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30789 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S942877AbdDTXQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 19:16:09 -0400
Date: Fri, 21 Apr 2017 09:16:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
Message-ID: <20170420231603.GJ12369@dastard>
References: <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
 <20170419180811.GB41631@bfoster.bfoster>
 <268ce851-dad0-a777-526a-82ad967490cd@dermichi.com>
 <20170419205525.GD5205@birch.djwong.org>
 <86fbec25-f026-350b-ffe3-b0b182b768ac@dermichi.com>
 <20170419234838.GH12369@dastard>
 <f3e222a4-bcdb-6c61-79b0-1450c12e054f@dermichi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3e222a4-bcdb-6c61-79b0-1450c12e054f@dermichi.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Weissenbacher <mw@dermichi.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Apr 20, 2017 at 09:11:22AM +0200, Michael Weissenbacher wrote:
> On 20.04.2017 01:48, Dave Chinner wrote:
> > On Wed, Apr 19, 2017 at 11:47:43PM +0200, Michael Weissenbacher wrote:
> >> OK, do i understand you correctly that the xfsaild does all the actual
> >> work of updating the inodes? And it's doing that single-threaded,
> >> reading both the log and the indoes themselves?
> > 
> > The problem is that the backing buffers that are used for flushing
> > inodes have been reclaimed due to memory pressure, but the inodes in
> > cache are still dirty. Hence to write the dirty inodes, we first
> > have to read the inode buffer back into memory.
> > 
> Interesting find. Is there a way to prevent those buffers from getting
> reclaimed?

Not really. It's simply a side effect of memory reclaim not being
able to reclaim inodes or the page cache because they are dirty, and
so it goes and puts lots more pressure on clean caches. The working
set in those other caches gets trashed, and this it's a downward
spiral because it means dirty inodes and pages take longer are
require blocking IO to refill on demand...

> Would adjusting vfs_cache_pressure help?

Unlikely.

> Or adding more
> memory to the system?

Unlikely - that'll just lead to bigger stalls.

> In fact the best thing would be to disable file
> content caching completely. Because of the use-case (backup server) it's
> worthless to cache file content.
> My primary objective is to avoid those stalls and reduce latency, at the
> expense of throughput.

Set up dirty page cache writeback thresholds to be low (a couple of
hundred MB instead of 10/20% of memory) so that data writeback
starts early and throttles dirty pages to a small amount of memory.
This will help keep the page cache clean and immediately
reclaimable, hence it shouldn't put as much pressure on other caches
when memory reclaim is required.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
