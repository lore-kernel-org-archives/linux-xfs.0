Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:20406 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751202AbdHMXqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Aug 2017 19:46:13 -0400
Date: Mon, 14 Aug 2017 09:46:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Message-ID: <20170813234608.GZ21024@dastard>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de>
 <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <20170812073349.GA12679@lst.de>
 <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
 <20170813092436.GB32112@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170813092436.GB32112@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux API <linux-api@vger.kernel.org>

On Sun, Aug 13, 2017 at 11:24:36AM +0200, Christoph Hellwig wrote:
> And maybe that's where we need to converge - 
> "sealing" the extent map makes sense as such a temporary measure
> that is not persisted on disk, which automatically gets released
> when the holding process exits, because we sort of already do this
> implicitly.

That seems reasonable to me. Personally I don't need persistent
state, and I'd only intended persistence to be so that we didn't get
arbitrary processes whacking holes in the file when the DAX app
wasn't running that would then cause for userspace data sync. Seeing
as the interface is morphing away from a "fill holes and persist"
interface to just a "seal the existing map" interface, it'll be up
to the app/library to prep check file layout for sanity every time
it is sealed.


> It might also make sense to have explicitl breakable
> seals similar to what I do for the pNFS blocks kernel server, as
> any userspace RDMA file server would also need those semantics.

How would that work? IIUC, we'd need userspace to take out a file
lease so that it gets notified when the seal is going to be broken
by the filesystem via the break_layouts() interface, and the break
then blocks until the app releases the lease? So the seal lifetime
is bounded by the lease?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
