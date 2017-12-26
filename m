Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37287 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdLZRV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Dec 2017 12:21:56 -0500
Received: by mail-wm0-f67.google.com with SMTP id f140so35753235wmd.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Dec 2017 09:21:55 -0800 (PST)
Date: Tue, 26 Dec 2017 20:21:53 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 06/78] xarray: Change definition of sibling entries
Message-ID: <20171226172153.pylgdefajcrthe3b@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215220450.7899-7-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Fri, Dec 15, 2017 at 02:03:38PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Instead of storing a pointer to the slot containing the canonical entry,
> store the offset of the slot.  Produces slightly more efficient code
> (~300 bytes) and simplifies the implementation.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  include/linux/xarray.h | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/radix-tree.c       | 65 +++++++++++----------------------------
>  2 files changed, 100 insertions(+), 47 deletions(-)
> 
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index 49fffc354431..f175350560fd 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -49,6 +49,17 @@ static inline bool xa_is_value(const void *entry)
>  	return (unsigned long)entry & 1;
>  }
>  
> +/**
> + * xa_is_internal() - Is the entry an internal entry?
> + * @entry: Entry retrieved from the XArray
> + *
> + * Return: %true if the entry is an internal entry.
> + */

What does it mean "internal entry"? Is it just a term for non-value and
non-data pointer entry? Do we allow anybody besides xarray implementation to
use internal entires?

Do we have it documented?

-- 
 Kirill A. Shutemov
