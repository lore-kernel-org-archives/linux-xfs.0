Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0VAvt8W092312 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 04:57:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49B97189F8AF
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 02:57:14 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3iSLqPRKOPGrzuoI for
	<xfs@oss.sgi.com>; Sat, 31 Jan 2009 02:57:14 -0800 (PST)
Date: Sat, 31 Jan 2009 05:57:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090131105712.GA30061@infradead.org>
References: <498376CF.8020806@renderforce.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <498376CF.8020806@renderforce.de>
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
To: Steffen Knauf <Steffen.Knauf@renderforce.de>
Cc: xfs@oss.sgi.com

On Fri, Jan 30, 2009 at 10:53:19PM +0100, Steffen Knauf wrote:
> Hello,
>
> after a raid crash (Raid Controller problem, 3 Disks of the Disk Group  
> were kicked out oft the diskgroup), 2 of 3 partitions (XFS FS) were  
> shutdown immediately.
> Perhaps somebody has a idea, what's the best solution (xfs_repair?).

This looks like you were running with a write back cache enabled on the
controller / disks but without barriers.  xfs_repair should be able
to repair the filesystem.  If you're lucky only the freespace-btrees
are corrupted (as in the trace below) as xfs_repair can rebuild them
from scratch. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
