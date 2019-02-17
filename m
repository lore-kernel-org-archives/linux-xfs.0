Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfBQUkY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 Feb 2019 15:40:24 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 280E2218D3
        for <linux-xfs@vger.kernel.org>; Sun, 17 Feb 2019 20:40:23 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id w2so1469935wrt.11
        for <linux-xfs@vger.kernel.org>; Sun, 17 Feb 2019 12:40:23 -0800 (PST)
MIME-Version: 1.0
References: <cover.1550136164.git.osandov@fb.com> <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com> <20190217175450.psaesabv3vlzvjv4@angband.pl>
In-Reply-To: <20190217175450.psaesabv3vlzvjv4@angband.pl>
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 17 Feb 2019 12:40:09 -0800
Message-ID: <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Boaz Harrosh <openosd@gmail.com>, Dave Chinner <david@fromorbit.com>, Omar Sandoval <osandov@osandov.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Sun, Feb 17, 2019 at 9:55 AM Adam Borowski <kilobyte@angband.pl> wrote:
>
> On Sun, Feb 17, 2019 at 06:35:25PM +0200, Boaz Harrosh wrote:
> > On 15/02/19 00:06, Dave Chinner wrote:
> > > So you're adding an interface that allows users to change the create
> > > time of files without needing any privileges?
>
> > > Inode create time is forensic metadata in XFS  - information we use
> > > for sequence of event and inode lifetime analysis during examination
> > > of broken filesystem images and systems that have been broken into.
>
> > I think the difference in opinion here is that there are two totally
> > different BTIme out in the world. For two somewhat opposite motivations
> > and it seems they both try to be crammed into the same on disk space.
> >
> > One - Author creation time
> > Two - Local creation time
>
> > So it looks like both sides are correct trying to preserve their own guy?
>
> I'd say that [2] is too easily gameable to be worth the effort.  You can
> just change it on the disk.  That right now it'd take some skill to find the
> right place to edit doesn't matter -- a tool to update the btime against
> your wishes would need to be written just once.  Unlike btrfs, XFS doesn't
> even have a chain of checksums all the way to the root.
>
> On the other hand, [1] has a lot of uses.  It can also be preserved in
> backups and version control (svnt and git-restore-mtime could be easily
> extended).
>
> I'd thus go with [2] -- any uses for [1] are better delegated to filesystem
> specific tools.
>

I started out in the Windows world, and I found it quite handy to
right-click a file and see when it was created.  When I started using
Linux, I saw things like this:

Access: 2019-02-16 22:19:32.024284060 -0800
Modify: 2016-02-02 19:26:47.901766778 -0800
Change: 2016-02-02 19:26:47.907766649 -0800

and my mind boggled a bit.  Modify makes sense.  Change?  What's that?
 Why do I care?

Adding "birth" makes sense, and I think that filesystem-agnostic
backup tools *should* be able to write it.

So I'm highly in favor of this patch.  If XFS wants to disallow
writing the birth time, fine, but I think that behavior should be
overridable.
