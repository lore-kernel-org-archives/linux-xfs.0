Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A91447CA1
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 06:55:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6CEA08F8059
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 04:55:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 1jQ5IFmw8k8qnPVT (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 04:55:14 -0700 (PDT)
Date: Thu, 12 May 2016 04:55:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 1/2] libxcmd: generalize topology functions
Message-ID: <20160512115513.GD32528@infradead.org>
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
	<1463006717-6104-2-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463006717-6104-2-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Bill O'Donnell <billodo@redhat.com>
Cc: xfs@oss.sgi.com

I still think libxfs would be the better place, but otherwise this looks
fine in general.

> +#ifdef ENABLE_BLKID
> +#  include <blkid/blkid.h>
> +#endif /* ENABLE_BLKID */
> +#include "xfs_multidisk.h"

But what tree is this against?  I can't find a xfs_multidisk.h in
the master branch, nor in this patch?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
