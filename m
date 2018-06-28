Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17578 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752529AbeF1CFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 22:05:25 -0400
Date: Thu, 28 Jun 2018 12:05:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180628020504.GC2234@dastard>
References: <20180619161819.GD21698@magnolia>
 <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de>
 <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
 <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
 <20180621221911.GT19934@dastard>
 <CAJCQCtSzsYSyCD2eEvdgpKJ8ZFShsJrV2FxKZ4bv=-S6gpx2fw@mail.gmail.com>
 <20180622040221.GY19934@dastard>
 <20180627232333.GB21242@wotan.suse.de>
 <98c71f4a-94e5-00e8-46af-a4c3ca4e520b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98c71f4a-94e5-00e8-46af-a4c3ca4e520b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "swadmin - levigo.de" <swadmin@levigo.de>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Jun 27, 2018 at 06:37:31PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/27/18 6:23 PM, Luis R. Rodriguez wrote:
> > On Fri, Jun 22, 2018 at 02:02:21PM +1000, Dave Chinner wrote:
> >> On Thu, Jun 21, 2018 at 09:19:54PM -0600, Chris Murphy wrote:
> >>> On Thu, Jun 21, 2018 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>
> >>>> The mkfs ratios are about as optimal as we can get for the
> >>>> information we have about the storage - growing by
> >>>> 10x (i.e.  increaseing the number of AGs by 10x) puts us at the
> >>>> outside edge of the acceptible filesystem performance and longevity
> >>>> charcteristics. Growing by 100x puts us way outside the window,
> >>>> and examples like this where we are taking about growing by 10000x
> >>>> is just way beyond anything the static AG layout architecture was
> >>>> ever intended to support....
> > 
> > I don't  have time to test this but I can probably do so after my vacation
> > (now). Would it be best to just codify this eventually instead of having
> > this as tribal knowledge?
> 
> Honestly, if we wanted something like this I think it'd be based on terminal
> AG count, not growfs multiplier for a specific instance.

IMO, this belongs in the admin documentation (e.g. the growfs man
page), not the code. The people writing apps and automated
deployment scripts that grow filesystems need to know about this,
not the end users who simply use these pre-canned
apps/environments...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
