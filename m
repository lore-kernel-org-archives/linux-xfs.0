Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34740 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbcLLFGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 00:06:40 -0500
Received: by mail-wj0-f195.google.com with SMTP id xy5so9671960wjc.1
        for <linux-xfs@vger.kernel.org>; Sun, 11 Dec 2016 21:06:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161212015959.GT4326@dastard>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
 <20161212015959.GT4326@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 12 Dec 2016 07:06:37 +0200
Message-ID: <CAOQ4uxhiOb9SBgDaqjY5gQ+Z99BRWCFtc=vyGiB4PmXyDYQQZA@mail.gmail.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Dec 12, 2016 at 3:59 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Dec 10, 2016 at 10:04:39AM +0200, Amir Goldstein wrote:
>> Dave,
>>
>> I would like to have some system's storage pre-formatted
>> with rmapbt and reflink support without allowing reflink until
>> the day comes where the feature is declared stable.
>
> Amir, you should have realised by now that - as a matter of policy -
> I simply say no to anything that is intended as a short-term
> convenience for a special interest use case that has no long term
> benefit to the wider community.
>

Absolutely! I heard that loud and clear and I fully agree with you.
I am putting my use case out there in hope that others that share a
similar use case can chime in.


> Your timeline for downstream customer feature delivery don't change
> our upstream feature stabilisation and support plans.  If you want
> to run your user base on reflink=1 filesystems on 4.9 kernels then
> feel free to support them directly. That's enitrely your own choice
> made entirely your own risk as a downstream distributor.  We'll
> triage and fix bugs as you report them and incorporate fixes and
> improvements as relevant, but we're not going to do any more than
> that.  "Use at your own risk" means exactly that.
>

This makes sense. To be clear, my intention was not exactly to run
4.9 with reflink=1, but to run 4.9 with "reflink pre-formatted".
That means addressing exactly the issues you mentioned below
of preallocating the refcountbt space in all AGs.
Hence, my suggestion to split the feature refcountbt=1 from reflink=1
where the former means maintain the refcount=1 tree and the latter
to allow refcount>1.

But as Darrick correctly noted, there is no real point of maintaining
recount=1 tree that can be easily calculated when enabling refcount,
so it is sufficient to set a feature flag (or geometry property) to always
reserve space for the reflink feature.

This split of reflink to "ready" and "effective" should be simple enough
that I should be able to maintain it out of tree, but I will always prefer an
acceptable upstreamed solution - second best choice is out of tree
solution which you are willing to endorse as being the least crazy.

Naturally, in that case, I will have also provided a lot of testing to the
upgrade in the lab and down the road in production systems.

> FWIW, Christoph has taken this "downstream risk" path for his own
> clients and customers that are using the reflink functionality in
> their systems. He doesn't bother us with triaging or fixing issues
> his customers hit; all we see from him is a constant stream of bug
> fixes and improvements to the experimental features his customers
> are using...
>

If I have to go down that path I will, but only as last resort.

>> Considering these options for said systems:
>> 1. kernel v4.8.y or v4.9.y and mkfs.xfs -m rmapbt=1
>> 2. kernel v4.9.y and mkfs.xfs -m rmapbt=1
>> 3. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflink=1
>>     and new mount option -onoreflink
>> 4. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflinkbt=1
>>     (separate rocomapt features reflinkbt from reflink)
>>
>> Options 1-2 would require adding support in xfs_admin to
>> enable reflink on an existing fs
>
> If we can properly design and implement the addition of the reflink
> btree and reliably test it then this would be my preferred option.

That's all I needed to hear.
If Darrick won't pick up that glove I will.
Testing is definitely on me.

> However, I can see lots of intricate problems with adding reflink
> after the fact.  e.g. if we've already got a full AG we won't be
> able to have the refcount btree added to it dynamically, so how do
> we prevent this sort of failure half way through the conversion?
>

All the more reason to preallocate that space anyway with mkfs.xfs
v4.9. If we should do that for the general case and under what options,
it is really up to you. But I am most definitely going to have to make that
adjustments for our systems, so when I get to it I will share whatever
I did.


>
>> Option 3 would require adding a simple noreflink
>> mount option to disable reflink related ops.
>
> You can add it to your own kernels easily enough, but don't expect
> us to carry one-off, special case mount options like this in the
> upstream kernel.
>

Of course. It's an easy patch to carry out of tree until D-day.
Probably the easiest option for me, so if the preferred solution
(option 2) doesn't go through, I will go with this one.

>> Option 4 requires changing mkfs.xfs before 4.9 release
>> and possibly setting recompat feature reflink on first file
>> reflink. There are several precedents to this sort of  "set
>> on first use" feature in ext4, not sure if there are any in xfs.
>
> There's a few in XFS, historically speaking (attribute fork layout,
> v1->v2 inodes, etc). These days, however, we tend to avoid silent
> dynamic feature bit addition because of the "upgrade kernel, random
> feature bit gets added silently, upgrade causes other problems,
> downgrade kernel, old kernel can't mount fs anymore" type of
> problem it can cause the wider userbase.
>
> FWIW, setting a feature bit on first reflink will require kernel
> changes, and the soonest you'd get them into the kernel is 4.11 if
> all the issues and problems could be sorted before then. So this
> doesn't help you at all for the 4.9 kernel. It also requires that
> the recountbt is being maintained for refcount=1 extents, otherwise
> it introduces all the same problems as options 1-2. IMO, this is the
> least appealing of all the options you presented.
>

I agree. option 4 is not appealing to me as I have no requirement
to enable reflink online. I proposed it only in case somebody else
does.

Thanks for clearing out my questions.
Amir.
