Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:53266 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdJ0K0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 06:26:32 -0400
Received: by mail-yw0-f194.google.com with SMTP id q126so5305039ywq.10
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2017 03:26:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgyirP4EiCmu48b8sE6wic9FU_5-M32eWCe8TD0Nknt7w@mail.gmail.com>
References: <20171026083322.20428-1-david@fromorbit.com> <20171026083322.20428-15-david@fromorbit.com>
 <CAOQ4uxik=-cXCdsdU03xN-y1YELYpTSng63shWMF2qg-fgVG8A@mail.gmail.com>
 <20171026124844.GB3666@dastard> <CAOQ4uxgyirP4EiCmu48b8sE6wic9FU_5-M32eWCe8TD0Nknt7w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Oct 2017 13:26:30 +0300
Message-ID: <CAOQ4uxjU71Nwjqid1e4ytXkzdoSoRa14tGtyLeEPDQCktgTYWw@mail.gmail.com>
Subject: Re: [PATCH 14/14] xfs: add growfs support for changing usable blocks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 26, 2017 at 4:32 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Oct 26, 2017 at 3:48 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Thu, Oct 26, 2017 at 02:30:22PM +0300, Amir Goldstein wrote:
>>> On Thu, Oct 26, 2017 at 11:33 AM, Dave Chinner <david@fromorbit.com> wrote:
>>> > From: Dave Chinner <dchinner@redhat.com>
>>> >
>>> > Now that we have persistent usable block counts, we need to be able
>>> > to change them. This allows us to control thin provisioned
>>> > filesystem space usage at the filesystem level, not the block device
>>> > level.
>>> >
>>> > If the grow operation grows the usable space beyond the current
>>> > LBA size of the filesystem, then we also need to physically grow the
>>> > filesystem to match the new size of the underlying device. Hence
>>> > grow behaves like it always has, expect for the fact that it wont'
>>> > grow physically until usable space would exceed the LBA size.
>>> >
>>> > Being able to modify usable space also allows us to shrink the
>>> > filesystem on thin devices as easily as growing it. We simply reduce
>>> > the usable space and the free space, and we're done. The user then
>>> > needs to run a fstrim pass to ensure all the unused space in the
>>> > filesystem LBA is marked as unused by the underlying device. No data
>>> > or metadata movement is required as the underlying LBA space has not
>>> > changed.
>>> >
>>> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
>>>
>>> With this change, behavior of userspace program that tried to shrink filesystem
>>> size will change from -EINVAL to success for filesystems that were configured
>>> to allow that. But unmodified userspace program may still be caught by surprise
>>> from this success return code that was never excersized in the past.
>>
>> What userspace program would be trying to shrink XFS filesystems
>> that doesn't already handle grow operations from the same ioctl call
>> returning success? Hell, I'd like to know what app is even trying to
>> shrink XFS filesystems...
>>
>
> A buggy program of course ;-)
>
>>> I have also argued elsewhere that the fact that the request to shrink the
>>> "virtual" size vs. physical size is implicit and not explicit, that would hinder
>>> future attempts to use the API as it was intended to implement physical shrink.
>>
>> No, feature bits decide the action to take without any ambiguity.
>>
>
> The ambiguity I was referring to was of the user program's intent.
> Did it request to the set filesystem size to N or filesystem usable size to N.
> When growing, the difference in intent doesn't change the result.

I take that back. I took a look at xfs_growfs.
If user requests to change only imaxpct xfs_growfs will set newblocks
to geo.datablocks, thus the user intent of "not changing data blocks"
when running an old version of xfs_growfs, is handled by current
patches as "blue moon is shining - give me the promised disk space".
Unless I am misunderstanding and geo.datablocks means usable
data block in FSGEOMETRY V4?

Don't see how you can get away without adding "my intent is to
modify usable blocks" to the API.
I hope you can prove me wrong, because the way you extended the
growfs API is very elegant.

Also, forgive me for not digging too deep myself to find the answer,
but is existing imaxpct being recalculated based on new usable_dblocks?
or does imaxpct still relative to total dblocks?

Thanks,
Amir.
