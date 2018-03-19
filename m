Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969466AbeCSSTn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 14:19:43 -0400
Date: Mon, 19 Mar 2018 11:19:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
Message-ID: <20180319181930.GH1757@magnolia>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180319173345.GF1757@magnolia>
 <CAPcyv4hsLSR=eG8=yLtOhrOaUjqjV5S8pwwmP3oOLrknWQS6Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hsLSR=eG8=yLtOhrOaUjqjV5S8pwwmP3oOLrknWQS6Mg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Mar 19, 2018 at 10:57:55AM -0700, Dan Williams wrote:
> On Mon, Mar 19, 2018 at 10:33 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Thu, Mar 15, 2018 at 08:52:29AM -0700, Dan Williams wrote:
> >> In preparation for adding coordination between truncate operations and
> >> busy dax-pages, extend xfs_break_layouts() to assume it must be called
> >> with the mmap lock held. This locking scheme will be required for
> >> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
> >> pages mapped into the file's address space).
> >
> > If I'm reading this right, you've added a requirement (for xfs anyway)
> > that we have to have grabbed MMAPLOCK_EXCL before calling break_layout()
> > so that the layout breaking process will block until active dmas have
> > finished.
> >
> > In 4.16 we added xfs_iolock_two_inodes_and_break_layout (in
> > xfs_reflink.c) to break pnfs leases for files that are about to be
> > reflinked (since pnfs and reflink aren't compatible either).  I think
> > that function will have to be adapted to take the appropriate mmap locks
> > too -- definitely the exclusive mmap lock for the destination file
> > because we anticipate punching out blocks.  I'm not sure about the
> > source file; I think taking the shared mmap lock is fine for that?
> 
> I don't see anything to adapt with respect to mmap locks since reflink
> and dax are mutually exclusive. The new lock coordination and layout
> breaking in xfs_break_dax_layouts() only applies to dax vs truncate,
> so xfs_iolock_two_inodes_and_break_layout() looks ok to me as is.

I was aiming for DAX + reflink someday working together.  :)

As far as that goes, I think the only thing we really have to do is
figure out how to make iomap_begin do the cow operation before letting
userspace write to (or MAP_SYNC a writable region) pmem, right?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
