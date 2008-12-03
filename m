Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB33O6HS011297 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 21:24:06 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C0B6166D60E
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 19:24:05 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	5SYTt2DNo1yhlHbI for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2008 19:24:05 -0800 (PST)
Date: Wed, 3 Dec 2008 14:24:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Disk full during delayed allocation
Message-ID: <20081203032402.GT18236@disturbed>
References: <alpine.LNX.1.10.0812022055550.14216@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0812022055550.14216@fbirervta.pbzchgretzou.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2008 at 09:02:25PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> on space-constrained filesystems, I noticed that extracting lots of 
> files [about 10k] bumps the Used count up quickly leading to a disk full 
> unless the extraction process (rpm here) is halted, synced, and then 
> continued. I believe this is fully within XFS's standard behavior, but I 
> would like to learn more how exactly this can happen.

Outstanding delayed allocation has reservations for metadata blocks
that *may* be required to do the delayed allocation. most delalloc's
don't require metadata blocks to be allocated and hence when the
data is sync'd the reservation is freed and there is "magically"
more space available.

> My guess is that 
> this is due to the "dynamic journal/log" size XFS employs

It is not dynamic. The XFS journal size is fixed at mkfs time - it's
just that it is sized according to the size of the filesystem being
made....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
