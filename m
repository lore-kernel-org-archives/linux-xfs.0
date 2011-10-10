Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AEEc2k181795 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 09:14:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3C1255F86E
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 07:14:37 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jvIRb27YykEMwTaa for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 07:14:37 -0700 (PDT)
Date: Mon, 10 Oct 2011 10:14:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] repair: handle memory allocation failure from
	blkmap_grow
Message-ID: <20111010141437.GC31429@infradead.org>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318208915-14975-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 12:08:33PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If blkmap_grow fails to allocate a new chunk of memory, it returns
> with a null blkmap. The sole caller of blkmap_grow does not check
> for this failure, and so will segfault if this error ever occurs.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Two comments on the code not directly related to your change:

 - it seems like xfs_db has another copy of these blkmap routines,
   which even missed the last round of updates during the repair
   scalability work.  It seems like it should be switched to reuse
   the repair code
 - growing the map by four seems to be incredibly inefficient for
   large files.  Given that the only caller actually knows how many
   entries it processes in that batch we should grow it at least by
   the number, reducing the allocations to one per call to
   process_bmbt_reclist_int.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
