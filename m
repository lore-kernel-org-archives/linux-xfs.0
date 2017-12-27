Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdL0Dnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Dec 2017 22:43:42 -0500
Date: Tue, 26 Dec 2017 19:43:40 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 03/78] xarray: Add the xa_lock to the radix_tree_root
Message-ID: <20171227034340.GC24828@bombadil.infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-4-willy@infradead.org>
 <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171226165440.tv6inwa2fgk3bfy6@node.shutemov.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 07:54:40PM +0300, Kirill A. Shutemov wrote:
> On Fri, Dec 15, 2017 at 02:03:35PM -0800, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > 
> > This results in no change in structure size on 64-bit x86 as it fits in
> > the padding between the gfp_t and the void *.
> 
> The patch does more than described in the subject and commit message. At first
> I was confused why do you need to touch idr here. It took few minutes to figure
> it out.
> 
> Could you please add more into commit message about lockname and xa_ locking
> interface since you introduce it here?

Sure!  How's this?

    xarray: Add the xa_lock to the radix_tree_root
    
    This results in no change in structure size on 64-bit x86 as it fits in
    the padding between the gfp_t and the void *.
    
    Initialising the spinlock requires a name for the benefit of lockdep,
    so RADIX_TREE_INIT() now needs to know the name of the radix tree it's
    initialising, and so do IDR_INIT() and IDA_INIT().
    
    Also add the xa_lock() and xa_unlock() family of wrappers to make it
    easier to use the lock.  If we could rely on -fplan9-extensions in
    the compiler, we could avoid all of this syntactic sugar, but that
    wasn't added until gcc 4.6.

