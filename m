Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43795 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751231AbdHXHQ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 03:16:28 -0400
Date: Thu, 24 Aug 2017 09:16:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/13] mm: Wire up MAP_SYNC
Message-ID: <20170824071624.GB20465@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-11-jack@suse.cz>
 <20170823184349.GA12660@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170823184349.GA12660@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Wed 23-08-17 11:43:49, Christoph Hellwig wrote:
> On Thu, Aug 17, 2017 at 06:08:12PM +0200, Jan Kara wrote:
> > Pretty crude for now...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/file.c                  | 2 ++
> >  include/linux/mm.h              | 1 +
> >  include/linux/mman.h            | 3 ++-
> >  include/uapi/asm-generic/mman.h | 1 +
> >  mm/mmap.c                       | 5 +++++
> >  5 files changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index f84bb29e941e..850037e140d7 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -340,6 +340,8 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
> >  		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
> >  	} else {
> >  		vma->vm_ops = &ext4_file_vm_ops;
> > +		if (vma->vm_flags & VM_SYNC)
> > +			return -EOPNOTSUPP;
> >  	}
> 
> So each mmap instance would need to reject the flag explicitly?
> 
> Or do I misunderstand this VM_SYNC flag?

Yes, if this should be cleaned up, then each mmap instance not supporting
it would need to reject it. However Dan has in his version of mmap()
syscall a mask of supported flags so when I switch to that, it would be
just opt-in. Or I could just reject VM_SYNC for any !IS_DAX inode so then
only ext2 & xfs would need to reject it... But the biggest problem with
this patch is that we need to settle on a safe way of adding new mmap flag.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
