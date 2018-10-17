Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbeJREVO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Oct 2018 00:21:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
References: <20181002100531.GC4135@quack2.suse.cz>
        <20181002121039.GA3274@linux-x5ow.site>
        <20181002142959.GD9127@quack2.suse.cz>
Date: Wed, 17 Oct 2018 16:23:50 -0400
In-Reply-To: <20181002142959.GD9127@quack2.suse.cz> (Jan Kara's message of
        "Tue, 2 Oct 2018 16:29:59 +0200")
Message-ID: <x49h8hkfhk9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> [Added ext4, xfs, and linux-api folks to CC for the interface discussion]
>
> On Tue 02-10-18 14:10:39, Johannes Thumshirn wrote:
>> On Tue, Oct 02, 2018 at 12:05:31PM +0200, Jan Kara wrote:
>> > Hello,
>> > 
>> > commit e1fb4a086495 "dax: remove VM_MIXEDMAP for fsdax and device dax" has
>> > removed VM_MIXEDMAP flag from DAX VMAs. Now our testing shows that in the
>> > mean time certain customer of ours started poking into /proc/<pid>/smaps
>> > and looks at VMA flags there and if VM_MIXEDMAP is missing among the VMA
>> > flags, the application just fails to start complaining that DAX support is
>> > missing in the kernel. The question now is how do we go about this?
>> 
>> OK naive question from me, how do we want an application to be able to
>> check if it is running on a DAX mapping?
>
> The question from me is: Should application really care? After all DAX is
> just a caching decision. Sure it affects performance characteristics and
> memory usage of the kernel but it is not a correctness issue (in particular
> we took care for MAP_SYNC to return EOPNOTSUPP if the feature cannot be
> supported for current mapping). And in the future the details of what we do
> with DAX mapping can change - e.g. I could imagine we might decide to cache
> writes in DRAM but do direct PMEM access on reads. And all this could be
> auto-tuned based on media properties. And we don't want to tie our hands by
> specifying too narrowly how the kernel is going to behave.

For read and write, I would expect the O_DIRECT open flag to still work,
even for dax-capable persistent memory.  Is that a contentious opinion?

So, what we're really discussing is the behavior for mmap.  MAP_SYNC
will certainly ensure that the page cache is not used for writes.  It
would also be odd for us to decide to cache reads.  The only issue I can
see is that perhaps the application doesn't want to take a performance
hit on write faults.  I haven't heard that concern expressed in this
thread, though.

Just to be clear, this is my understanding of the world:

MAP_SYNC
- file system guarantees that metadata required to reach faulted-in file
  data is consistent on media before a write fault is completed.  A
  side-effect is that the page cache will not be used for
  writably-mapped pages.

and what I think Dan had proposed:

mmap flag, MAP_DIRECT
- file system guarantees that page cache will not be used to front storage.
  storage MUST be directly addressable.  This *almost* implies MAP_SYNC.
  The subtle difference is that a write fault /may/ not result in metadata
  being written back to media.

and this is what I think you were proposing, Jan:

madvise flag, MADV_DIRECT_ACCESS
- same semantics as MAP_DIRECT, but specified via the madvise system call

Cheers,
Jeff
