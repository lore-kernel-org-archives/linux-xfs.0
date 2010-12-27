Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBR2H70i247973 for <xfs@oss.sgi.com>; Sun, 26 Dec 2010 20:17:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70C7F1530F95
	for <xfs@oss.sgi.com>; Sun, 26 Dec 2010 18:19:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	lC06ihmMYz7Bbj6G for <xfs@oss.sgi.com>;
	Sun, 26 Dec 2010 18:19:07 -0800 (PST)
Date: Mon, 27 Dec 2010 13:19:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfssyncd and disk spin down
Message-ID: <20101227021904.GA24828@dastard>
References: <20101223165532.GA23813@peter.simplex.ro>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101223165532.GA23813@peter.simplex.ro>
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
To: Petre Rodan <petre.rodan@simplex.ro>
Cc: xfs@oss.sgi.com

On Thu, Dec 23, 2010 at 06:55:32PM +0200, Petre Rodan wrote:
> 
> Hello,
> 
> I have a problem with a hard drive that never managed to spin
> down. this drive is a storage space, not a system disk, the only
> thing that generated writes is the nfs server that exports its
> contents. it has only one large xfs partition on it.
> 
> upon closer inspection it turns out that after the first Write
> action to that partition, an xfssyncd process continues to write
> to that partition each 36 seconds and it doesn't stop doing that,
> even if there are no more Writes from the exterior. this keeps the
> drive busy with varying consequences. more about that later.

Should be fixed in 2.6.37 by the commit:

1a387d3 xfs: dummy transactions should not dirty VFS state

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
