Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54876 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755473AbeDWRSE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:18:04 -0400
Date: Mon, 23 Apr 2018 19:19:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/13] xfs: delegate dqget input checks to helper
        function
Message-ID: <20180423171926.GC834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440957121.29601.1360188076802956985.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440957121.29601.1360188076802956985.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

> +	if (!XFS_IS_QUOTA_RUNNING(mp)) {
> +		ASSERT(0);
> +		return -ESRCH;
> +	}

Maybe something like:

	if (WARN_ON_ONCE(!XFS_IS_QUOTA_RUNNING(mp)))
		return -ESRCH;

here and for the other ASSERT(0) case?

> +	if ((!XFS_IS_UQUOTA_ON(mp) && type == XFS_DQ_USER) ||
> +	    (!XFS_IS_PQUOTA_ON(mp) && type == XFS_DQ_PROJ) ||
> +	    (!XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
> +		return -ESRCH;
> +	}

No need for the curly braces.

> +
> +	if (type != XFS_DQ_USER &&
> +	    type != XFS_DQ_PROJ &&
> +	    type != XFS_DQ_GROUP) {
> +		ASSERT(0);
> +		return -EINVAL;

If we really care about these checks why not structure it as something
like:

	switch (type) {
	case XFS_DQ_USER:
		if (!XFS_IS_UQUOTA_ON(mp))
			return -ESRCH
		return 0;
	case XFS_DQ_PROJ:
		if (!XFS_IS_PQUOTA_ON(mp))
			return -ESRCH
		return 0;
	case XFS_DQ_GROUP:
		if (!XFS_IS_GQUOTA_ON(mp))
			return -ESRCH
		return 0;
	default:
		WARN_ON_ONCE(1);
		return -EINVAL;

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
