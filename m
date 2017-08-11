Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:35391 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbdHKXmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 19:42:20 -0400
Received: by mail-yw0-f179.google.com with SMTP id l82so30549126ywc.2
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 16:42:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170811232708.GT21024@dastard>
References: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150243356799.8777.11625037981403766282.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170811232708.GT21024@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 16:42:18 -0700
Message-ID: <CAPcyv4gwgYfLviDJ5wJ5ZRKbX+fDkw_i7A+OwQyMM+MKXe8e=w@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Fri, Aug 11, 2017 at 4:27 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Aug 10, 2017 at 11:39:28PM -0700, Dan Williams wrote:
>> >From falloc.h:
>>
>>     FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
>>     file logical-to-physical extent offset mappings in the file. The
>>     purpose is to allow an application to assume that there are no holes
>>     or shared extents in the file and that the metadata needed to find
>>     all the physical extents of the file is stable and can never be
>>     dirtied.
>>
>> For now this patch only permits setting the in-memory state of
>> S_IOMAP_IMMMUTABLE. Support for clearing and persisting the state is
>> saved for later patches.
>>
>> The implementation is careful to not allow the immutable state to change
>> while any process might have any established mappings. It reuses the
>> existing xfs_reflink_unshare() and xfs_alloc_file_space() to unshare
>> extents and fill all holes in the file. It then holds XFS_ILOCK_EXCL
>> while it validates the file is in the proper state and sets
>> S_IOMAP_IMMUTABLE.
>
> SO I've been thinking about this - I'm thinking that we need to
> separate the changes to the extent map from the action of sealing
> the extent map.
>
> That is, I have a need to freeze an extent map without any
> modification to it at all and breaking all the sharing and filling
> all the holes completely screws up the file layout I need to
> preserve. i.e. I want to be able to freeze the maps of a pair of
> reflinked files so I can use FIEMAP to query only the changed blocks
> and then read out the data in the private/changed blocks in the
> reflinked file. I only need a temporary seal (if we crash it goes
> away), so maybe there's another command modifier flag needed here,
> too.
>
> The DAX allocation requirements can be handled by a preallocation
> call to filll holes with zeros, followed by an unshare call to break
> all the COW mappings, and then the extent map can be sealed. If you
> need to check for holes after sealing, SEEK_HOLE will tell you what
> you need to know...
>
> My preference really is for each fallocate command to do just one
> thing - having the seal operation also modify the extent map
> means it's not useful for the use cases where we need the extent map
> to remain unmodified....
>
> Thoughts?

That does seem to better follow the principle of least surprise and
make the interface more composable. However, for the DAX case do we
now end up needing a SEEK_SHARED, or something similar to check that
we sealed the file without shared extents?
