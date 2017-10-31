Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:50460 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbdJaEtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 00:49:03 -0400
Received: by mail-yw0-f195.google.com with SMTP id i198so13660479ywe.7
        for <linux-xfs@vger.kernel.org>; Mon, 30 Oct 2017 21:49:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171030210941.GA5858@dastard>
References: <20171026083322.20428-1-david@fromorbit.com> <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 31 Oct 2017 06:49:01 +0200
Message-ID: <CAOQ4uxjidk5T=g+uUooqXVunOCf2n2mfKXPGXnSzPEqFYJ=LFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 30, 2017 at 11:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
>> On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
...
>> Finally, I tend to agree with Amir's comment with regard to
>> shrink/growfs... at least infosar as I understand his concern. If we do
>> support physical shrink in the future, what do we expect the interface
>> to look like in light of this change?
>
> I don't expect it to look any different. It's exactly the same as
> growfs - thinspace filesystem will simply do a logical grow/shrink,
> fat filesystems will need to do a physical grow/shrink
> adding/removing AGs.
>
> I suspect Amir is worried about the fact that I put "LBA_size"
> in geom.datablocks instead of "usable_space" for thin-aware
> filesystems (i.e. I just screwed up writing the new patch). Like I
> said, I haven't updated the userspace stuff yet, so the thinspace
> side of that hasn't been tested yet. If I screwed up xfs_growfs (and
> I have because some of the tests are reporting incorrect
> post-grow sizes on fat filesytsems) I tend to find out as soon as I
> run it.
>
> Right now I think using m_LBA_size and m_usable_space in the geom
> structure was a mistake - they should remain the superblock values
> because otherwise the hidden metadata reservations can affect what
> is reported to userspace, and that's where I think the test failures
> are coming from....
>

I see. I suppose you intend to expose m_LBA_size in a new V5 geom value.
(geom.LBA_blocks?)
Does it make sense to expose the underlying bdev size in the same V5 geom
value for fat fs?
Does it make sense to expose yet another geom value for "total_blocks"?

The interpretation of former geom.datablocks will be "dblocks soft limit"
The interpretation of new geom.LBA_blocks will be "dblocks hard limit"
The interpretation of existing growfs will be "increase dblock soft limit",
but only up to dblocks hard limit.
This interpretation would be consistent for both thin and fat fs.

A future API for physical shrink/grow can be deployed to change
"dblocks hard limit", which may involve communicating with blockdev
(e.g. LVM) via standard interface (i.e. truncate()/fallocate()) to shrink
or grow it if volume is fat and to allocate/punch it if volume is thin.

>
>> FWIW, I also think there's an
>> element of design/interface consistency to the argument (aside from the
>> concern over the future of the physical shrink api). We've separated
>> total blocks from usable blocks in other userspace interfaces
>> (geometry). Not doing so for growfs is somewhat inconsistent, and also
>> creates confusion over the meaning of newblocks in different contexts.
>
> It has to be done for the geometry info so that xfs_info can report
> the thinspace size of the filesytem in addition to the physical
> size. It does not need to be done to make growfs work correctly.
>
>> Given that this already requires on-disk changes and the addition of a
>> feature bit, it seems prudent to me to update the growfs API
>> accordingly. Isn't a growfs new_usable_blocks field or some such all we
>> really need to address that concern?
>
> I really do not see any reason for changing the growfs interface
> right now. If there's a problem in future that physical shrink
> introduces, we can rev the interface when the problem arises.
>

At the moment, I don't see a problem either.
I just feel like there may be opportunities to improve fs/volume management
integration for fat fs/volumes as well, so we need to keep them in mind when
designing the new APIs.

Cheers,
Amir.
