Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55212 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753018AbdJMHMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 03:12:07 -0400
Date: Fri, 13 Oct 2017 00:12:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171013071203.GA9105@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-2-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

So did we settle on the new mmap_validate vs adding a new argument
to ->mmap for real now?  I have to say I'd much prefer passing an
additional argument instead, but if higher powers rule that out
this version is ok.

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 13dab191a23e..5aee97d64cae 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1701,6 +1701,8 @@ struct file_operations {
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
> +	int (*mmap_validate) (struct file *, struct vm_area_struct *,
> +			unsigned long);

Can we make this return a bool for ok vs not ok?  That way we only
need to have the error code discussion in one place instead of every
file system.
