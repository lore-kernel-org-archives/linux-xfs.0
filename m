Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:3939 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726373AbfHNHAy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Aug 2019 03:00:54 -0400
Date: Wed, 14 Aug 2019 15:17:54 +0800
From: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v3] vfs: fix page locking deadlocks when deduping files
Message-ID: <20190814071754.GC28602@138>
References: <20190813151434.GQ7138@magnolia>
 <20190813154010.GD5307@bombadil.infradead.org>
 <20190814070321.GB28602@138>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190814070321.GB28602@138>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Aug 14, 2019 at 03:03:21PM +0800, Gao Xiang wrote:
> On Tue, Aug 13, 2019 at 08:40:10AM -0700, Matthew Wilcox wrote:
> > On Tue, Aug 13, 2019 at 08:14:34AM -0700, Darrick J. Wong wrote:
> > > +		/*
> > > +		 * Now that we've locked both pages, make sure they still
> > > +		 * represent the data we're interested in.  If not, someone
> > > +		 * is invalidating pages on us and we lose.
> > > +		 */
> > > +		if (src_page->mapping != src->i_mapping ||
> > > +		    src_page->index != srcoff >> PAGE_SHIFT ||
> > > +		    dest_page->mapping != dest->i_mapping ||
> > > +		    dest_page->index != destoff >> PAGE_SHIFT) {
> > > +			same = false;
> > > +			goto unlock;
> > > +		}
> > 
> > It is my understanding that you don't need to check the ->index here.
> > If I'm wrong about that, I'd really appreciate being corrected, because
> > the page cache locking is subtle.
> > 
> > You call read_mapping_page() which returns the page with an elevated
> > refcount.  That means the page can't go back to the page allocator and
> > be allocated again.  It can, because it's unlocked, still be truncated,
> > so the check for ->mapping after locking it is needed.  But the check
> > for ->index being correct was done by find_get_entry().
> > 
> > See pagecache_get_page() -- if we specify FGP_LOCK, then it will lock
> > the page, check the ->mapping but not check ->index.  OK, it does check
> > ->index, but in a VM_BUG_ON(), so it's not something that ought to be
> > able to be wrong.
> 
> That is my understanding as well. In details...
> 
> The page data get ready after read_mapping_page() is successfully
> returned. However, if someone needs to get a stable untruncated page,
> lock_page() and recheck page->mapping are needed as well.
> 
> I have no idea how page->index can be changed safely without reallocating
> the page, even some paths could keep using some truncated page temporarily
> with some refcounts held but I think those paths cannot add these pages

Such a case is like that even if the page can be truncated
at the same time without locking, some paths only needs to
get its page data unstrictly (and note that these pages
should be Uptodated before). Therefore those paths can
only take a refcount without PG_lock... But such refcounts
should be used temporarily, those pages cannot be added to
page cache again without reallocating...

Thanks,
Gao Xiang

> directly to some page cache again without freeing since it seems really
> unsafe.....
> 
> Thanks,
> Gao Xiang
> 
> > 
