Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89KNfLM058364 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 15:23:41 -0500
Subject: Re: [PATCH 12/25] xfs: rename xfs_bmapi to xfs_bmapi_write
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060642.912147073@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060642.912147073@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 15:23:34 -0500
Message-ID: <1315599814.1999.56.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-bmapi-rename-xfs_bmapi)
> Once this is done, rename xfs_bmapi to xfs_bmapi_write to reflect the fact it
> is for allocation only. This enables us to kill the XFS_BMAPI_WRITE flag as
> well.
> 
> Also clean up xfs_bmapi_write to the style used in the newly added
> xfs_bmapi_read/delay functions.


I have a few spelling corrections, otherwise this
is just beautiful.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> @@ -4806,60 +4805,57 @@ xfs_bmapi_convert_unwritten(
>  }
>  
>  /*
> - * Map file blocks to filesystem blocks.
> - * File range is given by the bno/len pair.
> - * Adds blocks to file if a write ("flags & XFS_BMAPI_WRITE" set)
> - * into a hole or past eof.
> - * Only allocates blocks from a single allocation group,
> - * to avoid locking problems.
> + * Map file blocks to filesystem blocks, and allocate blocks or convert the
> + * extent state if nessecary.  Details behaviour is controlled by the flags
                     necessary.  Detailed
> + * paramter.  Only allocates blocks from a single allocation group, to avoid
     parameter

> + * locking problems.
> + *


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
