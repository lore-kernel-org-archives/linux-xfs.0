Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfDXEzo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Apr 2019 00:55:44 -0400
Date: Wed, 24 Apr 2019 00:55:40 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <476344290.23160847.1556081740211.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190423220217.GA29573@dread.disaster.area>
References: <20190423080612.15361-1-pagupta@redhat.com> <20190423080612.15361-7-pagupta@redhat.com> <20190423220217.GA29573@dread.disaster.area>
Subject: Re: [PATCH v6 6/6] xfs: disable map_sync for async flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan j williams <dan.j.williams@intel.com>, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, darrick wong <darrick.wong@oracle.com>, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, cohuck@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, pbonzini@redhat.com, yuval shaia <yuval.shaia@oracle.com>, kilobyte@angband.pl


> 
> On Tue, Apr 23, 2019 at 01:36:12PM +0530, Pankaj Gupta wrote:
> > Dont support 'MAP_SYNC' with non-DAX files and DAX files
> > with asynchronous dax_device. Virtio pmem provides
> > asynchronous host page cache flush mechanism. We don't
> > support 'MAP_SYNC' with virtio pmem and xfs.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 1f2e2845eb76..0e59be018511 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1196,11 +1196,13 @@ xfs_file_mmap(
> >  	struct file	*filp,
> >  	struct vm_area_struct *vma)
> >  {
> > -	/*
> > -	 * We don't support synchronous mappings for non-DAX files. At least
> > -	 * until someone comes with a sensible use case.
> > +	struct dax_device *dax_dev = xfs_find_daxdev_for_inode
> > +						(file_inode(filp));
> > +
> > +	/* We don't support synchronous mappings for non-DAX files and
> > +	 * for DAX files if underneath dax_device is not synchronous.
> >  	 */
> 
> 	/*
> 	 * This is the correct multi-line comment format. Please
> 	 * update the patch to maintain the existing comment format.
> 	 */

Sure. Will correct this for both xfs & ext4.

Thanks,
Pankaj

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
