Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39694 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbeJLBg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 21:36:58 -0400
Received: by mail-ot1-f67.google.com with SMTP id l58so9840385otd.6
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 11:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net> <20181011103636.GC9467@quack2.suse.cz>
In-Reply-To: <20181011103636.GC9467@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Oct 2018 11:08:26 -0700
Message-ID: <CAPcyv4iAD_wkjY1way1rOxr4=gC_TGx71VquF13ooAuUPz9RJw@mail.gmail.com>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported devices
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, zwisler@kernel.org

On Thu, Oct 11, 2018 at 3:37 AM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 08-10-18 14:32:46, Eric Sandeen wrote:
> > In response to an earlier xfs patch to change how xfs reacts to
> > dax incompatibilities, Dave said:
> >
> > > I suspect we need to be more harsh are rejecting mounts with -o dax
> > > on devices DAX isn't supported on. This mount option is going into
> > > production systems - it's not just for "testing" as the comments all
> > > claim. i Things will break in production systems if DAX isn't
> > > enabled and they are expecting it to be enabled.
> >
> > and I tend to agree, so proposing this change to hard-fail a dax mount if
> > the device doesn't support it, instead of silently disabling the
> > functionality.  Proposing for ext2, ext4, and xfs to keep behavior in
> > sync.
>
> Let me include Dan and Ross into the discussion since they were the ones
> proposing the "silent fallback" behavior (ext4 actually did fail the mount
> instead not so long ago - see 24f3478d664b "ext4: auto disable dax instead
> of failing mount" from December). Guys, why did you choose the fallback
> path instead of a failure?

The different behavior between filesystems was confusing customers so
we had to align them, then the question was which default to pick.
Honestly, we came to the decision to bring ext4 in line with the xfs
behavior because we thought that would be easier than the alternative.
Dave and Christoph made repeated arguments that DAX is just a hidden
performance optimization that no application should rely on, so we
went the path of least resistance and changed the ext4 default.

I'm perfectly fine switching both to the "fail if not DAX device" behavior.
