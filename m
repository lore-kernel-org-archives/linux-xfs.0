Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbfDDKwS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 06:52:18 -0400
Date: Thu, 4 Apr 2019 06:52:16 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <511760533.17430856.1554375136102.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190404095649.GB8738@angband.pl>
References: <20190403104018.23947-1-pagupta@redhat.com> <20190403104018.23947-6-pagupta@redhat.com> <20190403220912.GB26298@dastard> <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com> <20190404095649.GB8738@angband.pl>
Subject: Re: [PATCH v4 5/5] xfs: disable map_sync for async flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Dave Chinner <david@fromorbit.com>, darrick wong <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan j williams <dan.j.williams@intel.com>, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, cohuck@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>


> 
> On Thu, Apr 04, 2019 at 02:12:30AM -0400, Pankaj Gupta wrote:
> > > All this ad hoc IS_DAX conditional logic is getting pretty nasty.
> > > 
> > > xfs_file_mmap(
> > > ....
> > > {
> > > 	struct inode	*inode = file_inode(filp);
> > > 
> > > 	if (vma->vm_flags & VM_SYNC) {
> > > 		if (!IS_DAX(inode))
> > > 			return -EOPNOTSUPP;
> > > 		if (!dax_synchronous(xfs_find_daxdev_for_inode(inode))
> > > 			return -EOPNOTSUPP;
> > > 	}
> > > 
> > > 	file_accessed(filp);
> > > 	vma->vm_ops = &xfs_file_vm_ops;
> > > 	if (IS_DAX(inode))
> > > 		vma->vm_flags |= VM_HUGEPAGE;
> > > 	return 0;
> > > }
> > 
> > Sure, this is better.
> 
> > > Even better, factor out all the "MAP_SYNC supported" checks into a
> > > helper so that the filesystem code just doesn't have to care about
> > > the details of checking for DAX+MAP_SYNC support....
> > 
> > o.k. Will add one common helper function for both ext4 & xfs filesystems.
> 
> Note this pending patch for Goldwyn Rodrigues' patchset for btrfs:
> 
> https://lore.kernel.org/linux-btrfs/20190328102418.5466-1-kilobyte@angband.pl/
> 
> We might want to coordinate.

Sure. Good to know.

Thanks for the pointer. Will have a look.

Best regards,
Pankaj 

> 
> 
> Meow!
> --
> ⢀⣴⠾⠻⢶⣦⠀
> ⣾⠁⢠⠒⠀⣿⡁ Did ya know that typing "test -j8" instead of "ctest -j8"
> ⢿⡄⠘⠷⠚⠋⠀ will make your testsuite pass much faster, and fix bugs?
> ⠈⠳⣄⠀⠀⠀⠀
> 
