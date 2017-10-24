Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933267AbdJXNIL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 09:08:11 -0400
Date: Tue, 24 Oct 2017 15:08:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/17] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171024130808.GC8556@quack2.suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-2-jack@suse.cz>
 <20171020072707.GA18000@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171020072707.GA18000@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

On Fri 20-10-17 00:27:07, Christoph Hellwig wrote:
> >  	if (file) {
> >  		struct inode *inode = file_inode(file);
> > +		unsigned long flags_mask = file->f_op->mmap_supported_flags;
> > +
> > +		if (!flags_mask)
> > +			flags_mask = LEGACY_MAP_MASK;
> >  
> >  		switch (flags & MAP_TYPE) {
> >  		case MAP_SHARED:
> > +			/*
> > +			 * Silently ignore unsupported flags - MAP_SHARED has
> > +			 * traditionally behaved like that and we don't want
> > +			 * to break compatibility.
> > +			 */
> > +			flags &= flags_mask;
> > +			/*
> > +			 * Force use of MAP_SHARED_VALIDATE with non-legacy
> > +			 * flags. E.g. MAP_SYNC is dangerous to use with
> > +			 * MAP_SHARED as you don't know which consistency model
> > +			 * you will get.
> > +			 */
> > +			flags &= LEGACY_MAP_MASK;
> > +			/* fall through */
> > +		case MAP_SHARED_VALIDATE:
> > +			if (flags & ~flags_mask)
> > +				return -EOPNOTSUPP;
> 
> Hmmm.  I'd expect this to worth more like:
> 
> 		case MAP_SHARED:
> 			/* Ignore all new flags that need validation: */
> 			flags &= LEGACY_MAP_MASK;
> 			/*FALLTHROUGH*/
> 		case MAP_SHARED_VALIDATE:
> 			if (flags & ~file->f_op->mmap_supported_flags)
> 				return -EOPNOTSUPP;
> 
> with the legacy mask always implicitly support as indicated in my
> comment to the XFS patch.

I was thinking about this. Originally I thought that mmap_supported_flags
would allow also to declare some legacy flags as unsupported and also it
seemed as a nicer symmetric interface to me. But I guess the need to mask
out legacy flags is mostly theoretical so I'm fine giving that up. So I'll
change this as you suggest.

> Although even the ignoring in MAP_SHARED seems dangerous, but I guess
> we need that to keep strict backwards compatibility.  In world I'd
> rather do
> 
> 	case MAP_SHARED:
> 		if (flags & ~LEGACY_MAP_MASK)
> 			return -EINVAL;

Yes, I think just ignoring new flags for MAP_SHARED is safer...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
