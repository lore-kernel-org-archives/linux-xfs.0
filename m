Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34377 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdL0DFg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Dec 2017 22:05:36 -0500
Date: Tue, 26 Dec 2017 19:05:34 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 05/78] xarray: Replace exceptional entries
Message-ID: <20171227030534.GA24828@bombadil.infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-6-willy@infradead.org>
 <20171226171542.v25xieedd46y5peu@node.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171226171542.v25xieedd46y5peu@node.shutemov.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 08:15:42PM +0300, Kirill A. Shutemov wrote:
> >  28 files changed, 249 insertions(+), 240 deletions(-)
> 
> Everything looks fine to me after quick scan, but hat's a lot of changes for
> one patch...

Yeah.  It's pretty mechanical though.

> > -			if (radix_tree_exceptional_entry(page)) {
> > +			if (xa_is_value(page)) {
> >  				if (!invalidate_exceptional_entry2(mapping,
> >  								   index, page))
> >  					ret = -EBUSY;
> 
> invalidate_exceptional_entry? Are we going to leave the terminology here as is?

That is a great question.  If the page cache wants to call its value
entries exceptional entries, it can continue to do that.  I think there's
a better name for them, but I'm not sure what it is.  Right now, the
page cache uses value entries to store:

1. Shadow entries (for workingset)
2. Swap entries (for shmem)
3. DAX entries

I can't come up with a good name for these three things.  'nonpage' is
the only thing which hasn't immediately fallen off my ideas list.  But
I think renaming exceptional entries in the page cache is a great idea,
and I don't want to do it as part of this patch set ;-)
