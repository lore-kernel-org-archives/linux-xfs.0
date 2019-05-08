Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfEHFtG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 May 2019 01:49:06 -0400
Date: Wed, 8 May 2019 01:49:04 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <7976014.27184867.1557294544901.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190507161736.GV5207@magnolia>
References: <20190426050039.17460-1-pagupta@redhat.com> <20190426050039.17460-7-pagupta@redhat.com> <CAPcyv4hCP4E4xPkQx25tqhznon6ADwrYJB1yujkrO-A7LUnsmg@mail.gmail.com> <20190507161736.GV5207@magnolia>
Subject: Re: [Qemu-devel] [PATCH v7 6/6] xfs: disable map_sync for async
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vishal L Verma <vishal.l.verma@intel.com>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, kilobyte@angband.pl, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>


> 
> On Tue, May 07, 2019 at 08:37:01AM -0700, Dan Williams wrote:
> > On Thu, Apr 25, 2019 at 10:03 PM Pankaj Gupta <pagupta@redhat.com> wrote:
> > >
> > > Dont support 'MAP_SYNC' with non-DAX files and DAX files
> > > with asynchronous dax_device. Virtio pmem provides
> > > asynchronous host page cache flush mechanism. We don't
> > > support 'MAP_SYNC' with virtio pmem and xfs.
> > >
> > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > ---
> > >  fs/xfs/xfs_file.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > Darrick, does this look ok to take through the nvdimm tree?
> 
> <urk> forgot about this, sorry. :/
> 
> > >
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index a7ceae90110e..f17652cca5ff 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -1203,11 +1203,14 @@ xfs_file_mmap(
> > >         struct file     *filp,
> > >         struct vm_area_struct *vma)
> > >  {
> > > +       struct dax_device       *dax_dev;
> > > +
> > > +       dax_dev = xfs_find_daxdev_for_inode(file_inode(filp));
> > >         /*
> > > -        * We don't support synchronous mappings for non-DAX files. At
> > > least
> > > -        * until someone comes with a sensible use case.
> > > +        * We don't support synchronous mappings for non-DAX files and
> > > +        * for DAX files if underneath dax_device is not synchronous.
> > >          */
> > > -       if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> > > +       if (!daxdev_mapping_supported(vma, dax_dev))
> > >                 return -EOPNOTSUPP;
> 
> LGTM, and I'm fine with it going through nvdimm.  Nothing in
> xfs-5.2-merge touches that function so it should be clean.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thank you for the review.

Pankaj

> 
> --D
> 
> > >
> > >         file_accessed(filp);
> > > --
> > > 2.20.1
> > >
> 
> 
