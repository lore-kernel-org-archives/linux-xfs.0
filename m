Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o25A5Nj5240058 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 04:05:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15CD91D177AD
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 02:06:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id llEAqupLQnwijquY for
	<xfs@oss.sgi.com>; Fri, 05 Mar 2010 02:06:52 -0800 (PST)
Date: Fri, 5 Mar 2010 05:06:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: return inode fork offset in bulkstat for fsr
Message-ID: <20100305100652.GA1105@infradead.org>
References: <1267764074-30733-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267764074-30733-1-git-send-email-david@fromorbit.com>
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

On Fri, Mar 05, 2010 at 03:41:14PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So that fsr can attempt to get the fork offset of the temporary
> inode it uses the same as the inode it is defragmenting, pass
> the fork offset out in the bulkstat information.
> 
> The bulkstat structure has padding that has always been zeroed,
> so userspace can tell if this field is set or not by use of
> the xattr present flag and a non-zero value for the fork offset.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
