Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC0jNkR063020 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 18:45:23 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 628FA16EE491
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 16:45:21 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xTF93nTbLskH9gxa for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 16:45:21 -0800 (PST)
Date: Mon, 12 Dec 2011 11:45:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair gets stuck on phase3
Message-ID: <20111212004518.GK14273@dastard>
References: <CAENWQX0FgOrTiDVaictZkNfnpBR40DWrHsWrysPHDvdoqvcw5A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAENWQX0FgOrTiDVaictZkNfnpBR40DWrHsWrysPHDvdoqvcw5A@mail.gmail.com>
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
To: Pavol Zibrita <pavol.zibrita@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Dec 11, 2011 at 09:20:14PM +0000, Pavol Zibrita wrote:
> Hi there!
> 
>    After one hard reset, the xfs started to repair the partition and it
> wasn't able to end.
> (I let it running for two weeks...).
> 
> There was info about the log (and -L option), so the partition could not be
> mounted. I tried to do check and repair,
> but it was not working.
> 
> The setup is -> two radi5 raids, lvm, one volume group, one logical volume
> formated as xfs (4TB). Around
> 3,5TB full.
> 
> I tried various option for xfs_repair, but when in phase 3, it just
> calculates and calculates and does nothing.
> CPU is used around 97%.

It appears to be stuck processing an unlinked list (probably
circular due to corruption).

ISTR a patch recently to detect and handle this sort of loop.
Ah, in Christoph'sto-be-reivewed queue:

http://oss.sgi.com/archives/xfs/2011-12/msg00035.html

Specifically:

http://oss.sgi.com/archives/xfs/2011-12/msg00042.html

> Examining the system with knoppix live cd.

Which has what version of xfs_repair on it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
