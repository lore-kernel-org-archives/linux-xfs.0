Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KAPDF3086499 for <xfs@oss.sgi.com>; Fri, 20 May 2011 05:25:13 -0500
Date: Fri, 20 May 2011 06:25:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: add a reference count to the CIL context
Message-ID: <20110520102511.GB18199@infradead.org>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.508745503@bombadil.infradead.org>
	<1305842094.2825.89.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305842094.2825.89.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, May 19, 2011 at 04:54:54PM -0500, Alex Elder wrote:
> >  #include "xfs_log.h"
> > -#include "xfs_inum.h"
> > +#include "xfs_inum.h" 
> >  #include "xfs_trans.h"
> >  #include "xfs_trans_priv.h"
> >  #include "xfs_log_priv.h"
> 
> Kill this hunk.  (You added a space at end-of-line.)

Yeah, sorry.  not sure how that happened.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
