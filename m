Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:61252 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750727AbeFVECb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 00:02:31 -0400
Date: Fri, 22 Jun 2018 14:02:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180622040221.GY19934@dastard>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
 <20180619161819.GD21698@magnolia>
 <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de>
 <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
 <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
 <20180621221911.GT19934@dastard>
 <CAJCQCtSzsYSyCD2eEvdgpKJ8ZFShsJrV2FxKZ4bv=-S6gpx2fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtSzsYSyCD2eEvdgpKJ8ZFShsJrV2FxKZ4bv=-S6gpx2fw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Jun 21, 2018 at 09:19:54PM -0600, Chris Murphy wrote:
> On Thu, Jun 21, 2018 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > The mkfs ratios are about as optimal as we can get for the
> > information we have about the storage - growing by
> > 10x (i.e.  increaseing the number of AGs by 10x) puts us at the
> > outside edge of the acceptible filesystem performance and longevity
> > charcteristics. Growing by 100x puts us way outside the window,
> > and examples like this where we are taking about growing by 10000x
> > is just way beyond anything the static AG layout architecture was
> > ever intended to support....
> 
> OK that's useful information, thanks.
> 
> What about from the other direction; is it possible to make an XFS
> file system too big, on an LVM thin volume?

That's harder, but still possible. e.g. to make a 40,000 AG
filesystem using the mkfs defaults, we're talking about a *40PB*
filesystem. That's going to hit limitations in dm-thinp long before
XFs becomes a problem....

> For example a 1TB drive, and I'm scratching my head at mkfs.xfs time
> and think maaaybe one day it could end up 25TB at the top end?

That's within the realm of "should work fine, but is pushing the
boundaries".

> So I
> figure do mkfs.xfs on a virtual LV of 5TB now and that gives me a 5x
> growfs if I really do hit 25TB one day. But for now, it's a 5TB XFS
> file system on a 1TB drive. Is there any negative performance effect
> if it turns out I never end up growing this file system (it lives
> forever on a 1TB drive as a 5TB virtual volume and file system)?

There's no harm to XFS in doing this - this is the basic premise of
handling thin provisioning space accounting at the filesystem level,
and it's fundamental to my subvolume work.

dm-thinp might have other ideas about how sane it is in the long
term, however.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
