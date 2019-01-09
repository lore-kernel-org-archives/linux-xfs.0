Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfAISI0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jan 2019 13:08:26 -0500
Date: Wed, 9 Jan 2019 13:08:24 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <739751810.61274195.1547057304156.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190109162654.GW12689@magnolia>
References: <20190109144736.17452-1-pagupta@redhat.com> <20190109144736.17452-6-pagupta@redhat.com> <20190109162654.GW12689@magnolia>
Subject: Re: [PATCH v3 5/5] xfs: disable map_sync for virtio pmem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com, dan j williams <dan.j.williams@intel.com>, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, david@redhat.com, jmoyer@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, rjw@rjwysocki.net


> > Virtio pmem provides asynchronous host page cache flush
> > mechanism. we don't support 'MAP_SYNC' with virtio pmem
> > and xfs.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index e474250..eae4aa4 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1190,6 +1190,14 @@ xfs_file_mmap(
> >  	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> >  		return -EOPNOTSUPP;
> >  
> > +	/* We don't support synchronous mappings with guest direct access
> > +	 * and virtio based host page cache mechanism.
> > +	 */
> > +	if (IS_DAX(file_inode(filp)) && virtio_pmem_host_cache_enabled(
> 
> Echoing what Jan said, this ought to be some sort of generic function
> that tells us whether or not memory mapped from the dax device will
> always still be accessible even after a crash (i.e. supports MAP_SYNC).

o.k
> 
> What if the underlying file on the host is itself on pmem and can be
> MAP_SYNC'd?  Shouldn't the guest be able to use MAP_SYNC as well?

Guest MAP_SYNC on actual host pmem will sync guest metadata, as guest 
writes are persistent on actual pmem. Host side Qemu MAP_SYNC enabling
work for pmem is in progress. It will make sure metadata at host side
is in consistent state after a crash or any other metadata corruption 
operation.

For virtio-pmem, we are emulating pmem device over regular storage on
host side. Guest need to call fsync followed by write to make sure
guest metadata is in consistent state(or journalled). Host backing file
data & metadata will also be persistent after guest to host fsync.

Thanks,
Pankaj
