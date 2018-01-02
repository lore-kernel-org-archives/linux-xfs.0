Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbeABWlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 17:41:40 -0500
Date: Tue, 2 Jan 2018 14:41:37 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 03/78] xarray: Add the xa_lock to the radix_tree_root
Message-ID: <20180102224137.GC20405@bombadil.infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-4-willy@infradead.org>
 <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
 <20171227034340.GC24828@bombadil.infradead.org>
 <20171227035815.GD24828@bombadil.infradead.org>
 <20180102180155.GD4857@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180102180155.GD4857@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Jan 02, 2018 at 10:01:55AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 26, 2017 at 07:58:15PM -0800, Matthew Wilcox wrote:
> >         spin_lock_irqsave(&mapping->pages, flags);
> >         __delete_from_page_cache(page, NULL);
> >         spin_unlock_irqrestore(&mapping->pages, flags);
> >
> > More details here: https://9p.io/sys/doc/compiler.html
> 
> I read the link, and I understand (from section 3.3) that replacing
> foo.bar.baz.goo with foo.goo is less typing, but otoh the first time I
> read your example above I thought "we're passing (an array of pages |
> something that doesn't have the word 'lock' in the name) to
> spin_lock_irqsave? wtf?"

I can see that being a bit jarring initially.  If you think about what
object-oriented languages were offering in the nineties, this is basically
C++ multiple-inheritance / Java interfaces.  So when I read the above
example, I think "lock the mapping pages, delete from page cache, unlock
the mapping pages", and I don't have a wtf moment.  It's just simpler to
read than "lock the mapping pages lock", and less redundant.

> I suppose it does force me to go dig into whatever mapping->pages is to
> figure out that there's an unnamed spinlock_t and that the compiler can
> insert the appropriate pointer arithmetic, but now my brain trips over
> 'pages' being at the end of the selector for parameter 1 which slows
> down my review reading...
> 
> OTOH I guess it /did/ motivate me to click the link, so well played,
> sir. :)

Now if only I can trick you into giving your ACK on patch 1,
"xfs: Rename xa_ elements to ail_"
