Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39409 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbeJRF2q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Oct 2018 01:28:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported devices
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
        <20181011103636.GC9467@quack2.suse.cz>
        <CAPcyv4iAD_wkjY1way1rOxr4=gC_TGx71VquF13ooAuUPz9RJw@mail.gmail.com>
        <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net>
        <20181012082154.GB30154@lst.de>
        <CAOxpaSWf=6RBTa3WM=Hnbr7MwpQ5mMSMAZ+B5FfZo3zKv4Nu7w@mail.gmail.com>
        <116ef687-f23d-b45c-1b48-fd444b346719@sandeen.net>
Date: Wed, 17 Oct 2018 17:31:09 -0400
In-Reply-To: <116ef687-f23d-b45c-1b48-fd444b346719@sandeen.net> (Eric
        Sandeen's message of "Wed, 17 Oct 2018 14:42:36 -0500")
Message-ID: <x491s8ofeg2.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ross Zwisler <zwisler@kernel.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> writes:

> I've been thinking about the per-inode stuff a bit, and while I don't know
> how to resolve some of the trickier issues, at least the expected behavior
> seems like something we can narrow down and specify.
>
> Because it's an on-disk flag (in xfs today, in any case) it seems that
> the only sane behavior to expect is either/or, i.e.:
>
> Mount option: All files always dax, per-inode flags ignored (or rejected)
> Per-inode: Mount option cannot be specified; only inodes explicitly flagged are dax
>
> Think about it; what would mount-option-plus-per-inode mean?  We have
> no "negative" dax flag, so while mount-option-with-flag surely means
> "dax", what the heck does mount-option-without-flag mean, and how is it
> distinguishable from mount option only?
>
> I submit that flags can only have meaning w/o the fs-wide mount option
> enabled, so the question of "should we hard fail mount -o dax for devices
> that cannot support it" seems to be orthogonal to the per-inode question.
>
> i.e. mount -o dax really can only mean "I want dax on everything" and so
> again, I think we probably need to fail the mount if that can't be honored.

I hate to even open up this can of worms, but what about killing the dax
mount option?

To quote Christoph:
  How does an application "make use of DAX"?  What actual user visible
  semantics are associated with a file that has this flag set?

We're already talking about making caching decisions automatically, so
does DAX even mean anything at that point?  If the storage and the file
system support it, enable it.

>From what we've seen so far, aplications want:
1) to be able to make data persistent from userspace
   For this, we have MAP_SYNC.
2) to determine whether or not page cache will be used
   For this, we have O_DIRECT for read/write access, and MAP_SYNC for
   mmap access (and maybe a third option coming, we'll see).

The only thing users gain from a mount option is the ability to turn OFF
dax.  I suppose there might be a use case that wants this, but I'm not
aware of it.

Cheers,
Jeff
