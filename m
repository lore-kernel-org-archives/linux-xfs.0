Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AA1C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 02:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ED4D20714
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 02:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCRC12 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 22:27:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40015 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726250AbgCRC12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 22:27:28 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EF77D82186D;
        Wed, 18 Mar 2020 13:27:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jEOQR-0006Cf-OE; Wed, 18 Mar 2020 13:27:19 +1100
Date:   Wed, 18 Mar 2020 13:27:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Ober, Frank" <frank.ober@intel.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dimitri <dimitri.kravtchuk@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Barczak, Mariusz" <mariusz.barczak@intel.com>,
        "Barajas, Felipe" <felipe.barajas@intel.com>
Subject: Re: write atomicity with xfs ... current status?
Message-ID: <20200318022719.GV10776@dread.disaster.area>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200316215913.GV256767@magnolia>
 <20200316233240.GR10776@dread.disaster.area>
 <MW3PR11MB4697D889E18319F7231F49BD8BF60@MW3PR11MB4697.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW3PR11MB4697D889E18319F7231F49BD8BF60@MW3PR11MB4697.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=5pmI3rqjlU5mmicDnq0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[ Hi Frank, you email program is really badly mangling quoting and
line wrapping. Can you see if you can get it to behave better for
us? I think I've fixed it below. ]

On Tue, Mar 17, 2020 at 10:56:53PM +0000, Ober, Frank wrote:
> Thanks Dave and Darrick, adding Dimitri Kravtchuk from Oracle to
> this thread.
> 
> If Intel produced an SSD that was atomic at just the block size
> level (as in using awun - atomic write unit of the NVMe spec)

What is this "atomic block size" going to be, and how is it going to
be advertised to the block layer and filesystems?

> would that constitute that we could do the following

> > We've plumbed RWF_DSYNC to use REQ_FUA IO for pure overwrites if
> > the hardware supports it. We can do exactly the same thing for
> > RWF_ATOMIC - it succeeds if:
> > 
> > - we can issue it as a single bio
> > - the lower layers can take the entire atomic bio without
> >   splitting it. 
> > - we treat O_ATOMIC as O_DSYNC so that any metadata changes
> >   required also get synced to disk before signalling IO
> >   completion. If no metadata updates are required, then it's an
> >   open question as to whether REQ_FUA is also required with
> >   REQ_ATOMIC...
> > 
> > Anything else returns a "atomic write IO not possible" error.

So, as I said, your agreeing that an atomic write is essentially a
variant of a data integrity write but has more strict size and
alignment requirements and a normal RWF_DSYNC write?

> One design goal on the hw side, is to not slow the SSD down, the
> footprint of firmware code is smaller in an Optane SSD and we
> don't want to slow that down.

I really don't care what the impact on the SSD firmware size or
speed is - if the hardware can't guarantee atomic writes right down
to the physical media with full data integrity guarantees, and/or
doesn't advertise it's atomic write limits to the OS and filesystem
then it's simply not usable.

Please focus on correctness of behaviour first - speed is completely
irrelevant if we don't have correctness guarantees from the
hardware.

> What's the fastest approach for
> something like InnoDB writes? Can we take small steps that produce
> value for DirectIO and specific files which is common in databases
> architectures even 1 table per file ? Streamlining one block size
> that can be tied to specific file opens seems valuable.

Atomic writes have nothing to do with individual files. Either the
device under the filesystem can do atomic writes or it can't. What
files we do atomic writes to is irrelevant; What we need to know at
the filesystem level is the alignment and size restrictions on
atomic writes so we can allocate space appropriately and/or reject
user IO as out of bounds.

i.e. we already have size and alignment restrictions for direct IO
(typically single logical sector size). For atomic direct IO we will
have a different set of size and alignment restrictions, and like
the logical sector size, we need to get that from the hardware
somehow, and then make use of it in the filesystem appropriately.

Ideally the hardware would supply us with a minimum atomic IO size
and alignment and a maximum size. e.g. minimum might be the
physical sector size (we can always do atomic physical sector
size/aligned IOs) but the maximum is likely going to be some device
internal limit. If we require a minimum and maximum from the device
and the device only supports one atomic IO size can simply set
min = max.

Then it will be up to the filesystem to align extents to those
limits, and prevent user IOs that don't match the device
size/alignment restrictions placed on atomic writes...

But, first, you're going to need to get sane atomic write behaviour
standardised in the NVMe spec, yes? Otherwise nobody can use it
because we aren't guaranteed the same behaviour from device to
device...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
