Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:19854 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935188AbcKJVbj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2016 16:31:39 -0500
Date: Fri, 11 Nov 2016 08:30:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: Metadata corruption detected at xfs_attr3_leaf_read_verify
Message-ID: <20161110213057.GH28922@dastard>
References: <5244720.RPRsZ88NJ0@libor-nb>
 <2639114.hBi4OJ80y2@libor-nb>
 <20161110052915.GG28922@dastard>
 <2152865.L3K5Xz7SXO@libor-nb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2152865.L3K5Xz7SXO@libor-nb>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Nov 10, 2016 at 05:04:48PM +0100, Libor Klepáč wrote:
> On čtvrtek 10. listopadu 2016 16:29:15 CET Dave Chinner wrote:
> > Which:
> > > > Phase 3 - for each AG...
> > > > 
> > > >         - scan (but don't clear) agi unlinked lists...
> > > >         - process known inodes and perform inode discovery...
> > > >         - agno = 0
> > > >         - agno = 1
> > > > 
> > > > Metadata corruption detected at xfs_attr3_leaf block 0x12645ef8/0x1000
> > > > Metadata corruption detected at xfs_attr3_leaf block 0x12f63f40/0x1000
> > 
> > These two blocks. It looks like repair didn't clean them up?
> > 
> > Hmmmm - looking at the code I'm not sure that repair detects and
> > removes empty attr leaf blocks, which would explain why the error
> > showed up again.. Can you provide a metadump of the filesystem so we
> > can did into the exact neature of the problem you are seeing?
> 
> Sure not a problem. How much time will it take giving xfs_repair took approx 40 minutes?

No longer than that, with agood possibility it will be much faster
as metadump only needs 1 pass over the metadata, not three...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
