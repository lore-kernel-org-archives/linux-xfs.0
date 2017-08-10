Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:60466 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752317AbdHJL4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 07:56:25 -0400
Date: Thu, 10 Aug 2017 21:56:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] Stop searching for free slots in an inode chunk when
 there are none
Message-ID: <20170810115617.GN21024@dastard>
References: <20170807101710.18734-1-cmaiolino@redhat.com>
 <20170807151954.GB43920@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807151954.GB43920@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Aug 07, 2017 at 11:19:56AM -0400, Brian Foster wrote:
> On Mon, Aug 07, 2017 at 12:17:10PM +0200, Carlos Maiolino wrote:
> Also note that this has potential for performance side effects in the
> common (non-corruption) case.

I'm not seeing an issue here once the code is corrected. Probably
just me being dumb again, but could you point it out for me, Brian?

> It looks to me that it shouldn't be a major problem because it only
> affects the situation where the cached search "wraps" to the outside of
> the tree, and that probably doesn't happen often with a search distance
> of 10 records and a large tree. I am a bit curious where the
> searchdistance of 10 comes from though (we fit many more records in a
> single inobt leaf block)..?

It was chosen based on CPU profiles and performance measurement to
limit the CPU usage of the problem case the finobt now solves. i.e.
finding the frees inode in a tree that indexes several million
allocated inodes and the free inodes are few and far between. It was
chosen to cap inode allocation performance degradation when free
inodes were extremely sparse at around 50% of the "lots of free
inodes that are easy to find" performance.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
