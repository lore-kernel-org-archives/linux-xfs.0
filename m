Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:36161 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdHLTTv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Aug 2017 15:19:51 -0400
Received: by mail-yw0-f171.google.com with SMTP id u207so37902023ywc.3
        for <linux-xfs@vger.kernel.org>; Sat, 12 Aug 2017 12:19:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170812073349.GA12679@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de> <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de> <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <20170812073349.GA12679@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 12 Aug 2017 12:19:50 -0700
Message-ID: <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux API <linux-api@vger.kernel.org>

On Sat, Aug 12, 2017 at 12:33 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Aug 11, 2017 at 03:26:05PM -0700, Dan Williams wrote:
>> Right, but they let userspace make inferences about the state of
>> metadata relative to I/O to a given storage address. In this regard
>> S_IOMAP_IMMUTABLE is no different than MAP_SYNC, but 'immutable' goes
>> a step further to let an application infer that the storage address is
>> stable. This enables applications that MAP_SYNC does not, see below.
>
> But the application must not know (and cannot know) the storage address,
> so it doesn't matter.
>
>> > What is the observable behavior of an extent map change?  How can you
>> > describe your immutable extent map behavior so that when I violate
>> > them by e.g. moving one extent to a different place on disk you can
>> > observe that in userspace?
>>
>> The violation is blocked, it's immutable. Using this feature means the
>> application is taking away some of the kernel's freedom. That is a
>> valid / safe tradeoff for the set of applications that would otherwise
>> resort to raw device access.
>
> What can the application do with it safely that it can't otherwise do?
> Short answer: nothing.

The application does not need to know the storage address, it needs to
know that the storage address to file offset is fixed. With this
information it can make assumptions about the permanence of results it
gets from the kernel.

For example get_user_pages() today makes no guarantees outside of
"page will not be freed", but with immutable files and dax you now
have a mechanism for userspace to coordinate direct access to storage
addresses. Those raw storage addresses need not be exposed to the
application, as you say it doesn't need to know that detail. MAP_SYNC
does not fully satisfy this case because it requires agents that can
generate MMU faults to coordinate with the filesystem.

>> >
>> > Please explain how this interface allows for any sort of safe userspac=
e
>> > DMA.
>>
>> So this is where I continue to see S_IOMAP_IMMUTABLE being able to
>> support applications that MAP_SYNC does not. Dave mentioned userspace
>> pNFS4 servers, but there's also Samba and other protocols that want to
>> negotiate a direct path to pmem outside the kernel.
>
> Userspace pNFS servers must use a userspace file system.  Everything
> else is just brainded stupid due to the amount of communication they
> need to do.  Also note that the only pNFS layouts that would even cause
> direct block access are pNFS block/scsi and for those the
> S_IOMAP_IMMUTABLE semantics are not very useful (background: I wrote
> the Linux implementation for those, and authored the scsi layout spec)
>

Understood.

All I know is that SMB Direct for persistent memory seems like a
potential consumer. I know they're not going to use a userspace
filesystem or put an SMB server in the kernel.

>
>> Applications that just want flush from userspace can use MAP_SYNC,
>> those that need to temporarily pin the block for RDMA can use the
>> in-kernel pNFS server, and those that need to coordinate both from
>> userspace can use S_IOMAP_IMMUTABLE. It's a continuum, not a
>> competition.
>
> Again - how does your application even know that I moved your block
> around with your S_IOMAP_IMMUTABLE?  We should never add interfaces
> that mandate implementations - we should based interfaces based on
> user observable behavior - and debug tools like fiemap don't count.

I'm still not grokking this "I moved your block" example. What agent
is moving blocks while the file is immutable?

> Before going any further please write a man page that describe=D1=95 your
> intended semantics in a way that an application programmer understands.

Sure, I'll try to write this up in terms of the use cases I know about
that can immediately consume it and switch away from device-dax.
