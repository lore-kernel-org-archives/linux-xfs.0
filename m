Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E6YFox233570 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 00:34:18 -0600
Date: Thu, 14 Jan 2010 01:35:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: xfs_swap_extents needs to handle dynamic fork offsets
Message-ID: <20100114063510.GA20445@infradead.org>
References: <20100112130922.GA30985@infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A6965@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6965@cf--amer001e--3.americas.sgi.com>
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

On Wed, Jan 13, 2010 at 04:32:12PM -0600, Alex Elder wrote:
> Christoph Hellwig wrote:
> >> +	TP_printk("dev %d:%d %s inode 0x%llx, %s format, num_extents %d, "
> >> +		  "Max in-fork extents %d, broot size %d, fork offset %d",
> > 
> > It would be nice to keep the
> > 
> > 	"dev %d:%d ino 0x%llx"
> > 
> > prefix as a convention so that all trace records are similar at their
> > beginning.
> 
> Perhaps:
>     +	TP_printk("dev %d:%d inode 0x%llx (%s), %s format, num_extents %d, " 
>                                           ^
>                                           +--- symbolic entry->which

Sounds fine, except s/inode/ino/ above to stay consistant.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
