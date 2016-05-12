Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45DB87CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 07:20:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4BACAC001
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 05:20:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PZOgNQBUwzecR8TT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 05:20:41 -0700 (PDT)
Date: Thu, 12 May 2016 07:20:39 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v5 1/2] libxcmd: generalize topology functions
Message-ID: <20160512122039.GA19699@redhat.com>
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
	<1463006717-6104-2-git-send-email-billodo@redhat.com>
	<20160512115513.GD32528@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160512115513.GD32528@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, May 12, 2016 at 04:55:13AM -0700, Christoph Hellwig wrote:
> I still think libxfs would be the better place, but otherwise this looks
> fine in general.
> 
> > +#ifdef ENABLE_BLKID
> > +#  include <blkid/blkid.h>
> > +#endif /* ENABLE_BLKID */
> > +#include "xfs_multidisk.h"
> 
> But what tree is this against?  I can't find a xfs_multidisk.h in
> the master branch, nor in this patch?

xfs_multidisk.h came about a few days ago (4a32b9e928b80)
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
