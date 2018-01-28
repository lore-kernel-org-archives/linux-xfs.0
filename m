Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21047 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751564AbeA1B6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 20:58:54 -0500
Date: Sun, 28 Jan 2018 12:59:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Message-ID: <20180128015949.qtlu4r6mzcj7ihdh@destitution>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
 <010201613894cb3c-2d39d6ae-57f4-468c-a50c-5f44fda73f5b-000000@eu-west-1.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010201613894cb3c-2d39d6ae-57f4-468c-a50c-5f44fda73f5b-000000@eu-west-1.amazonses.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Raiber <martin@urbackup.org>
Cc: linux-xfs@vger.kernel.org

On Sat, Jan 27, 2018 at 05:05:31PM +0000, Martin Raiber wrote:
> On 25.01.2018 06:51 Dave Chinner wrote:
> > The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> > snapshot support I'm working on has been uploaded and can be found
> > here:
> >
> > https://www.youtube.com/watch?v=wG8FUvSGROw
> >
> > I don't have the code in a reviewable form yet - there's still quite
> > a bit of work before I get to that point, but this is a good
> > introduction to how all the pieces will fit together....
> 
> Great talk!
> 
> I'm pretty sure it's hard to add, but cross-subvolume reflinks would be
> something useful for my use case.

That's not going to happen. reflinks across subvolumes (i.e. across
independent filesystems) will return -EXDEV. If you want subvolumes
to share data blocks of independent ancestry, then you can run
deduplication operations on the image files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
