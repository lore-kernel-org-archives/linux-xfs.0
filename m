Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38471 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932350AbeF1ITn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 04:19:43 -0400
Received: by mail-wm0-f65.google.com with SMTP id 69-v6so7977715wmf.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 01:19:43 -0700 (PDT)
Date: Thu, 28 Jun 2018 10:19:39 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180628081939.ryjsimtzqo2ig5sf@odin.usersys.redhat.com>
References: <e9a7c539-1dea-1050-19bc-b0eb7e788b33@sandeen.net>
 <20180621191535.GI7508@wotan.suse.de>
 <89d39e37-3944-f58d-018c-d36bdc9f870c@sandeen.net>
 <CAJCQCtSHT7fcHHxBaTESq5cdQQnYH95maNHby4MULCkar6mfeg@mail.gmail.com>
 <20180621221911.GT19934@dastard>
 <CAJCQCtSzsYSyCD2eEvdgpKJ8ZFShsJrV2FxKZ4bv=-S6gpx2fw@mail.gmail.com>
 <20180622040221.GY19934@dastard>
 <20180627232333.GB21242@wotan.suse.de>
 <98c71f4a-94e5-00e8-46af-a4c3ca4e520b@sandeen.net>
 <20180628020504.GC2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628020504.GC2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Jun 28, 2018 at 12:05:04PM +1000, Dave Chinner wrote:
> On Wed, Jun 27, 2018 at 06:37:31PM -0500, Eric Sandeen wrote:
> > 
> > 
> > On 6/27/18 6:23 PM, Luis R. Rodriguez wrote:
> > > On Fri, Jun 22, 2018 at 02:02:21PM +1000, Dave Chinner wrote:
> > >> On Thu, Jun 21, 2018 at 09:19:54PM -0600, Chris Murphy wrote:
> > >>> On Thu, Jun 21, 2018 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >>>
> > >>>> The mkfs ratios are about as optimal as we can get for the
> > >>>> information we have about the storage - growing by
> > >>>> 10x (i.e.  increaseing the number of AGs by 10x) puts us at the
> > >>>> outside edge of the acceptible filesystem performance and longevity
> > >>>> charcteristics. Growing by 100x puts us way outside the window,
> > >>>> and examples like this where we are taking about growing by 10000x
> > >>>> is just way beyond anything the static AG layout architecture was
> > >>>> ever intended to support....
> > > 
> > > I don't  have time to test this but I can probably do so after my vacation
> > > (now). Would it be best to just codify this eventually instead of having
> > > this as tribal knowledge?
> > 
> > Honestly, if we wanted something like this I think it'd be based on terminal
> > AG count, not growfs multiplier for a specific instance.
> 

Agreed. The biggest issue here is the amount of AGs, not the filesystem size
directly, which, for this to work in a reliable way, we'd need to store the
'original' AG count from when the FS was created, otherwise, as Eric stated,
nothing prevents somebody to use growfs several times, instead of growing the FS
in a single time.

Although, this makes me wonder if we somehow couldn't make it a bit more
flexible in the future, but I think that's where Dave's subvolume work comes in?


> IMO, this belongs in the admin documentation (e.g. the growfs man
> page), not the code. The people writing apps and automated
> deployment scripts that grow filesystems need to know about this,
> not the end users who simply use these pre-canned
> apps/environments...
> 

+1, most people who will look into the code already know this, users of grow FS
doesn't, so this belongs to the man page IMHO.

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

-- 
Carlos
