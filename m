Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPMR95s012823
	for <linux-xfs@oss.sgi.com>; Tue, 25 Nov 2008 16:27:09 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF54015F5511
	for <linux-xfs@oss.sgi.com>; Tue, 25 Nov 2008 14:27:08 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	sTZDwWFD9HF98ay4 for <linux-xfs@oss.sgi.com>;
	Tue, 25 Nov 2008 14:27:08 -0800 (PST)
Date: Wed, 26 Nov 2008 09:27:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: truncated files
Message-ID: <20081125222703.GE6291@disturbed>
References: <200811252244.14718.Martin@Lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200811252244.14718.Martin@Lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@Lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

On Tue, Nov 25, 2008 at 10:44:14PM +0100, Martin Steigerwald wrote:
> 
> Hi!
> 
> Today on one try to hibernate via tuxonice it machine appeared dead. I am 
                      ^^^^^^^^^
When (not if) suspend to disk/resume fails, you get to keep all the broken
pieces of your filesystem. It works most of the time, but it has
some fundamentally broken corner cases that you probably just
hit....

> Similar stuff happened on the encfs encrypted KDE user that I use for 
> professional stuff - encfs is layered on top of XFS via FUSE:

IIRC, FUSE cannot be suspended safely at all, so expect corruption
of FUSE filesystems on a failed suspend.

I've never had a system that suspends reliably (let alone resumes
from the suspend) so it's no real surprise that I don't trust
suspend to disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
