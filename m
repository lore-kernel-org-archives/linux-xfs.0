Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45886 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752273AbeCVH1g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 03:27:36 -0400
Date: Thu, 22 Mar 2018 08:27:34 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 13/14] xfs: prepare xfs_break_layouts() for another
        layout type
Message-ID: <20180322072734.GB28713@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com> <152167310580.5268.18270880990191450094.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152167310580.5268.18270880990191450094.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz

> +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
> +				| (reason == BREAK_UNMAPI
> +					? XFS_MMAPLOCK_EXCL : 0)));

please split the assert, e.g.:

	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));

	switch (reason) {
+	case BREAK_UNMAPI:
		ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
> +		/* fall through */
> +	case BREAK_WRITE:
> +		error = xfs_break_leased_layouts(inode, iolock, &did_unlock);
> +		break;
> +	default:
> +		error = -EINVAL;
> +		break;
> +	}
> +
> +	return error;

I have to say I'd prefer BREAK_UNMAP over BREAK_UNMAPI given that weird
I suffix doesn't buy us anything, but that's just a minor issue.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
