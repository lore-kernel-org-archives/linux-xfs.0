Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:45584 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932198AbdJZNcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 09:32:22 -0400
Received: by mail-yw0-f194.google.com with SMTP id j4so2906657ywb.2
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 06:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171026124844.GB3666@dastard>
References: <20171026083322.20428-1-david@fromorbit.com> <20171026083322.20428-15-david@fromorbit.com>
 <CAOQ4uxik=-cXCdsdU03xN-y1YELYpTSng63shWMF2qg-fgVG8A@mail.gmail.com> <20171026124844.GB3666@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 26 Oct 2017 16:32:20 +0300
Message-ID: <CAOQ4uxgyirP4EiCmu48b8sE6wic9FU_5-M32eWCe8TD0Nknt7w@mail.gmail.com>
Subject: Re: [PATCH 14/14] xfs: add growfs support for changing usable blocks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 26, 2017 at 3:48 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Oct 26, 2017 at 02:30:22PM +0300, Amir Goldstein wrote:
>> On Thu, Oct 26, 2017 at 11:33 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > From: Dave Chinner <dchinner@redhat.com>
>> >
>> > Now that we have persistent usable block counts, we need to be able
>> > to change them. This allows us to control thin provisioned
>> > filesystem space usage at the filesystem level, not the block device
>> > level.
>> >
>> > If the grow operation grows the usable space beyond the current
>> > LBA size of the filesystem, then we also need to physically grow the
>> > filesystem to match the new size of the underlying device. Hence
>> > grow behaves like it always has, expect for the fact that it wont'
>> > grow physically until usable space would exceed the LBA size.
>> >
>> > Being able to modify usable space also allows us to shrink the
>> > filesystem on thin devices as easily as growing it. We simply reduce
>> > the usable space and the free space, and we're done. The user then
>> > needs to run a fstrim pass to ensure all the unused space in the
>> > filesystem LBA is marked as unused by the underlying device. No data
>> > or metadata movement is required as the underlying LBA space has not
>> > changed.
>> >
>> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
>>
>> With this change, behavior of userspace program that tried to shrink filesystem
>> size will change from -EINVAL to success for filesystems that were configured
>> to allow that. But unmodified userspace program may still be caught by surprise
>> from this success return code that was never excersized in the past.
>
> What userspace program would be trying to shrink XFS filesystems
> that doesn't already handle grow operations from the same ioctl call
> returning success? Hell, I'd like to know what app is even trying to
> shrink XFS filesystems...
>

A buggy program of course ;-)

>> I have also argued elsewhere that the fact that the request to shrink the
>> "virtual" size vs. physical size is implicit and not explicit, that would hinder
>> future attempts to use the API as it was intended to implement physical shrink.
>
> No, feature bits decide the action to take without any ambiguity.
>

The ambiguity I was referring to was of the user program's intent.
Did it request to the set filesystem size to N or filesystem usable size to N.
When growing, the difference in intent doesn't change the result.
When shrinking AND feature bit is set, the intent makes a difference.

>> Suggestion:
>> Let userspace opt-in for the new "virtual grow" API by using the 3 upper
>> bytes in (struct xfs_growfs_data){.imaxpct}.
>> Those byes are guarantied to be zeroed by old application due to value
>> range check in current code, so there is plenty of room to add flags byte
>> and use it to request to grow USABLE_DBLOCK explicitly.
>
> What's the point of adding this complexity? AFAICT it's a solution
> for a problem that doesn't exist....
>

AFAICT you are right, but API review is a bit like legal contract review -
picking to problem that don't seem to exist - until one day we realize
that they do...

>> All the logic in your code stays the same (i.e. grow physical to accomodate
>> for growing virtual) only we stir away from being called by old apps by
>> mistake.
>
> My care factor about old 3rd party apps that have never been able to
> test that shrink code path actually succeeded because the kernel
> didn't support it is pretty damn close to zero.
>
> Actually, wait ..... Ahhhhh. I have just reached the state of Care
> Factor Zero. :)
>

Look to your right. I am right there with you :)
Anyway, I think that the cost of being wrong on this one is not so high
(famous last words)

Cheers,
Amir.
