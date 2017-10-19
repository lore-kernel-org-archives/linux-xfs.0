Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42789 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdJSNRh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:17:37 -0400
Date: Thu, 19 Oct 2017 15:17:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Message-ID: <20171019131735.GC20645@lst.de>
References: <20171019125817.11580-1-jack@suse.cz> <20171019125817.11580-18-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019125817.11580-18-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>

> +#define XFS_MAP_SUPPORTED (LEGACY_MAP_MASK | MAP_SYNC)

I'd kill this define.  Also is there any good reason that we have
to add LEGACY_MAP_MASK instead of assuming it's supported in the
core?

>  #endif
>  	.mmap		= xfs_file_mmap,
> +	.mmap_supported_flags	= XFS_MAP_SUPPORTED,
>  	.open		= xfs_file_open,
>  	.release	= xfs_file_release,
>  	.fsync		= xfs_file_fsync,

I usually either reformat all members to be aligned again, or if that's
too much churn (in this case it probably is) just use a single space
before the = to minimize the alignment differences.

Otherwise your changes look good to me.
