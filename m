Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:39532 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbeJESZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 14:25:59 -0400
Received: by mail-it1-f194.google.com with SMTP id w200-v6so2207448itc.4
        for <linux-xfs@vger.kernel.org>; Fri, 05 Oct 2018 04:27:37 -0700 (PDT)
MIME-Version: 1.0
References: <20181004175839.18736-1-idryomov@gmail.com> <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
 <20181004222952.GV31060@dastard>
In-Reply-To: <20181004222952.GV31060@dastard>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 5 Oct 2018 13:27:25 +0200
Message-ID: <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On Fri, Oct 5, 2018 at 12:29 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Oct 04, 2018 at 01:33:12PM -0500, Eric Sandeen wrote:
> > On 10/4/18 12:58 PM, Ilya Dryomov wrote:
> > > rbd devices report the following geometry:
> > >
> > >   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
> > >   512
> > >   512
> > >   4194304
> > >   4194304
>
> dm-thinp does this as well. THis is from the thinp device created
> by tests/generic/459:
>
> 512
> 4096
> 65536
> 65536

(adding Mike)

... and that 300M filesystem ends up with 8 AGs, when normally you get
4 AGs for anything less than 4T.  Is that really intended?

AFAIK dm-thinp reports these values for the same exact reason as rbd:
we are passing up the information about the efficient I/O size.  In the
case of dm-thinp, this is the thinp block size.  If you put dm-thinp on
top of a RAID array, I suspect it would pass up the array's preferred
sizes, as long as they are a proper factor of the thinp block size.

The high agcount on dm-thinp has come up before and you suggested that
dm-thinp should report iomin == ioopt (i.e. sunit == swidth).  If that
was the right fix back in 2014, mkfs.xfs must have regressed:

  https://marc.info/?l=linux-xfs&m=137783388617206&w=2
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fdfb4c8c1a9fc8dd8cf8eeb4e3ed83573b375285

>
> And I've also seen some hardware raid controllers do this, too,
> because they only expose the stripe width in their enquiry page
> rather than stripe unit and stripe width.
>
> IOWs, this behaviour isn't really specific to Ceph's rbd device, and
> it does occur on multi-disk devices that have something layered over
> the top (dm-thinp, hardware raid, etc). As such, I don't think
> there's a "one size fits all" solution and so someone is going to
> have to tweak mkfs settings to have it do the right thing for their
> storage subsystem....

FWIW I was surprised to see that calc_default_ag_geometry() doesn't
look at swidth and just assumes that there will be "more parallelism
available".  I expected it to be based on swidth to sunit ratio (i.e.
sw).  sw is supposed to be the multiplier equal to the number of
data-bearing disks, so it's the first thing that comes to mind for
a parallelism estimate.

I'd argue that hardware RAID administrators are much more likely to pay
attention to the output of mkfs.xfs and be able to tweak the settings
to work around broken controllers that only expose stripe width.

>
> Indeed, does Ceph really needs 4MB aligned filesystem IO? What
> performance benefit does that give over setting iomin=PAGE_SIZE and
> ioopt=0? (i.e mkfs.xfs -d sunit=0,swidth=0 or just mounting with -o
> noalign)

As I said in the patch, 4M is unnecessarily high.  However, bluestore
is typically configured with a 64K block size and does journal anything
smaller than that.

Thanks,

                Ilya
