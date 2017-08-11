Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:35242 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753401AbdHKW0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 18:26:06 -0400
Received: by mail-yw0-f176.google.com with SMTP id l82so29947703ywc.2
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 15:26:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170811104429.GA13736@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de> <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 15:26:05 -0700
Message-ID: <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux API <linux-api@vger.kernel.org>

On Fri, Aug 11, 2017 at 3:44 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Sun, Aug 06, 2017 at 11:51:50AM -0700, Dan Williams wrote:
>> Of course it's a useful API. An application already needs to worry
>> about the block map, that's why we have fallocate, msync, fiemap
>> and...
>
> Fallocate and msync do not expose the block map in any way.  Proof:
> they work just fine over say nfs.

Right, but they let userspace make inferences about the state of
metadata relative to I/O to a given storage address. In this regard
S_IOMAP_IMMUTABLE is no different than MAP_SYNC, but 'immutable' goes
a step further to let an application infer that the storage address is
stable. This enables applications that MAP_SYNC does not, see below.

> fiemap does indeed expose the block map, which is the whole point.
> But it's a debug tool that we don't event have a man page for.  And
> it's not usable for anything else, if only for the fact that it doesn't
> tell you what device your returned extents are relative to.

True, one couldn't just use immutable + fiemap and expect to have the
right storage device.

>
>> > We've been through this a few times but let me repeat it:  The only
>> > sensible API gurantee is one that is observable and usable.
>>
>> I'm missing how block-map immutable files violate this observable and
>> usable constraint?
>
> What is the observable behavior of an extent map change?  How can you
> describe your immutable extent map behavior so that when I violate
> them by e.g. moving one extent to a different place on disk you can
> observe that in userspace?

The violation is blocked, it's immutable. Using this feature means the
application is taking away some of the kernel's freedom. That is a
valid / safe tradeoff for the set of applications that would otherwise
resort to raw device access.

>
>> This immutable approach should also go in, it solves the same problem
>> without the the latency drawback,
>
> How is your latency going to be any different from MAP_SYNC on
> a fully allocated and pre-zeroed file?

So, I went back and read Jan's patches, and in the pre-allocated case
I don't think we can get stuck behind a backlog of dirty metada
flushing since the implementation only seems to take the synchronous
fault path if the fault dirtied the block map.

>> Beyond flush from userspace it also
>> can be used to solve the swapfile problems you highlighted
>
> Which swapfile problem?

The TOCTOU problem of enabling swap vs reflink that you mentioned in
your criticism of the daxctl syscall, but now that I look your
comments were based on the *general* case use of bmap(), However, xfs
in particular as of commits:

   eb5e248d502b xfs: don't allow bmap on rt files
   db1327b16c2b xfs: report shared extent mappings to userspace correctly

...doesn't appear to have this problem. That said Dave's idea to use
immutable + unwritten extents for swap makes sense to me. That's a
feature, not a bug fix, but I went ahead and appended a
proof-of-concept implementation to the v3 posting.

>> and it
>> allows safe ongoing dma to a filesystem-dax mapping beyond what we can
>> already do with direct-I/O.
>
> Please explain how this interface allows for any sort of safe userspace
> DMA.

So this is where I continue to see S_IOMAP_IMMUTABLE being able to
support applications that MAP_SYNC does not. Dave mentioned userspace
pNFS4 servers, but there's also Samba and other protocols that want to
negotiate a direct path to pmem outside the kernel. Xen support has
thus far not been able to follow in the footsteps of KVM enabling due
to a dependence on static M2P tables that assume a static
guest-physical to host-physical relationship [1]. Immutable files
would allow Xen to follow the same "mmap a file" semantic as KVM.

Applications that just want flush from userspace can use MAP_SYNC,
those that need to temporarily pin the block for RDMA can use the
in-kernel pNFS server, and those that need to coordinate both from
userspace can use S_IOMAP_IMMUTABLE. It's a continuum, not a
competition.

[1]: https://lists.xen.org/archives/html/xen-devel/2017-04/msg00427.html
