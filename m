Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGQTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:19:49 -0400
Date: Tue, 7 May 2019 09:17:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7 6/6] xfs: disable map_sync for async flush
Message-ID: <20190507161736.GV5207@magnolia>
References: <20190426050039.17460-1-pagupta@redhat.com>
 <20190426050039.17460-7-pagupta@redhat.com>
 <CAPcyv4hCP4E4xPkQx25tqhznon6ADwrYJB1yujkrO-A7LUnsmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hCP4E4xPkQx25tqhznon6ADwrYJB1yujkrO-A7LUnsmg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pagupta@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, KVM list <kvm@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Matthew Wilcox <willy@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Christoph Hellwig <hch@infradead.org>, Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Igor Mammedov <imammedo@redhat.com>, jmoyer <jmoyer@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Rik van Riel <riel@surriel.com>, Stefan Hajnoczi <stefanha@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Hildenbrand <david@redhat.com>, david <david@fromorbit.com>, cohuck@redhat.com, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl, yuval shaia <yuval.shaia@oracle.com>

On Tue, May 07, 2019 at 08:37:01AM -0700, Dan Williams wrote:
> On Thu, Apr 25, 2019 at 10:03 PM Pankaj Gupta <pagupta@redhat.com> wrote:
> >
> > Dont support 'MAP_SYNC' with non-DAX files and DAX files
> > with asynchronous dax_device. Virtio pmem provides
> > asynchronous host page cache flush mechanism. We don't
> > support 'MAP_SYNC' with virtio pmem and xfs.
> >
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Darrick, does this look ok to take through the nvdimm tree?

<urk> forgot about this, sorry. :/

> >
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index a7ceae90110e..f17652cca5ff 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1203,11 +1203,14 @@ xfs_file_mmap(
> >         struct file     *filp,
> >         struct vm_area_struct *vma)
> >  {
> > +       struct dax_device       *dax_dev;
> > +
> > +       dax_dev = xfs_find_daxdev_for_inode(file_inode(filp));
> >         /*
> > -        * We don't support synchronous mappings for non-DAX files. At least
> > -        * until someone comes with a sensible use case.
> > +        * We don't support synchronous mappings for non-DAX files and
> > +        * for DAX files if underneath dax_device is not synchronous.
> >          */
> > -       if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> > +       if (!daxdev_mapping_supported(vma, dax_dev))
> >                 return -EOPNOTSUPP;

LGTM, and I'm fine with it going through nvdimm.  Nothing in
xfs-5.2-merge touches that function so it should be clean.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> >
> >         file_accessed(filp);
> > --
> > 2.20.1
> >
