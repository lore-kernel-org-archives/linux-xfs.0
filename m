Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751622AbdG1Ji1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jul 2017 05:38:27 -0400
Date: Fri, 28 Jul 2017 11:38:21 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170728093821.GB29433@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Lutomirski <luto@kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu 27-07-17 19:05:24, Andy Lutomirski wrote:
> On Thu, Jul 27, 2017 at 2:57 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Thu, Jul 27, 2017 at 10:09:07AM -0400, Jeff Moyer wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >>
> >> Hi, Jan,
> >>
> >> Thanks for looking into this!
> >>
> >> > There are couple of open questions with this implementation:
> >> >
> >> > 1) Is it worth the hassle?
> >> > 2) Is S_SYNC good flag to use or should we use a new inode flag?
> >> > 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
> >> >    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
> >> >    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
> >> >    things to make this cleaner.
> >>
> >> 4) How does an application discover that it is safe to flush from
> >>    userspace?
> >
> > I think that we would be best off with a new flag available via
> > lsattr(1)/chattr(1).  This would have the following advantages:
> >
> > 1) We could only set the flag if the inode supported DAX (either via the mount
> > option or via the individual DAX flag).  This would give NVML et al. one
> > central way to detect whether it was safe to flush from userspace because the
> > FS supported synchronous faults.
> >
> > 2) Defining a new flag prevents any confusion about whether the kernel version
> > you have supports sync faults.  Otherwise NVML would have to do something like
> > look at the trio of (kernel version, S_SYNC flag, mount/inode option for DAX)
> > which is complex and of course breaks for OS kernel versions.
> >
> > 3) Defining the flag in a generic way via lsattr/chattr opens the door for the
> > same API and flag to be used by other filesystems in the future.
> 
> I would advocate using a new fcntl() instead of lsattr for the
> following reason: ISTM the fact that it's an *inode* flag in this
> patchset is a bit of an implementation detail.  I can easily imagine a
> future implementation that makes it per-struct-file instead.  A
> fcntl() that asks "can I flush from userspace" would still work under
> than scenario.

Well, you are right I can make the implementation work with struct file
flag as well - let's call it O_DAXDSYNC. However there are filesystem
operations where you may need to answer question: Is there any fd with
O_DAXDSYNC open against this inode (for operations that change file offset
-> block mapping)? And in that case inode flag is straightforward while
file flag is a bit awkward (you need to implement counter of fd's with that
flag in the inode).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
