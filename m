Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:40574 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbdLZQ40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Dec 2017 11:56:26 -0500
Received: by mail-wm0-f50.google.com with SMTP id f206so35624535wmf.5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Dec 2017 08:56:26 -0800 (PST)
Date: Tue, 26 Dec 2017 19:56:24 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 04/78] page cache: Use xa_lock
Message-ID: <20171226165624.vdarbqqx5czgeqxc@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215220450.7899-5-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

On Fri, Dec 15, 2017 at 02:03:36PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Remove the address_space ->tree_lock and use the xa_lock newly added to
> the radix_tree_root.  Rename the address_space ->page_tree to ->pages,
> since we don't really care that it's a tree.  Take the opportunity to
> rearrange the elements of address_space to pack them better on 64-bit,
> and make the comments more useful.

The description sounds a lot like three commits ;)

-- 
 Kirill A. Shutemov
