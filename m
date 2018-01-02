Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55338 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbeABSIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 13:08:43 -0500
Date: Tue, 2 Jan 2018 10:01:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5 03/78] xarray: Add the xa_lock to the radix_tree_root
Message-ID: <20180102180155.GD4857@magnolia>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-4-willy@infradead.org>
 <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
 <20171227034340.GC24828@bombadil.infradead.org>
 <20171227035815.GD24828@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171227035815.GD24828@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 07:58:15PM -0800, Matthew Wilcox wrote:
> On Tue, Dec 26, 2017 at 07:43:40PM -0800, Matthew Wilcox wrote:
> >     Also add the xa_lock() and xa_unlock() family of wrappers to make it
> >     easier to use the lock.  If we could rely on -fplan9-extensions in
> >     the compiler, we could avoid all of this syntactic sugar, but that
> >     wasn't added until gcc 4.6.
> 
> Oh, in case anyone's wondering, here's how I'd do it with plan9 extensions:
> 
> struct xarray {
>         spinlock_t;
>         int xa_flags;
>         void *xa_head;
> };
> 
> ...
>         spin_lock_irqsave(&mapping->pages, flags);
>         __delete_from_page_cache(page, NULL);
>         spin_unlock_irqrestore(&mapping->pages, flags);
> ...
> 
> The plan9 extensions permit passing a pointer to a struct which has an
> unnamed element to a function which is expecting a pointer to the type
> of that element.  The compiler does any necessary arithmetic to produce 
> a pointer.  It's exactly as if I had written:
> 
>         spin_lock_irqsave(&mapping->pages.xa_lock, flags);
>         __delete_from_page_cache(page, NULL);
>         spin_unlock_irqrestore(&mapping->pages.xa_lock, flags);
> 
> More details here: https://9p.io/sys/doc/compiler.html

I read the link, and I understand (from section 3.3) that replacing
foo.bar.baz.goo with foo.goo is less typing, but otoh the first time I
read your example above I thought "we're passing (an array of pages |
something that doesn't have the word 'lock' in the name) to
spin_lock_irqsave? wtf?"

I suppose it does force me to go dig into whatever mapping->pages is to
figure out that there's an unnamed spinlock_t and that the compiler can
insert the appropriate pointer arithmetic, but now my brain trips over
'pages' being at the end of the selector for parameter 1 which slows
down my review reading...

OTOH I guess it /did/ motivate me to click the link, so well played,
sir. :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
