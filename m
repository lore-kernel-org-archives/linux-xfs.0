Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBRLQQvu205611 for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 15:26:27 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FFF91C1C256
	for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 13:27:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	9SRZ7Gx1FuE5LxAQ for <xfs@oss.sgi.com>;
	Sun, 27 Dec 2009 13:27:08 -0800 (PST)
Date: Mon, 28 Dec 2009 08:27:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: lockdep: inconsistent lock state
Message-ID: <20091227212700.GA7613@discord.disaster>
References: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Dec 26, 2009 at 01:07:49PM -0800, Christian Kujau wrote:
> Hi,
> 
> during tests with bonnie++ on an XFS filesystem, the warning below is 
> issued. From the message's timestamps, the warning occurs during the 
> "Create files in sequential order" phase. I've put a few more details and 
> the config here: http://nerdbynature.de/bits/2.6.33-rc2/xfs_ilock
> 
> Something similar has been reported in http://lkml.org/lkml/2009/2/20/269 
> (for 2.6.29-rc5) and a fix for this false positive made its way into 
> mainline as ed93ec3907f063268ced18728d0653f6199d100c - so I take it this 
> is a different issue then?

This is the usual false positive that is detected - XFS takes locks in
reclaim that it also takes in non-reclaim paths. The reclaim path
from kswapd inverts lock ordering and so we get this report. This
case has never been a deadlock case because an inode in reclaim
cannot be referenced by any other path, so once again it is a
false positive....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
