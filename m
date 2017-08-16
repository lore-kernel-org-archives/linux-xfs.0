Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:37001 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751580AbdHPLMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 07:12:47 -0400
Received: by mail-wr0-f171.google.com with SMTP id z91so2846268wrc.4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 04:12:47 -0700 (PDT)
Date: Wed, 16 Aug 2017 14:12:44 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
Message-ID: <20170816111244.uxx6kvbi3cn5clqd@node.shutemov.name>
References: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Wed, Aug 16, 2017 at 12:44:28AM -0700, Dan Williams wrote:
> @@ -1411,6 +1422,9 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  
>  			/* fall through */
>  		case MAP_PRIVATE:
> +			if ((flags & (MAP_PRIVATE|MAP_DIRECT))
> +					== (MAP_PRIVATE|MAP_DIRECT))
> +				return -EINVAL;

We've already checked for MAP_PRIVATE in this codepath. Simple (flags &
MAP_DIRECT) would be enough.

-- 
 Kirill A. Shutemov
