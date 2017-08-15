Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33238 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdHOJSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 05:18:39 -0400
Received: by mail-wm0-f65.google.com with SMTP id q189so837815wmd.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 02:18:39 -0700 (PDT)
Date: Tue, 15 Aug 2017 12:18:36 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
Message-ID: <20170815091836.c3xpsfgfwz7w35od@node.shutemov.name>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: darrick.wong@oracle.com, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Mon, Aug 14, 2017 at 11:12:22PM -0700, Dan Williams wrote:
> MAP_DIRECT is an mmap(2) flag with the following semantics:
> 
>   MAP_DIRECT
>   In addition to this mapping having MAP_SHARED semantics, successful
>   faults in this range may assume that the block map (logical-file-offset
>   to physical memory address) is pinned for the lifetime of the mapping.
>   Successful MAP_DIRECT faults establish mappings that bypass any kernel
>   indirections like the page-cache. All updates are carried directly
>   through to the underlying file physical blocks (modulo cpu cache
>   effects).
> 
>   ETXTBSY is returned on attempts to change the block map (allocate blocks
>   / convert unwritten extents / break shared extents) in the mapped range.
>   Some filesystems may extend these same restrictions outside the mapped
>   range and return ETXTBSY to any file operations that might mutate the
>   block map. MAP_DIRECT faults may fail with a SIGSEGV if the filesystem
>   needs to write the block map to satisfy the fault. For example, if the
>   mapping was established over a hole in a sparse file.

We had issues before with user-imposed ETXTBSY. See MAP_DENYWRITE.

Are we sure it won't a source of denial-of-service attacks?

>   The kernel ignores attempts to mark a MAP_DIRECT mapping MAP_PRIVATE and
>   will silently fall back to MAP_SHARED semantics.

Hm.. Any reason for this strage behaviour? Looks just broken to me.

> 
>   ERRORS
>   EACCES A MAP_DIRECT mapping was requested and PROT_WRITE was not set.
> 
>   EINVAL MAP_ANONYMOUS was specified with MAP_DIRECT.
> 
>   EOPNOTSUPP The filesystem explicitly does not support the flag
> 
>   SIGSEGV Attempted to write a MAP_DIRECT mapping at a file offset that
>           might require block-map updates.

I think it should be SIGBUS.

-- 
 Kirill A. Shutemov
