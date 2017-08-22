Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46405 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932205AbdHVJg1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 05:36:27 -0400
Date: Tue, 22 Aug 2017 11:36:25 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170822093625.GD4909@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170821213704.GG26220@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170821213704.GG26220@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Mon 21-08-17 15:37:04, Ross Zwisler wrote:
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index f19efcf75418..18453c04b09f 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1423,12 +1423,17 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
> >  				return -ENODEV;
> >  			if (vm_flags & (VM_GROWSDOWN|VM_GROWSUP))
> >  				return -EINVAL;
> > +			if (!(vm_flags & VM_SHARED) && (vm_flags & VM_SYNC))
> > +				return -EINVAL;
> 
> I know this will be reworked with Dan's new mmap() interface, but I was
> curious what the !(vm_flags & VM_SHARED) check here was for.  We're in a
> MAP_PRIVATE case, so is it ever possible for VM_SHARED to be set in vm_flags?
> I tried to make this happen with some various test scenarios, but wasn't able.

I was also caught by this :). Check how MAP_SHARED case above falls through
to the MAP_PRIVATE case...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
