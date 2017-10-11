Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:47576 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752485AbdJKVSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 17:18:07 -0400
Received: by mail-oi0-f48.google.com with SMTP id h200so5316973oib.4
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 14:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011200603.27442-1-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 14:18:06 -0700
Message-ID: <CAPcyv4g6tjyUy_zxVVze+C+xZiT89qa1GiSoVjhH3G-6r3eXDA@mail.gmail.com>
Subject: Re: [PATCH 0/19 v3] dax, ext4, xfs: Synchronous page faults
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 1:05 PM, Jan Kara <jack@suse.cz> wrote:
> Hello,
>
> here is the third version of my patches to implement synchronous page faults
> for DAX mappings to make flushing of DAX mappings possible from userspace so
> that they can be flushed on finer than page granularity and also avoid the
> overhead of a syscall.
>
> We use a new mmap flag MAP_SYNC to indicate that page faults for the mapping
> should be synchronous.  The guarantee provided by this flag is: While a block
> is writeably mapped into page tables of this mapping, it is guaranteed to be
> visible in the file at that offset also after a crash.
>
> How I implement this is that ->iomap_begin() indicates by a flag that inode
> block mapping metadata is unstable and may need flushing (use the same test as
> whether fdatasync() has metadata to write). If yes, DAX fault handler refrains
> from inserting / write-enabling the page table entry and returns special flag
> VM_FAULT_NEEDDSYNC together with a PFN to map to the filesystem fault handler.
> The handler then calls fdatasync() (vfs_fsync_range()) for the affected range
> and after that calls DAX code to update the page table entry appropriately.
>
> The first patch in this series is taken from Dan Williams' series for
> MAP_DIRECT so that we get a reliable way of detecting whether MAP_SYNC is
> supported or not.
>
> I did some basic performance testing on the patches over ramdisk - timed
> latency of page faults when faulting 512 pages. I did several tests: with file
> preallocated / with file empty, with background file copying going on / without
> it, with / without MAP_SYNC (so that we get comparison).  The results are
> (numbers are in microseconds):
>
> File preallocated, no background load no MAP_SYNC:
> min=9 avg=10 max=46
> 8 - 15 us: 508
> 16 - 31 us: 3
> 32 - 63 us: 1
>
> File preallocated, no background load, MAP_SYNC:
> min=9 avg=10 max=47
> 8 - 15 us: 508
> 16 - 31 us: 2
> 32 - 63 us: 2
>
> File empty, no background load, no MAP_SYNC:
> min=21 avg=22 max=70
> 16 - 31 us: 506
> 32 - 63 us: 5
> 64 - 127 us: 1
>
> File empty, no background load, MAP_SYNC:
> min=40 avg=124 max=242
> 32 - 63 us: 1
> 64 - 127 us: 333
> 128 - 255 us: 178
>
> File empty, background load, no MAP_SYNC:
> min=21 avg=23 max=67
> 16 - 31 us: 507
> 32 - 63 us: 4
> 64 - 127 us: 1
>
> File empty, background load, MAP_SYNC:
> min=94 avg=112 max=181
> 64 - 127 us: 489
> 128 - 255 us: 23
>
> So here we can see the difference between MAP_SYNC vs non MAP_SYNC is about
> 100-200 us when we need to wait for transaction commit in this setup.
>
> Anyway, here are the patches and AFAICT the series is pretty much complete
> so we can start thinking how to merge this. Changes to ext4 / XFS are pretty
> minimal so either tree is fine I guess. Comments are welcome.

I'd like to propose taking this through the nvdimm tree. Some of these
changes make the MAP_DIRECT support for ext4 easier, so I'd like to
rebase that support on top and carry both.
