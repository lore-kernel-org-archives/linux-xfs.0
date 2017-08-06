Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:32869 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdHFSvw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Aug 2017 14:51:52 -0400
Received: by mail-ua0-f181.google.com with SMTP id 80so23407284uas.0
        for <linux-xfs@vger.kernel.org>; Sun, 06 Aug 2017 11:51:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170805095013.GC14930@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com> <20170805095013.GC14930@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 6 Aug 2017 11:51:50 -0700
Message-ID: <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux API <linux-api@vger.kernel.org>

On Sat, Aug 5, 2017 at 2:50 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Aug 03, 2017 at 07:38:11PM -0700, Dan Williams wrote:
>> [ adding linux-api to the cover letter for notification, will send the
>> full set to linux-api for v3 ]
>
> Just don't send this crap ever again.  All the so called use cases in the
> earlier thread were incorrect and highly dangerous.

I usually end up coming around to your position on these types of
debates because you almost always put forward unassailable technical
arguments. So far, you have not in this case.

> Promising that the block map is stable is not a useful userspace API,
> as it the block map is a complete internal implementation detail.

Of course it's a useful API. An application already needs to worry
about the block map, that's why we have fallocate, msync, fiemap
and...

> We've been through this a few times but let me repeat it:  The only
> sensible API gurantee is one that is observable and usable.

I'm missing how block-map immutable files violate this observable and
usable constraint?

> so Jan's synchronous page fault flag in one form or another makes
> perfect sense as it is a clear receipe for the user:  you don't
> have to call msync to persist your mmap writes.  This API is not,
> it guarantees that the block map does not change, but the application
> has absolutely no point of even knowing about the block map.

Jan's approach is great, it should go in, it solves a long standing
problem with dax with the only drawback being potentially
unpredictable latency spikes.

This immutable approach should also go in, it solves the same problem
without the the latency drawback, but yes, with the administrative
overhead of CAP_LINUX_IMMUTABLE. Beyond flush from userspace it also
can be used to solve the swapfile problems you highlighted and it
allows safe ongoing dma to a filesystem-dax mapping beyond what we can
already do with direct-I/O. There is demand for these capabilities
that cannot be satisfied by just hand waving them away as invalid.

The magnitude of opposition to this approach is out of step with the
actual risk.
