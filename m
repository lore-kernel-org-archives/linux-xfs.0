Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53833 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdJTH1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 03:27:08 -0400
Date: Fri, 20 Oct 2017 00:27:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/17] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171020072707.GA18000@infradead.org>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019125817.11580-2-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org

>  	if (file) {
>  		struct inode *inode = file_inode(file);
> +		unsigned long flags_mask = file->f_op->mmap_supported_flags;
> +
> +		if (!flags_mask)
> +			flags_mask = LEGACY_MAP_MASK;
>  
>  		switch (flags & MAP_TYPE) {
>  		case MAP_SHARED:
> +			/*
> +			 * Silently ignore unsupported flags - MAP_SHARED has
> +			 * traditionally behaved like that and we don't want
> +			 * to break compatibility.
> +			 */
> +			flags &= flags_mask;
> +			/*
> +			 * Force use of MAP_SHARED_VALIDATE with non-legacy
> +			 * flags. E.g. MAP_SYNC is dangerous to use with
> +			 * MAP_SHARED as you don't know which consistency model
> +			 * you will get.
> +			 */
> +			flags &= LEGACY_MAP_MASK;
> +			/* fall through */
> +		case MAP_SHARED_VALIDATE:
> +			if (flags & ~flags_mask)
> +				return -EOPNOTSUPP;

Hmmm.  I'd expect this to worth more like:

		case MAP_SHARED:
			/* Ignore all new flags that need validation: */
			flags &= LEGACY_MAP_MASK;
			/*FALLTHROUGH*/
		case MAP_SHARED_VALIDATE:
			if (flags & ~file->f_op->mmap_supported_flags)
				return -EOPNOTSUPP;

with the legacy mask always implicitly support as indicated in my
comment to the XFS patch.

Although even the ignoring in MAP_SHARED seems dangerous, but I guess
we need that to keep strict backwards compatibility.  In world I'd
rather do

	case MAP_SHARED:
		if (flags & ~LEGACY_MAP_MASK)
			return -EINVAL;


