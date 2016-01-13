Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 638277F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:08:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C0A08F8054
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:08:36 -0800 (PST)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	ROgHYDcUBaNtutUw for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 23:08:31 -0800 (PST)
Date: Wed, 13 Jan 2016 00:08:29 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v8 1/9] dax: fix NULL pointer dereference in __dax_dbg()
Message-ID: <20160113070829.GA30496@linux.intel.com>
References: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
	<1452230879-18117-2-git-send-email-ross.zwisler@linux.intel.com>
	<20160112093458.GR6262@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112093458.GR6262@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Tue, Jan 12, 2016 at 10:34:58AM +0100, Jan Kara wrote:
> On Thu 07-01-16 22:27:51, Ross Zwisler wrote:
> > In __dax_pmd_fault() we currently assume that get_block() will always set
> > bh.b_bdev and we unconditionally dereference it in __dax_dbg().  This
> > assumption isn't always true - when called for reads of holes
> > ext4_dax_mmap_get_block() returns a buffer head where bh->b_bdev is never
> > set.  I hit this BUG while testing the DAX PMD fault path.
> > 
> > Instead, initialize bh.b_bdev before passing bh into get_block().  It is
> > possible that the filesystem's get_block() will update bh.b_bdev, and this
> > is fine - we just want to initialize bh.b_bdev to something reasonable so
> > that the calls to __dax_dbg() work and print something useful.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> 
> Looks good. But don't you need to do the same for __dax_fault(),
> dax_zero_page_range() and similar places passing bh to dax functions?
> 
> 								Honza

I don't think we need it anywhere else.  The only reason that we need to
initialize the bh.b_bdev manually in the __dax_pmd_fault() path is that if the
get_block() call ends up finding a hole (so doesn't fill out b_bdev) we still
go through the dax_pmd_dbg() path to print an error message, which uses
b_bdev.  I believe that in the other paths where we hit a hole, such as
__dax_fault(), we don't use b_bdev because we don't have the same error path
prints, and the regular code for handling holes doesn't use b_bdev.

That being said, if you feel like it's cleaner to initialize it everywhere so
everything is consistent and we don't have to worry about it, I'm fine to make
the change.

> > ---
> >  fs/dax.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 7af8797..513bba5 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -624,6 +624,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  	}
> >  
> >  	memset(&bh, 0, sizeof(bh));
> > +	bh.b_bdev = inode->i_sb->s_bdev;
> >  	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
> >  
> >  	bh.b_size = PMD_SIZE;
> > -- 
> > 2.5.0
> > 
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
