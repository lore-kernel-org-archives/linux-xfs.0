Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5911 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753810AbcLLCAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Dec 2016 21:00:04 -0500
Date: Mon, 12 Dec 2016 12:59:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Message-ID: <20161212015959.GT4326@dastard>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Sat, Dec 10, 2016 at 10:04:39AM +0200, Amir Goldstein wrote:
> Dave,
> 
> I would like to have some system's storage pre-formatted
> with rmapbt and reflink support without allowing reflink until
> the day comes where the feature is declared stable.

Amir, you should have realised by now that - as a matter of policy -
I simply say no to anything that is intended as a short-term
convenience for a special interest use case that has no long term
benefit to the wider community.

Your timeline for downstream customer feature delivery don't change
our upstream feature stabilisation and support plans.  If you want
to run your user base on reflink=1 filesystems on 4.9 kernels then
feel free to support them directly. That's enitrely your own choice
made entirely your own risk as a downstream distributor.  We'll
triage and fix bugs as you report them and incorporate fixes and
improvements as relevant, but we're not going to do any more than
that.  "Use at your own risk" means exactly that.

FWIW, Christoph has taken this "downstream risk" path for his own
clients and customers that are using the reflink functionality in
their systems. He doesn't bother us with triaging or fixing issues
his customers hit; all we see from him is a constant stream of bug
fixes and improvements to the experimental features his customers
are using...

> Considering these options for said systems:
> 1. kernel v4.8.y or v4.9.y and mkfs.xfs -m rmapbt=1
> 2. kernel v4.9.y and mkfs.xfs -m rmapbt=1
> 3. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflink=1
>     and new mount option -onoreflink
> 4. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflinkbt=1
>     (separate rocomapt features reflinkbt from reflink)
> 
> Options 1-2 would require adding support in xfs_admin to
> enable reflink on an existing fs

If we can properly design and implement the addition of the reflink
btree and reliably test it then this would be my preferred option.
However, I can see lots of intricate problems with adding reflink
after the fact.  e.g. if we've already got a full AG we won't be
able to have the refcount btree added to it dynamically, so how do
we prevent this sort of failure half way through the conversion?

And if we do fail half way through the conversion (for whatever
reason), how the hell do we clean up the mess reliably?

So while this seems simple in concept, I don't think the
implementation is going to be simple regardless of whether we do the
conversion online or offline. It'll be yet more experimental code
that will take a good length of time to test and stabilise, and has
the definite possibility of making it take longer to stabilise the
reflink feature..

>From this persepective, it makes no sense for upstream invest time
and effort into dynamic reflink enabling like this because it's just
a short term workaround to avoid waiting for the new feature to
stabilise. Our time is much better spent stabilising that feature to
reduce the amount of time it is considered EXPERIMENTAL.

> Option 3 would require adding a simple noreflink
> mount option to disable reflink related ops.

You can add it to your own kernels easily enough, but don't expect
us to carry one-off, special case mount options like this in the
upstream kernel.

> Option 4 requires changing mkfs.xfs before 4.9 release
> and possibly setting recompat feature reflink on first file
> reflink. There are several precedents to this sort of  "set
> on first use" feature in ext4, not sure if there are any in xfs.

There's a few in XFS, historically speaking (attribute fork layout,
v1->v2 inodes, etc). These days, however, we tend to avoid silent
dynamic feature bit addition because of the "upgrade kernel, random
feature bit gets added silently, upgrade causes other problems,
downgrade kernel, old kernel can't mount fs anymore" type of
problem it can cause the wider userbase.

FWIW, setting a feature bit on first reflink will require kernel
changes, and the soonest you'd get them into the kernel is 4.11 if
all the issues and problems could be sorted before then. So this
doesn't help you at all for the 4.9 kernel. It also requires that
the recountbt is being maintained for refcount=1 extents, otherwise
it introduces all the same problems as options 1-2. IMO, this is the
least appealing of all the options you presented.

> Another benefit from option #4 is that you may be able
> to declare rmapbt=1,reflinkbt=1 stable and/or default
> mkfs options prior to declaring reflink=1 stable.

Again, no. Once the kernel libxfs code is declared stable, we'll
merge that back into the next xfsprogs release which will also mark
that feature as stable. Madness lies in trying to support anything
else in the upstream code base.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
