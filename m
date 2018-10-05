Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53174 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbeJEUuu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 16:50:50 -0400
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
References: <20181004175839.18736-1-idryomov@gmail.com>
 <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
 <20181004222952.GV31060@dastard>
 <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <67627995-714c-5c38-a796-32b503de7d13@sandeen.net>
Date: Fri, 5 Oct 2018 08:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On 10/5/18 6:27 AM, Ilya Dryomov wrote:
> On Fri, Oct 5, 2018 at 12:29 AM Dave Chinner <david@fromorbit.com> wrote:
>>
>> On Thu, Oct 04, 2018 at 01:33:12PM -0500, Eric Sandeen wrote:
>>> On 10/4/18 12:58 PM, Ilya Dryomov wrote:
>>>> rbd devices report the following geometry:
>>>>
>>>>   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
>>>>   512
>>>>   512
>>>>   4194304
>>>>   4194304
>>
>> dm-thinp does this as well. THis is from the thinp device created
>> by tests/generic/459:
>>
>> 512
>> 4096
>> 65536
>> 65536
> 
> (adding Mike)
> 
> ... and that 300M filesystem ends up with 8 AGs, when normally you get
> 4 AGs for anything less than 4T.  Is that really intended?

Well, yes.  Multi-disk mode gives you more AGs, how many more is scaled
by fs size.

        /*
         * For the multidisk configs we choose an AG count based on the number
         * of data blocks available, trying to keep the number of AGs higher
         * than the single disk configurations. This makes the assumption that
         * larger filesystems have more parallelism available to them.
         */

For really tiny filesystems we cut down the number of AGs, but in general
if the storage "told" us it has parallelism, mkfs uses it by default.

> AFAIK dm-thinp reports these values for the same exact reason as rbd:
> we are passing up the information about the efficient I/O size.  In the
> case of dm-thinp, this is the thinp block size.  If you put dm-thinp on
> top of a RAID array, I suspect it would pass up the array's preferred
> sizes, as long as they are a proper factor of the thinp block size.
> 
> The high agcount on dm-thinp has come up before and you suggested that
> dm-thinp should report iomin == ioopt (i.e. sunit == swidth).  If that
> was the right fix back in 2014, mkfs.xfs must have regressed:
> 
>   https://marc.info/?l=linux-xfs&m=137783388617206&w=2

Well, that question started out as being about higher AG counts.  And
it did come from the stripe geometry advertised, but I don't think
Dave's suggestion was intended to keep the AG count lower, it was just
explaining that the values seemed wrong.  It was a bit of an odd situation,
the existence of stripe geometry bumped up AG count but then mkfs decided
that a 512 byte "stripe unit" wasn't legit, and set it back to zero.  But
kept the higher AG count.  So there a few related issues there.

>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fdfb4c8c1a9fc8dd8cf8eeb4e3ed83573b375285

So that sets them to the same size, but I don't think that change was
ever expected to change the AG count heuristic behavior, which has been
there for probably a decade or more.

>>
>> And I've also seen some hardware raid controllers do this, too,
>> because they only expose the stripe width in their enquiry page
>> rather than stripe unit and stripe width.

(which should be considered semi broken hardware, no?)

>> IOWs, this behaviour isn't really specific to Ceph's rbd device, and
>> it does occur on multi-disk devices that have something layered over
>> the top (dm-thinp, hardware raid, etc). As such, I don't think
>> there's a "one size fits all" solution and so someone is going to
>> have to tweak mkfs settings to have it do the right thing for their
>> storage subsystem....
> 
> FWIW I was surprised to see that calc_default_ag_geometry() doesn't
> look at swidth and just assumes that there will be "more parallelism
> available".  I expected it to be based on swidth to sunit ratio (i.e.
> sw).  sw is supposed to be the multiplier equal to the number of
> data-bearing disks, so it's the first thing that comes to mind for
> a parallelism estimate.
> 
> I'd argue that hardware RAID administrators are much more likely to pay
> attention to the output of mkfs.xfs and be able to tweak the settings
> to work around broken controllers that only expose stripe width.

Yeah, this starts to get a little philosophical.  We don't want to second
guess geometry or try to figure out what the raid array "really meant" if
it's sending weird numbers. [1]

But at the end of the day, it seems reasonable to always apply the
"swidth/sunit = number of data disks" rule  (which we apply in reverse when
we tell people how to manually figure out stripe widths) and stop treating
sunit==swidth as any indication of parallelism.

Dave, do you have any problem with changing the behavior to only go into
multidisk if swidth > sunit?  The more I think about it, the more it makes
sense to me.

-Eric


[1] for example,
    99a3f52 mkfs: avoid divide-by-zero when hardware reports optimal i/o size as 0
