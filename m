Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38343 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933561AbeCBWxS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 17:53:18 -0500
Date: Fri, 2 Mar 2018 23:53:16 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 02/12] dax: introduce IS_DEVDAX() and IS_FSDAX()
Message-ID: <20180302225316.GC31240@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com> <151996282448.28483.10415125852182473579.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151996282448.28483.10415125852182473579.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

> +static inline bool IS_DEVDAX(struct inode *inode)
> +{
> +	if (!IS_ENABLED(CONFIG_DEV_DAX))
> +		return false;
> +	if ((inode->i_flags & S_DAX) == 0)
> +		return false;
> +	if (!S_ISCHR(inode->i_mode))
> +		return false;
> +	return true;
> +}
> +
> +static inline bool IS_FSDAX(struct inode *inode)
> +{
> +	if (!IS_ENABLED(CONFIG_FS_DAX))
> +		return false;
> +	if ((inode->i_flags & S_DAX) == 0)
> +		return false;
> +	if (S_ISCHR(inode->i_mode))
> +		return false;
> +	return true;

Encoding the is char device or not thing here is just nasty.  I think
this is going entirely in the wrong direction.
