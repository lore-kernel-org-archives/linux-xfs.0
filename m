Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:37607 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbeJEFZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 01:25:27 -0400
Date: Fri, 5 Oct 2018 08:29:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
Message-ID: <20181004222952.GV31060@dastard>
References: <20181004175839.18736-1-idryomov@gmail.com>
 <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ilya Dryomov <idryomov@gmail.com>, linux-xfs@vger.kernel.org, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>

On Thu, Oct 04, 2018 at 01:33:12PM -0500, Eric Sandeen wrote:
> On 10/4/18 12:58 PM, Ilya Dryomov wrote:
> > rbd devices report the following geometry:
> > 
> >   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
> >   512
> >   512
> >   4194304
> >   4194304

dm-thinp does this as well. THis is from the thinp device created
by tests/generic/459:

512
4096
65536
65536

And I've also seen some hardware raid controllers do this, too,
because they only expose the stripe width in their enquiry page
rather than stripe unit and stripe width.

IOWs, this behaviour isn't really specific to Ceph's rbd device, and
it does occur on multi-disk devices that have something layered over
the top (dm-thinp, hardware raid, etc). As such, I don't think
there's a "one size fits all" solution and so someone is going to
have to tweak mkfs settings to have it do the right thing for their
storage subsystem....

Indeed, does Ceph really needs 4MB aligned filesystem IO? What
performance benefit does that give over setting iomin=PAGE_SIZE and
ioopt=0? (i.e mkfs.xfs -d sunit=0,swidth=0 or just mounting with -o
noalign)


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
