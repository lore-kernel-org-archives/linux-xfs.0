Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94A6C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 00:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjFFAzA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 20:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjFFAy7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 20:54:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644C3102
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 17:54:58 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso5024971a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 17:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686012898; x=1688604898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AAHz8i2KbPQ7iAo53D89fG/L+Cf6dlY2rs4oFtJsjaw=;
        b=fJCJ/SqQK2U9I15M8hfxFzOBYLL+CaLXJLgTvmzXX3+ji78P/FmtujNLkWC96RO+6p
         YDNE3P9nTz5cPYMTA0cESmWZ52QL6TtWeFMV0+FSdORExXi8g6GthjlgSiE34l4eRlVv
         U93Fp+/UVoJFLrXAXAfof5fR0molOOtGebIXgvg64iMAVSl83e85D/KyBD5wopa74Bdt
         QuuOFAOpwbuleichQVy/6+zMO1J8AZbLzG5CpNu/JPWcmuJ3LmiiEAyhjeGu3IfpN+04
         Vf7vHE6Jrm1R25sABvw9S6Ts5bNQqd/mHp+LF/h7qspQVJkrBf96WIZCFGWvjTZh2D7D
         dbfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686012898; x=1688604898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAHz8i2KbPQ7iAo53D89fG/L+Cf6dlY2rs4oFtJsjaw=;
        b=DE1KlUxxkEzrFnLQZwf5KgPVF0K5zj7J/cBrm755qzBd5+PtaOWY7K8SQJ+NU5iucU
         //1zZ4OeSRy70rs/d47rhPLs3FOhnq8rLopg4NvDjETPP/nCq8PZo7w5VX1l4QDlK6Qr
         Xh9SumQc6aKa6ZVPyOWkyd2b66qvKvvrUx0wVhAAA579dxjCs0G0IhM894BTLMjJKvKF
         mRBeLtLfANek6fRrbKmQkgaQLIjadA9EGEIbSN5LHiBo+ai6lsPU42KwnuS3/WBSu+Cs
         IHAXsxZ8FbUHJ1O65zD6o3l4Nsw8cXRwE6uW+95425diAjV5a4IzLi6BsiyVVMrnGKOF
         Giuw==
X-Gm-Message-State: AC+VfDx+A0mqqFo5Rzvkdrjt9x8ZFDIoSd3OP1mVCpwfEIMGKO0ugGxO
        hoO1AV180RfzKhZUNHexj1AGXA==
X-Google-Smtp-Source: ACHHUZ4YNT8KoM8UiAjw0baakq5eZoi/f5pwKLcgq9cru0Tqqc1WNLkcji1vIiE0xVWKUx0DLDn7YA==
X-Received: by 2002:a05:6a20:431a:b0:106:999f:64df with SMTP id h26-20020a056a20431a00b00106999f64dfmr763534pzk.58.1686012897840;
        Mon, 05 Jun 2023 17:54:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id f11-20020a63e30b000000b0053f2037d639sm6315107pgh.81.2023.06.05.17.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 17:54:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q6KyL-008IR4-1l;
        Tue, 06 Jun 2023 10:54:53 +1000
Date:   Tue, 6 Jun 2023 10:54:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: uuid ioctl - was: Re: [PATCH] overlayfs: Trigger file
 re-evaluation by IMA / EVM after writes
Message-ID: <ZH6D3RfGnoyGE35r@dread.disaster.area>
References: <20230520-angenehm-orangen-80fdce6f9012@brauner>
 <ZGqgDjJqFSlpIkz/@dread.disaster.area>
 <20230522-unsensibel-backblech-7be4e920ba87@brauner>
 <20230602012335.GB16848@frogsfrogsfrogs>
 <20230602042714.GE1128744@mit.edu>
 <ZHmNksPcA9tudSVQ@dread.disaster.area>
 <20230602-dividende-model-62b2bdc073cf@brauner>
 <ZH0XVWBqs9zJF69X@dread.disaster.area>
 <20230605-allgegenwart-bellt-e05884aab89a@brauner>
 <20230605143638.GA1151212@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605143638.GA1151212@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 10:36:38AM -0400, Theodore Ts'o wrote:
> On Mon, Jun 05, 2023 at 01:37:40PM +0200, Christian Brauner wrote:
> > Using a zero/special UUID would have made this usable for most
> > filesystems which allows userspace to more easily detect this. Using a
> > filesystem feature bit makes this a lot more fragmented between
> > filesystems.
> 
> Not all file systems have feature bits.  So I'd suggest that how this
> should be a file system specific implementation detail.  If with a
> newer kernel, a file systems sets the UUID to a random value if it is
> all zeros when it is mounted should be relatively simple.

