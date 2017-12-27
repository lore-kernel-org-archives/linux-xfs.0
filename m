Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:40659 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbdL0K0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Dec 2017 05:26:03 -0500
Received: by mail-wm0-f46.google.com with SMTP id f206so38464805wmf.5
        for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2017 02:26:02 -0800 (PST)
Date: Wed, 27 Dec 2017 13:26:00 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 06/78] xarray: Change definition of sibling entries
Message-ID: <20171227102600.vruihaqugwxa25sp@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-7-willy@infradead.org>
 <20171226172153.pylgdefajcrthe3b@node.shutemov.name>
 <20171227031326.GB24828@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171227031326.GB24828@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Tue, Dec 26, 2017 at 07:13:26PM -0800, Matthew Wilcox wrote:
> On Tue, Dec 26, 2017 at 08:21:53PM +0300, Kirill A. Shutemov wrote:
> > > +/**
> > > + * xa_is_internal() - Is the entry an internal entry?
> > > + * @entry: Entry retrieved from the XArray
> > > + *
> > > + * Return: %true if the entry is an internal entry.
> > > + */
> > 
> > What does it mean "internal entry"? Is it just a term for non-value and
> > non-data pointer entry? Do we allow anybody besides xarray implementation to
> > use internal entires?
> > 
> > Do we have it documented?
> 
> We do!  include/linux/radix-tree.h has it documented right now:

Looks good. Thanks.

-- 
 Kirill A. Shutemov
