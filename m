Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBUMgUix060406 for <xfs@oss.sgi.com>; Wed, 30 Dec 2009 16:42:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 835B0132C50
	for <xfs@oss.sgi.com>; Wed, 30 Dec 2009 14:43:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	hk2AODpCWr6zDPB6 for <xfs@oss.sgi.com>;
	Wed, 30 Dec 2009 14:43:17 -0800 (PST)
Date: Thu, 31 Dec 2009 09:43:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] repair: compare superblock / AG headers fields
	against manual counts
Message-ID: <20091230224314.GD13802@discord.disaster>
References: <20091201150503.958283878@bombadil.infradead.org>
	<20091201151037.707510379@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091201151037.707510379@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Dec 01, 2009 at 10:05:06AM -0500, Christoph Hellwig wrote:
> Compare the free block / inode counters in the superblock and AG headers
> against the values we get from a manual btree traversal.  Ported over from
> xfs_db to get the same amount of superblock / AG header checking as in
> xfs_check.
> 
> 
> Note: this causes additional output in the xfstests 030 and 178 which will need
> some adjustments in the testcases.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> @@ -550,6 +583,10 @@ _("%s freespace btree block claimed (sta
>  					lastblock = b;
>  				}
>  			} else {
> +				fdblocks += len;
> +				agffreeblks += len;
> +				if (len > agflongest)
> +					agflongest = len;
>  				if (len < lastcount) {
>  					do_warn(_(
>  	"out-of-order cnt btree record %d (%u %u) block %u/%u\n"),

Might be worth a comment here saying that we are only calculating
totals from the ABTC btree scan. OTOH, is is worth checking that the
two btrees add up to the same number of free blocks, same maximum
length extent, etc?

Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
