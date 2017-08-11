Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38287 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751545AbdHKKob (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 06:44:31 -0400
Date: Fri, 11 Aug 2017 12:44:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
        dma-to-storage, and swap
Message-ID: <20170811104429.GA13736@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com> <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com> <20170805095013.GC14930@lst.de> <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux API <linux-api@vger.kernel.org>

On Sun, Aug 06, 2017 at 11:51:50AM -0700, Dan Williams wrote:
> Of course it's a useful API. An application already needs to worry
> about the block map, that's why we have fallocate, msync, fiemap
> and...

Fallocate and msync do not expose the block map in any way.  Proof:
they work just fine over say nfs.

fiemap does indeed expose the block map, which is the whole point.
But it's a debug tool that we don't event have a man page for.  And
it's not usable for anything else, if only for the fact that it doesn't
tell you what device your returned extents are relative to.

> > We've been through this a few times but let me repeat it:  The only
> > sensible API gurantee is one that is observable and usable.
> 
> I'm missing how block-map immutable files violate this observable and
> usable constraint?

What is the observable behavior of an extent map change?  How can you
describe your immutable extent map behavior so that when I violate
them by e.g. moving one extent to a different place on disk you can
observe that in userspace?

> This immutable approach should also go in, it solves the same problem
> without the the latency drawback,

How is your latency going to be any different from MAP_SYNC on
a fully allocated and pre-zeroed file?

> Beyond flush from userspace it also
> can be used to solve the swapfile problems you highlighted

Which swapfile problem?

> and it
> allows safe ongoing dma to a filesystem-dax mapping beyond what we can
> already do with direct-I/O.

Please explain how this interface allows for any sort of safe userspace
DMA.
