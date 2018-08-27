Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42624 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbeH0L6d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Aug 2018 07:58:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id v17-v6so12713895wrr.9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Aug 2018 01:12:58 -0700 (PDT)
Date: Mon, 27 Aug 2018 10:12:54 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Trying to write to read-only block-device from XFS
Message-ID: <20180827081254.zat4lvxqviwgd4zn@odin.usersys.redhat.com>
References: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
 <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
 <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
 <c6bcbef0-0c5b-a7a1-adb6-38085db98ce9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6bcbef0-0c5b-a7a1-adb6-38085db98ce9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-xfs@vger.kernel.org

Hi.

On Sat, Aug 25, 2018 at 09:25:33PM -0500, Eric Sandeen wrote:
> 
> 
> On 8/25/18 9:09 AM, Andi Kleen wrote:
> > On Fri, Aug 24, 2018 at 07:58:05PM -0500, Eric Sandeen wrote:
> >> On 8/24/18 6:37 PM, Andi Kleen wrote:
> >>>
> >>> Seen this a few times now with recent kernels:
> >>
> >> Hi Andi -
> >>
> >> Dumb question maybe, but just to be clear -
> >> Was this an RO mount on an RO device, or something else?
> >> What type of mount was this?
> > 
> > Was just a normal RW partition on a normal SSD. I didn't do anything
> > special to make it RO.
> 
> I don't know why it shows up as RO at this point, but maybe this fixes it:
> 
> commit b089cfd95d32638335c551651a8e00fd2c4edb0b
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Aug 14 10:52:40 2018 -0600
> 
>     block: don't warn for flush on read-only device
>     
>     Don't warn for a flush issued to a read-only device. It's not strictly
>     a writable command, as it doesn't change any on-media data by itself.
>     
>     Reported-by: Stefan Agner <stefan@agner.ch>
>     Fixes: 721c7fc701c7 ("block: fail op_is_write() requests to read-only partitions")
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>

This kind of 'problem' is being reported quite often now. It all started with
commit:

commit 721c7fc701c71f693307d274d2b346a1ecd4a534
Author: Ilya Dryomov <idryomov@gmail.com>
Date:   Thu Jan 11 14:09:11 2018 +0100

    block: fail op_is_write() requests to read-only partitions

Which basically added a generic check for RO devices into generic_make_request()
code path, as a way to enforce ioctl(BLKROSET), so far, write requests were
never checked.


Then, Linus applied the following commit:

commit a32e236eb93e62a0f692e79b7c3c9636689559b9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Aug 3 12:22:09 2018 -0700

    Partially revert "block: fail op_is_write() requests to read-only partitions"

Once a few layers like LVM, didn't expect the device to enforce RO, which kept
writing to the device while snapshotting, even if the device has been marked as
RO.

And then came the commit mentioned by Eric:

commit b089cfd95d32638335c551651a8e00fd2c4edb0b
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Aug 14 10:52:40 2018 -0600

    block: don't warn for flush on read-only device


Which relaxed the rules a bit and basically let flushes to proceed without warnings.

Essentially, this isn't a XFS problem, and most likely you are using XFS on top
of some layer like LVM, and/or using snapshots, and your underlying volume went
read-only behind XFS for some reason.

Cheers



-- 
Carlos
