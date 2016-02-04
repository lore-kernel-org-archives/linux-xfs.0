Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46D5B7CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 09:52:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2864C304048
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 07:52:03 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	FM16NqOHe6WJ81t5 for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 07:51:59 -0800 (PST)
Date: Thu, 4 Feb 2016 08:50:39 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: dirty inode only if required
Message-ID: <20160204155039.GA17818@linux.intel.com>
References: <87k2mkr2ud.fsf@openvz.org> <20160204143344.GA6895@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160204143344.GA6895@quack.suse.cz>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Thu, Feb 04, 2016 at 03:33:44PM +0100, Jan Kara wrote:
> On Thu 04-02-16 17:02:02, Dmitry Monakhov wrote:
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Makes sense. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Looks good to me as well.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> 								Honza
> > ---
> >  fs/dax.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index e0e9358..fc2e314 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -358,7 +358,8 @@ static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
> >  	void *entry;
> >  
> >  	WARN_ON_ONCE(pmd_entry && !dirty);
> > -	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> > +	if (dirty)
> > +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> >  
> >  	spin_lock_irq(&mapping->tree_lock);
> >  
> > -- 
> > 1.8.3.1
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
