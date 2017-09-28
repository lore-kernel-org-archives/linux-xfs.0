Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43328 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752467AbdI1R5z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Sep 2017 13:57:55 -0400
Date: Thu, 28 Sep 2017 13:57:48 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 3/4] ext4: Add iomap support for inline data
Message-ID: <20170928175748.23b7wkjiqavpunvj@thunk.org>
References: <20170914095047.23935-1-agruenba@redhat.com>
 <20170914095047.23935-4-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170914095047.23935-4-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 14, 2017 at 11:50:46AM +0200, Andreas Gruenbacher wrote:
> +int ext4_inline_data_iomap(struct inode *inode, struct iomap *iomap)
> +{
> +	__u64 addr;
> +	int error = -EAGAIN;
> +	struct ext4_iloc iloc;
> +
> +	down_read(&EXT4_I(inode)->xattr_sem);
> +	if (!ext4_has_inline_data(inode))
> +		goto out;
	....
> +out:
> +	up_read(&EXT4_I(inode)->xattr_sem);
> +	return error;
> +}


If we race with the inline data flag getting cleared,
ext4_iomap_begin() will return with -EAGAIN.  As near as I can tell,
this will get reflected all the way up to userspace, instead of having
the retry happen in the kernel.  Is this intentional?

It looks like a user visible change, no?

						- Ted
