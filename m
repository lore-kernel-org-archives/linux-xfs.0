Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394563AbfBNIP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 03:15:56 -0500
Date: Thu, 14 Feb 2019 00:15:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: don't ever put nlink > 0 inodes on the unlinked
 list
Message-ID: <20190214081556.GB5961@infradead.org>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
 <155009105350.32028.13101526675073908023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155009105350.32028.13101526675073908023.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 13, 2019 at 12:50:53PM -0800, Darrick J. Wong wrote:
> +	if (tmpfile) {
> +		/*
> +		 * The VFS requires that any inode fed to d_tmpfile must have
> +		 * nlink == 1 so that it can decrement the nlink in d_tmpfile.
> +		 * However, we created the temp file with nlink == 0 because
> +		 * we're not allowed to put an inode with nlink > 0 on the
> +		 * unlinked list.  Therefore we have to set nlink to 1 so that
> +		 * d_tmpfile can immediately set it back to zero.
> +		 */
> +		set_nlink(inode, 1);
>  		d_tmpfile(dentry, inode);
> +	} else

At least btrtfs has to work around these d_tmpfile assumptions as well.
Instead of piling hacks over hacks I'd rather move the call to
inode_dec_link_count from d_tmpfile, which should lead to a saner
interface.
