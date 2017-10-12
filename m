Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38147 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbdJLNmM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 09:42:12 -0400
Date: Thu, 12 Oct 2017 15:42:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Message-ID: <20171012134209.GE29293@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-18-jack@suse.cz>
 <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed 11-10-17 15:11:21, Dan Williams wrote:
> On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
> > Now when everything is prepared, add support in ext4 to accept MAP_SYNC
> > as an mmap(2) flag.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/file.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 61a8788168f3..f013cda84b3d 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -364,6 +364,25 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
> >         return 0;
> >  }
> >
> > +#define EXT4_SUPPORTED_MAP_FLAGS (LEGACY_MAP_MASK | MAP_SYNC)
> > +
> > +static int ext4_file_mmap_validate(struct file *file,
> > +                                  struct vm_area_struct *vma,
> > +                                  unsigned long map_flags)
> > +{
> > +       if (map_flags & ~EXT4_SUPPORTED_MAP_FLAGS)
> > +               return -EOPNOTSUPP;
> > +
> > +       /*
> > +        * We don't support synchronous mappings for non-DAX files. At least
> > +        * until someone comes with a sensible use case.
> > +        */
> > +       if (!IS_DAX(file_inode(file)) && (map_flags & MAP_SYNC))
> > +               return -EOPNOTSUPP;
> 
> Perhaps EPERM instead to differentiate the unsupported flags case?
> There's precedent for mmap returning EPERM for reasons other than
> incompatible PROT flags.

Hum, I could make it EINVAL. EPERM looks just too bogus to me.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
