Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:58486 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731555AbeHAF6d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 01:58:33 -0400
Date: Wed, 1 Aug 2018 14:12:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agcount 33 by default for a single HDD?
Message-ID: <20180801041204.GH2234@dastard>
References: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 07:32:50PM -0600, Chris Murphy wrote:
> This seems suboptimal.

It's actually a very useful optimisation to make on thin devices.

> Basically this is a 750G thin volume. I don't
> have a plain partition on a device handy to try this out but I'm
> pretty certain the default is 4 AG's in that case, so I'm confused why
> by default 33 AGs are created on a thin volume. The LVM volume group
> is on a dmcrypt PV.

It's a thin volume, therefore it advertises an optimal IO size and
alignment setting (i.e. the thin volume allocation chunk size).
Hence mkfs.xfs treats it as a "multi-disk device" and sets up
alignment and AG count appropriately.

This is actually the right optimisation to make for sparse devices -
more AGs increase filesystem concurrency but we normally restrict it
on single spindles because each AG adds more seeks into typical
workloads and slows them down. However, the thin volume already adds
that penalty to the storage stack for us because they don't have a
linear LBA-to-physical location characteristic.  Hence we can
increase filesystem concurrency without addition performance
penalties being incurred.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
