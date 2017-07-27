Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:57829 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751465AbdG0V5P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 17:57:15 -0400
Date: Thu, 27 Jul 2017 15:57:13 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170727215713.GA22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jul 27, 2017 at 10:09:07AM -0400, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> Hi, Jan,
> 
> Thanks for looking into this!
> 
> > There are couple of open questions with this implementation:
> >
> > 1) Is it worth the hassle?
> > 2) Is S_SYNC good flag to use or should we use a new inode flag?
> > 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
> >    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
> >    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
> >    things to make this cleaner.
> 
> 4) How does an application discover that it is safe to flush from
>    userspace?

I think that we would be best off with a new flag available via
lsattr(1)/chattr(1).  This would have the following advantages:

1) We could only set the flag if the inode supported DAX (either via the mount
option or via the individual DAX flag).  This would give NVML et al. one
central way to detect whether it was safe to flush from userspace because the
FS supported synchronous faults.

2) Defining a new flag prevents any confusion about whether the kernel version
you have supports sync faults.  Otherwise NVML would have to do something like
look at the trio of (kernel version, S_SYNC flag, mount/inode option for DAX)
which is complex and of course breaks for OS kernel versions.

3) Defining the flag in a generic way via lsattr/chattr opens the door for the
same API and flag to be used by other filesystems in the future.