Sure, but this is a *fs implementation detail*, not a user API
requirement.

If the filesysystem has feature bits, then it should use them, not
rely on zero UUID values because existing filesystems and/or images
could have zero values in them and the user may no want them to be
regenerated on mount.  That's a retrospective change of on-disk
format behaviour, and hence requires feature bits to manage....

> However, there are some questions this brings up.  What should the
> semantics be if a file system creates a file system-level snapshot ---
> should the UUID be refreshed?  What if it is a block-level file system
> snapshot using LVM --- should the UUID be refreshed in that case?

Engage your brain, Ted. Existing workflows with snapshots are
completely unchanged by this proposal. If you take a device level
snapshot and then want to mount it, you have to change the UUID
before it gets mounted..

Indeed, XFS will refuse to mount filesystems with duplicate UUIDs;
the admin has been forced to run xfs admin tools to regenerate the
UUID before mounting the snapshot image for the past 20+ years. Or
for pure read-only snapshots, they need to use "-o
ro,norecovery,nouuid" to allow a pure read-only mount with a
duplicate UUID. The "nouuid" mount otion has been around for almost
22 years:

commit 813e9410043e88b474b8b2b43c8d8e52ea90f155
Author: Steve Lord <lord@sgi.com>
Date:   Fri Jun 29 22:29:47 2001 +0000

    Add nouuid mount option

Either way, the admin has to manage UUIDs for device level
snapshots, and there is no change in that at all.

IOWs, there is no change to existing workflows because they already
require UUIDs to be directly manipulated by the user before or at
mount time for correct behaviour.

> As I've been trying to point out, exactly what the semantics of a file
> system level UUID has never been well defined, and it's not clear what
> various subsystems are trying to *do* with the UUID.  And given that
> what can happen with mount name spaces, bind mounts, etc., we should
> ask whether the assumptions they are making with respect to UUID is in
> fact something we should be encouraging.

We can't put that genie back in the bottle.

But it does raise a further interesting questions about sb->s_uuid:
is one uuid sufficient for a superblock? We have two specific use
cases here:

1. A uuid that uniquely identifies every filesystem (e.g. blkid,
   pnfs, /dev/disk/by-uuid/, etc)
2. A persistent, unchanging uuid that can be used to key persistent
   objects to the underlying filesystem (overlay, security xattrs,
   etc) regardless of snapshots, cloning, dedupe, etc.

We already have a solution to that problem in XFS, sbp->sb_uuid
is for case #1, sbp->sb_metauuid is for case #2 as every metadata
block in the filesystem is keyed with sbp->sb_metauuid. Both start out
the same at mkfs time, but if we then regenerate the filesystem
uuid, then only sbp->sb_uuid is changed. We do not rewrite metadata
with the new uuid, doing so would break snapshot/clone/dedupe in
shared filesystem images.

This is one of the things that the XFS online UUID change proposal
added - it allowed for userspace to query the sbp->sb_metauuid in
addition to the sbp->sb_uuid so that userspace init script
orchestration to make use of it for persistent userspace filesystem
objects rather than the sbp->s_uuid identifier....

> > But allowing to refuse being mounted on older kernels when the feature
> > bit is set and unknown can be quite useful. So this is also fine by me.
> 
> This pretty much guarantees people won't use the feature for a while.

Perfectly fine by me. Those that need it will backport/upgrade both
userspace and kernels immediately, and they reap the benefits
immediately. Everyone else gets it as distros roll out with the
functionality enabled and fully supported across the toolchain.

This is how all new feature additions work, so I'm not sure why you
think this is a reason not to use a feature bit...

> People complain when a file system cann't be mounted.  Using a feature
> bit is also very likely to mean that you won't be able to run an older
> fsck on that file system --- for what users would complain would be no
> good reason.  And arguably, they would be right to complain.

In general, yes, but this is *not a general case*.

If you have a golden image with the feature bit set, why would you
ever run a fsck that doesn't support the feature bit on it? You have
to have a tool chain that supports the feature bit to set it in the
first place.

And If the feature bit is set, then you must be running client kernels
that support it (and will clear it on first mount), so once the
client system is running, the feature bit will never be set and so
the toolchain in the client OS just doesn't matter at all.

There is literally no other use case for this feature, so arguing
about generalities that simply don't apply to the specific use case
really isn't that helpful.

As a result, I don't see that there are any concerns about using a
feature bit at all, yet I see substantial benefit from not
retropsectively redefining a special on-disk UUID value that
silently drives new kernel behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
