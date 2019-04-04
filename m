Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfDDPuF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 11:50:05 -0400
Date: Thu, 4 Apr 2019 11:50:02 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <846216210.17971239.1554393002566.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190404150025.GN5147@magnolia>
References: <20190403104018.23947-1-pagupta@redhat.com> <20190403220912.GB26298@dastard> <20190403223921.GM5147@magnolia> <1508883801.17367965.1554358418550.JavaMail.zimbra@redhat.com> <651986267.17402634.1554368950178.JavaMail.zimbra@redhat.com> <20190404094029.GD16131@quack2.suse.cz> <527416483.17415178.1554372524196.JavaMail.zimbra@redhat.com> <20190404150025.GN5147@magnolia>
Subject: Re: [Qemu-devel] [PATCH v4 5/5] xfs: disable map_sync for async
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, Dave Chinner <david@fromorbit.com>, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, dave jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, vishal l verma <vishal.l.verma@intel.com>, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-ext4@vger.kernel.org, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, dan j williams <dan.j.williams@intel.com>, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com


> > > 
> > > So I would put the helper in include/linux/dax.h and have it like:
> > > 
> > > bool daxdev_mapping_supported(struct vm_area_struct *vma,
> 
> Should this be static inline if you're putting it in the header file?

yes. Thanks.

> 
> A comment ought to be added to describe what this predicate function
> does.

Sure, will add a comment describing the function.

> 
> > > 			      struct dax_device *dax_dev)
> > > {
> > > 	if (!(vma->vm_flags & VM_SYNC))
> > > 		return true;
> > > 	if (!IS_DAX(file_inode(vma->vm_file)))
> > > 		return false;
> > > 	return dax_synchronous(dax_dev);
> > > }
> > 
> > Sure. This is much better. I was also not sure what to name the helper
> > function.
> > I will go ahead with this unless 'Dave' & 'Darrick' have anything to add.
> 
> Jan's approach (modulo that one comment) looks good to me.

Sure. Thank you.

Best regards,
Pankaj

> 
> --D
> 
